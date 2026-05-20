#!/usr/bin/env python3
"""Project a runtime log JSON payload into searchable summary views."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path
from typing import Any


DEFAULT_INPUT = Path("tmp/trace-runtime-log.json")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Project a runtime log JSON payload into summary and failure views."
    )
    parser.add_argument(
        "--input",
        default=str(DEFAULT_INPUT),
        help="Path to a runtime log JSON file.",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Optional JSON output path. Defaults to stdout.",
    )
    parser.add_argument(
        "--fail-only",
        action="store_true",
        help="Keep only failure and warning rows in the projected index.",
    )
    return parser.parse_args()


def load_runtime_log(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def project_runtime_log(source: dict[str, Any], fail_only: bool) -> dict[str, Any]:
    records = source.get("runtime_log", [])
    task_id = source.get("task_id", "")
    artifact_ref = source.get("artifact_ref", "")
    handoff_mode = source.get("handoff_mode", "normal")

    runtime_log_index: list[dict[str, Any]] = []
    failure_queue: list[dict[str, Any]] = []
    runtime_counts: Counter[str] = Counter()
    event_type_counts: Counter[str] = Counter()
    status_counts: Counter[str] = Counter()

    for index, record in enumerate(records, start=1):
        flat = {
            "row": index,
            "task_id": task_id,
            "artifact_ref": artifact_ref,
            "handoff_mode": handoff_mode,
            "timestamp": record.get("timestamp", ""),
            "runtime": record.get("runtime", ""),
            "event_type": record.get("event_type", ""),
            "actor": record.get("actor", ""),
            "span_name": record.get("span_name", ""),
            "message": record.get("message", ""),
            "trace_id": record.get("trace_id", source.get("python_trace_id", "")),
            "span_id": record.get("span_id", ""),
            "parent_span_id": record.get("parent_span_id", ""),
            "status": record.get("status", ""),
            "artifact_ref_row": record.get("artifact_ref", ""),
            "source_script": record.get("source_script", ""),
            "same_trace": record.get("same_trace"),
            "parent_linked": record.get("parent_linked"),
        }
        runtime_counts[flat["runtime"]] += 1
        event_type_counts[flat["event_type"]] += 1
        status_counts[flat["status"] or "unknown"] += 1

        is_failure = (
            flat["status"] not in ("", "ok")
            or flat["same_trace"] is False
            or flat["parent_linked"] is False
        )

        if is_failure:
            failure_queue.append(
                {
                    **flat,
                    "reason": ", ".join(
                        part
                        for part in [
                            "status!=ok" if flat["status"] not in ("", "ok") else "",
                            "same_trace=false" if flat["same_trace"] is False else "",
                            "parent_linked=false" if flat["parent_linked"] is False else "",
                        ]
                        if part
                    ),
                }
            )

        if not fail_only or is_failure:
            runtime_log_index.append(flat)

    summary = {
        "task_id": task_id,
        "artifact_ref": artifact_ref,
        "handoff_mode": handoff_mode,
        "record_count": len(records),
        "failure_count": len(failure_queue),
        "python_trace_id": source.get("python_trace_id", ""),
        "node_trace_id": source.get("node_trace_id", ""),
        "same_trace": source.get("same_trace"),
        "parent_linked": source.get("parent_linked"),
        "runtime_counts": dict(runtime_counts),
        "event_type_counts": dict(event_type_counts),
        "status_counts": dict(status_counts),
    }

    return {
        "summary": summary,
        "runtime_log_index": runtime_log_index,
        "failure_queue": failure_queue,
    }


def main() -> None:
    args = parse_args()
    input_path = Path(args.input).resolve()
    source = load_runtime_log(input_path)
    projected = project_runtime_log(source, fail_only=args.fail_only)
    projected["summary"]["source_input"] = str(input_path)
    output = json.dumps(projected, ensure_ascii=False, indent=2)

    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(output + "\n", encoding="utf-8")
        print(f"Wrote runtime log projection to {output_path}")
    else:
        print(output)


if __name__ == "__main__":
    main()
