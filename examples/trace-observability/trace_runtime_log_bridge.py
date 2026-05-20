#!/usr/bin/env python3
"""Merge Python and Node trace context bridge outputs into a runtime log."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
PY_BRIDGE = ROOT / "trace_context_bridge.py"
NODE_BRIDGE = ROOT / "trace_context_bridge_node.js"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Merge Python and Node trace bridge outputs into a runtime log."
    )
    parser.add_argument(
        "--input-traceparent",
        default="",
        help="Optional incoming W3C traceparent header.",
    )
    parser.add_argument(
        "--task-id",
        default="task-book-runtime-log-001",
        help="Task id to include in the merged runtime log.",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Optional JSON output path. Defaults to stdout.",
    )
    parser.add_argument(
        "--simulate-broken-handoff",
        action="store_true",
        help="Force Node.js to start a fresh trace so the handoff check fails.",
    )
    return parser.parse_args()


def run_json_command(command: list[str]) -> dict[str, Any]:
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    return json.loads(result.stdout)


def build_runtime_log(
    *,
    task_id: str,
    python_result: dict[str, Any],
    node_result: dict[str, Any],
    handoff_mode: str,
) -> dict[str, Any]:
    start = datetime.now(timezone.utc).astimezone()
    current = start
    records: list[dict[str, Any]] = []
    runtime_log_artifact = f"artifact://runtime-log/{task_id}"

    def append_record(runtime: str, event_type: str, message: str, **fields: Any) -> None:
        nonlocal current
        record = {
            "timestamp": current.isoformat(),
            "runtime": runtime,
            "event_type": event_type,
            "message": message,
            "task_id": task_id,
        }
        record.update(fields)
        records.append(record)
        current += timedelta(seconds=1)

    for event in python_result["events"]:
        append_record(
            "python",
            "span",
            f'{event["actor"]}/{event["span_name"]}',
            trace_id=event["trace_id"],
            parent_span_id=event["parent_span_id"],
            span_id=event["span_id"],
            actor=event["actor"],
            span_name=event["span_name"],
            artifact_ref=event["artifact_ref"],
            status="ok",
            source_script="trace_context_bridge.py",
        )

    append_record(
        "bridge",
        "handoff",
        "python -> nodejs via traceparent"
        if handoff_mode == "normal"
        else "python -> nodejs via fresh root (broken handoff)",
        trace_id=python_result["trace_id"],
        status="ok",
        outgoing_traceparent=python_result["events"][-1]["outgoing_carrier"]["traceparent"],
        artifact_ref=runtime_log_artifact,
        source_script="trace_context_bridge.py",
        handoff_mode=handoff_mode,
    )

    for event in node_result["events"]:
        append_record(
            "nodejs",
            "span",
            f'{event["actor"]}/{event["span_name"]}',
            trace_id=event["trace_id"],
            parent_span_id=event["parent_span_id"],
            span_id=event["span_id"],
            actor=event["actor"],
            span_name=event["span_name"],
            artifact_ref=event["artifact_ref"],
            status="ok",
            source_script="trace_context_bridge_node.js",
        )

    same_trace = python_result["trace_id"] == node_result["trace_id"]
    parent_linked = (
        python_result["events"][-1]["span_id"]
        == node_result["events"][0]["parent_span_id"]
    )

    append_record(
        "bridge",
        "check",
        "multilang handoff verification",
        trace_id=node_result["trace_id"],
        status="ok" if same_trace and parent_linked else "error",
        same_trace=same_trace,
        parent_linked=parent_linked,
        artifact_ref=runtime_log_artifact,
    )

    return {
        "task_id": task_id,
        "artifact_ref": runtime_log_artifact,
        "handoff_mode": handoff_mode,
        "python_trace_id": python_result["trace_id"],
        "node_trace_id": node_result["trace_id"],
        "same_trace": same_trace,
        "parent_linked": parent_linked,
        "runtime_log": records,
    }


def main() -> None:
    args = parse_args()
    handoff_mode = "broken" if args.simulate_broken_handoff else "normal"
    python_result = run_json_command(
        [
            sys.executable,
            str(PY_BRIDGE),
            "--task-id",
            args.task_id,
            *(
                ["--input-traceparent", args.input_traceparent]
                if args.input_traceparent
                else []
            ),
        ]
    )
    node_result = run_json_command(
        [
            "node",
            str(NODE_BRIDGE),
            "--task-id",
            args.task_id,
            "--input-traceparent",
            ""
            if args.simulate_broken_handoff
            else python_result["events"][-1]["outgoing_carrier"]["traceparent"],
        ]
    )
    merged = build_runtime_log(
        task_id=args.task_id,
        python_result=python_result,
        node_result=node_result,
        handoff_mode=handoff_mode,
    )
    output = json.dumps(merged, ensure_ascii=False, indent=2)

    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(output + "\n", encoding="utf-8")
        print(f"Wrote merged runtime log to {output_path}")
    else:
        print(output)


if __name__ == "__main__":
    main()
