#!/usr/bin/env python3
"""Load agent trace JSONL into a minimal SQLite dashboard."""

from __future__ import annotations

import argparse
import json
import sqlite3
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


REQUIRED_FIELDS = (
    "trace_id",
    "span_id",
    "task_id",
    "workflow",
    "name",
    "kind",
    "actor",
    "status",
    "started_at",
    "ended_at",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Load agent trace JSONL into SQLite and print dashboard views."
    )
    parser.add_argument("--input", required=True, help="Path to trace-spans.jsonl")
    parser.add_argument("--database", required=True, help="SQLite database path")
    parser.add_argument(
        "--schema",
        default="examples/trace-observability/trace-dashboard-schema.sql",
        help="SQLite schema SQL file",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Optional JSON output path. Defaults to stdout.",
    )
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Delete the database before loading this input.",
    )
    return parser.parse_args()


def read_jsonl(path: Path) -> list[tuple[int, str, dict[str, Any]]]:
    spans: list[tuple[int, str, dict[str, Any]]] = []
    with path.open("r", encoding="utf-8") as handle:
        for line_number, raw_line in enumerate(handle, start=1):
            line = raw_line.strip()
            if not line:
                continue

            try:
                span = json.loads(line)
            except json.JSONDecodeError as exc:
                raise ValueError(
                    f"Invalid JSON at line {line_number} in {path}: {exc}"
                ) from exc

            for field in REQUIRED_FIELDS:
                if field not in span or span[field] in (None, ""):
                    raise ValueError(
                        f"Span at line {line_number} is missing required field "
                        f"'{field}'."
                    )

            spans.append((line_number, line, span))

    return spans


def get_cost_value(span: dict[str, Any], name: str) -> int:
    cost = span.get("cost") or {}
    value = cost.get(name, 0)
    if value in (None, ""):
        return 0
    return int(value)


def ensure_schema(connection: sqlite3.Connection, schema_path: Path) -> None:
    with schema_path.open("r", encoding="utf-8") as handle:
        connection.executescript(handle.read())


def row_to_dict(row: sqlite3.Row) -> dict[str, Any]:
    return {key: row[key] for key in row.keys()}


def query_rows(connection: sqlite3.Connection, sql: str) -> list[dict[str, Any]]:
    cursor = connection.execute(sql)
    return [row_to_dict(row) for row in cursor.fetchall()]


def load_spans(
    connection: sqlite3.Connection,
    input_path: Path,
    spans: list[tuple[int, str, dict[str, Any]]],
) -> None:
    rows = []
    for _, raw_json, span in spans:
        rows.append(
            (
                str(span["trace_id"]),
                str(span["span_id"]),
                (
                    None
                    if span.get("parent_span_id") is None
                    else str(span["parent_span_id"])
                ),
                str(span["task_id"]),
                str(span["workflow"]),
                str(span["name"]),
                str(span["kind"]),
                str(span["actor"]),
                str(span["status"]),
                str(span["started_at"]),
                str(span["ended_at"]),
                get_cost_value(span, "tokens_input"),
                get_cost_value(span, "tokens_output"),
                get_cost_value(span, "tool_calls"),
                get_cost_value(span, "seconds"),
                raw_json,
            )
        )

    connection.executemany(
        """
        INSERT OR REPLACE INTO agent_trace_spans (
          trace_id,
          span_id,
          parent_span_id,
          task_id,
          workflow,
          name,
          kind,
          actor,
          status,
          started_at,
          ended_at,
          tokens_input,
          tokens_output,
          tool_calls,
          seconds,
          raw_json
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        rows,
    )

    processed_spans = connection.execute(
        "SELECT COUNT(*) FROM agent_trace_spans"
    ).fetchone()[0]
    processed_traces = connection.execute(
        "SELECT COUNT(DISTINCT trace_id) FROM agent_trace_spans"
    ).fetchone()[0]
    last_span_id = spans[-1][2]["span_id"] if spans else ""

    connection.execute(
        """
        INSERT INTO projection_checkpoints (
          projection_name,
          source_path,
          last_span_id,
          processed_spans,
          processed_traces,
          updated_at
        ) VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(projection_name) DO UPDATE SET
          source_path = excluded.source_path,
          last_span_id = excluded.last_span_id,
          processed_spans = excluded.processed_spans,
          processed_traces = excluded.processed_traces,
          updated_at = excluded.updated_at
        """,
        (
            "agent_trace_dashboard",
            str(input_path),
            str(last_span_id),
            int(processed_spans),
            int(processed_traces),
            datetime.now(timezone.utc).isoformat(),
        ),
    )
    connection.commit()


def build_dashboard(connection: sqlite3.Connection, database_path: Path) -> dict[str, Any]:
    checkpoint = query_rows(
        connection,
        """
        SELECT projection_name, source_path, last_span_id, processed_spans,
               processed_traces, updated_at
        FROM projection_checkpoints
        WHERE projection_name = 'agent_trace_dashboard'
        """,
    )

    return {
        "database_path": str(database_path),
        "projection_checkpoint": checkpoint[0] if checkpoint else None,
        "trace_summaries": query_rows(
            connection,
            """
            SELECT trace_id, task_id, workflow, trace_status, started_at, ended_at,
                   critical_path_seconds, span_count, error_count, warning_count,
                   tokens_input, tokens_output, tool_calls, span_seconds
            FROM trace_summary
            ORDER BY started_at, trace_id
            """,
        ),
        "actor_cost": query_rows(
            connection,
            """
            SELECT actor, span_count, error_count, warning_count, tokens_input,
                   tokens_output, tool_calls, span_seconds
            FROM actor_cost
            ORDER BY actor
            """,
        ),
        "failure_queue": query_rows(
            connection,
            """
            SELECT trace_id, span_id, task_id, workflow, name, actor, status,
                   started_at, ended_at
            FROM failure_queue
            ORDER BY started_at, trace_id, span_id
            """,
        ),
        "longest_spans": query_rows(
            connection,
            """
            SELECT trace_id, span_id, task_id, workflow, name, actor, status,
                   duration_seconds
            FROM longest_spans
            ORDER BY duration_seconds DESC, started_at DESC
            LIMIT 5
            """,
        ),
    }


def main() -> None:
    args = parse_args()
    input_path = Path(args.input).resolve()
    database_path = Path(args.database).resolve()
    schema_path = Path(args.schema).resolve()

    if not input_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")
    if not schema_path.exists():
        raise FileNotFoundError(f"Schema file not found: {schema_path}")

    if args.reset and database_path.exists():
        database_path.unlink()

    database_path.parent.mkdir(parents=True, exist_ok=True)
    spans = read_jsonl(input_path)

    with sqlite3.connect(database_path) as connection:
        connection.row_factory = sqlite3.Row
        ensure_schema(connection, schema_path)
        load_spans(connection, input_path, spans)
        dashboard = build_dashboard(connection, database_path)

    output_json = json.dumps(dashboard, ensure_ascii=False, indent=2)
    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(output_json + "\n", encoding="utf-8")
        print(f"Wrote trace dashboard JSON to {output_path}")
    else:
        print(output_json)


if __name__ == "__main__":
    main()
