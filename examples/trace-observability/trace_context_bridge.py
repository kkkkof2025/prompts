#!/usr/bin/env python3
"""Demonstrate W3C traceparent propagation across simple agent handoffs."""

from __future__ import annotations

import argparse
import json
import re
import secrets
from pathlib import Path
from typing import Any


TRACEPARENT_RE = re.compile(
    r"^(?P<version>[0-9a-f]{2})-"
    r"(?P<trace_id>[0-9a-f]{32})-"
    r"(?P<span_id>[0-9a-f]{16})-"
    r"(?P<trace_flags>[0-9a-f]{2})$"
)


AGENT_STEPS = (
    ("orchestrator-agent", "load_task_card", "task-card"),
    ("research-agent", "check_sources", "research-brief"),
    ("writer-agent", "write_draft", "draft-patch"),
    ("review-agent", "safety_review", "review-result"),
    ("publish-agent", "publish_after_approval", "release-record"),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Simulate traceparent propagation across multiple agents."
    )
    parser.add_argument(
        "--input-traceparent",
        default="",
        help="Optional incoming W3C traceparent header.",
    )
    parser.add_argument(
        "--task-id",
        default="task-book-trace-context-001",
        help="Task id to include in the simulated handoff payload.",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Optional JSON output path. Defaults to stdout.",
    )
    return parser.parse_args()


def new_hex(byte_count: int) -> str:
    return secrets.token_hex(byte_count)


def make_traceparent(trace_id: str, span_id: str, trace_flags: str = "01") -> str:
    return f"00-{trace_id}-{span_id}-{trace_flags}"


def parse_traceparent(value: str) -> dict[str, str]:
    match = TRACEPARENT_RE.match(value.strip())
    if not match:
        raise ValueError(
            "Invalid traceparent. Expected: "
            "00-<32 hex trace id>-<16 hex span id>-<2 hex flags>."
        )

    fields = match.groupdict()
    if fields["trace_id"] == "0" * 32:
        raise ValueError("Invalid traceparent: trace id must not be all zero.")
    if fields["span_id"] == "0" * 16:
        raise ValueError("Invalid traceparent: span id must not be all zero.")
    return fields


def start_or_continue_trace(input_traceparent: str) -> dict[str, str]:
    if input_traceparent:
        return parse_traceparent(input_traceparent)

    return {
        "version": "00",
        "trace_id": new_hex(16),
        "span_id": new_hex(8),
        "trace_flags": "01",
    }


def build_event(
    *,
    task_id: str,
    step_index: int,
    incoming: dict[str, str],
    actor: str,
    span_name: str,
    artifact_kind: str,
) -> dict[str, Any]:
    current_span_id = new_hex(8)
    outgoing_traceparent = make_traceparent(
        incoming["trace_id"], current_span_id, incoming["trace_flags"]
    )

    return {
        "step": step_index,
        "task_id": task_id,
        "actor": actor,
        "span_name": span_name,
        "trace_id": incoming["trace_id"],
        "parent_span_id": incoming["span_id"],
        "span_id": current_span_id,
        "incoming_carrier": {
            "traceparent": make_traceparent(
                incoming["trace_id"], incoming["span_id"], incoming["trace_flags"]
            ),
            "tracestate": "",
        },
        "outgoing_carrier": {
            "traceparent": outgoing_traceparent,
            "tracestate": "",
        },
        "artifact_ref": f"artifact://{artifact_kind}/{task_id}.json",
        "notes": "Only ids and artifact references are propagated; no prompt or secret.",
    }


def simulate(input_traceparent: str, task_id: str) -> dict[str, Any]:
    incoming = start_or_continue_trace(input_traceparent)
    events = []

    for index, (actor, span_name, artifact_kind) in enumerate(AGENT_STEPS, start=1):
        event = build_event(
            task_id=task_id,
            step_index=index,
            incoming=incoming,
            actor=actor,
            span_name=span_name,
            artifact_kind=artifact_kind,
        )
        events.append(event)
        incoming = parse_traceparent(event["outgoing_carrier"]["traceparent"])

    return {
        "task_id": task_id,
        "trace_id": events[0]["trace_id"],
        "span_count": len(events),
        "agents": [event["actor"] for event in events],
        "events": events,
    }


def main() -> None:
    args = parse_args()
    result = simulate(args.input_traceparent, args.task_id)
    output = json.dumps(result, ensure_ascii=False, indent=2)

    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(output + "\n", encoding="utf-8")
        print(f"Wrote trace context simulation to {output_path}")
    else:
        print(output)


if __name__ == "__main__":
    main()
