-- Minimal SQLite schema for projecting agent trace JSONL into dashboards.
-- This file is a teaching artifact. It assumes a loader writes one span per row
-- and stores a projection checkpoint for the latest import.

CREATE TABLE IF NOT EXISTS agent_trace_spans (
  trace_id TEXT NOT NULL,
  span_id TEXT NOT NULL,
  parent_span_id TEXT,
  task_id TEXT NOT NULL,
  workflow TEXT NOT NULL,
  name TEXT NOT NULL,
  kind TEXT NOT NULL,
  actor TEXT NOT NULL,
  status TEXT NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT NOT NULL,
  tokens_input INTEGER DEFAULT 0,
  tokens_output INTEGER DEFAULT 0,
  tool_calls INTEGER DEFAULT 0,
  seconds INTEGER DEFAULT 0,
  raw_json TEXT NOT NULL,
  PRIMARY KEY (trace_id, span_id)
);

CREATE INDEX IF NOT EXISTS idx_agent_trace_spans_task
  ON agent_trace_spans (task_id, started_at);

CREATE INDEX IF NOT EXISTS idx_agent_trace_spans_actor
  ON agent_trace_spans (actor, started_at);

CREATE TABLE IF NOT EXISTS projection_checkpoints (
  projection_name TEXT PRIMARY KEY,
  source_path TEXT NOT NULL,
  last_span_id TEXT NOT NULL,
  processed_spans INTEGER NOT NULL DEFAULT 0,
  processed_traces INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL
);

CREATE VIEW IF NOT EXISTS trace_summary AS
SELECT
  trace_id,
  task_id,
  workflow,
  MIN(started_at) AS started_at,
  MAX(ended_at) AS ended_at,
  CAST(
    ROUND((julianday(MAX(ended_at)) - julianday(MIN(started_at))) * 86400)
    AS INTEGER
  ) AS critical_path_seconds,
  COUNT(*) AS span_count,
  SUM(CASE WHEN status = 'error' THEN 1 ELSE 0 END) AS error_count,
  SUM(CASE WHEN status = 'warn' THEN 1 ELSE 0 END) AS warning_count,
  SUM(tokens_input) AS tokens_input,
  SUM(tokens_output) AS tokens_output,
  SUM(tool_calls) AS tool_calls,
  SUM(seconds) AS span_seconds,
  CASE
    WHEN SUM(CASE WHEN status = 'error' THEN 1 ELSE 0 END) > 0 THEN 'error'
    WHEN SUM(CASE WHEN status = 'warn' THEN 1 ELSE 0 END) > 0 THEN 'warn'
    ELSE 'ok'
  END AS trace_status
FROM agent_trace_spans
GROUP BY trace_id, task_id, workflow;

CREATE VIEW IF NOT EXISTS actor_cost AS
SELECT
  actor,
  COUNT(*) AS span_count,
  SUM(CASE WHEN status = 'error' THEN 1 ELSE 0 END) AS error_count,
  SUM(CASE WHEN status = 'warn' THEN 1 ELSE 0 END) AS warning_count,
  SUM(tokens_input) AS tokens_input,
  SUM(tokens_output) AS tokens_output,
  SUM(tool_calls) AS tool_calls,
  SUM(seconds) AS span_seconds
FROM agent_trace_spans
GROUP BY actor;

CREATE VIEW IF NOT EXISTS failure_queue AS
SELECT
  trace_id,
  span_id,
  task_id,
  workflow,
  name,
  actor,
  status,
  started_at,
  ended_at
FROM agent_trace_spans
WHERE status IN ('error', 'warn')
ORDER BY started_at;

CREATE VIEW IF NOT EXISTS longest_spans AS
SELECT
  trace_id,
  span_id,
  task_id,
  workflow,
  name,
  kind,
  actor,
  status,
  started_at,
  ended_at,
  CAST(
    ROUND((julianday(ended_at) - julianday(started_at)) * 86400)
    AS INTEGER
  ) AS duration_seconds
FROM agent_trace_spans;
