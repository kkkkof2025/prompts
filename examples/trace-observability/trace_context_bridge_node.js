#!/usr/bin/env node
"use strict";

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const TRACEPARENT_RE =
  /^(?<version>[0-9a-f]{2})-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<trace_flags>[0-9a-f]{2})$/;

const AGENT_STEPS = [
  ["node-router-agent", "receive_handoff", "handoff-message"],
  ["codex-cli-adapter", "invoke_codex_cli", "cli-run"],
  ["state-sync-agent", "write_shared_task_state", "task-state"],
];

function parseArgs(argv) {
  const args = {
    inputTraceparent: "",
    taskId: "task-book-trace-context-node-001",
    output: "",
  };

  for (let index = 0; index < argv.length; index += 1) {
    const item = argv[index];
    if (item === "--input-traceparent") {
      args.inputTraceparent = argv[index + 1] || "";
      index += 1;
    } else if (item.startsWith("--input-traceparent=")) {
      args.inputTraceparent = item.slice("--input-traceparent=".length);
    } else if (item === "--task-id") {
      args.taskId = argv[index + 1] || args.taskId;
      index += 1;
    } else if (item.startsWith("--task-id=")) {
      args.taskId = item.slice("--task-id=".length);
    } else if (item === "--output") {
      args.output = argv[index + 1] || "";
      index += 1;
    } else if (item.startsWith("--output=")) {
      args.output = item.slice("--output=".length);
    } else if (item === "--help" || item === "-h") {
      printHelp();
      process.exit(0);
    } else {
      throw new Error(`Unknown argument: ${item}`);
    }
  }

  return args;
}

function printHelp() {
  console.log(`Usage: node trace_context_bridge_node.js [options]

Options:
  --input-traceparent <value>  Optional incoming W3C traceparent header.
  --task-id <value>           Task id for the simulated handoff payload.
  --output <path>             Optional JSON output path. Defaults to stdout.
`);
}

function newHex(byteCount) {
  return crypto.randomBytes(byteCount).toString("hex");
}

function makeTraceparent(traceId, spanId, traceFlags = "01") {
  return `00-${traceId}-${spanId}-${traceFlags}`;
}

function parseTraceparent(value) {
  const match = TRACEPARENT_RE.exec(value.trim());
  if (!match || !match.groups) {
    throw new Error(
      "Invalid traceparent. Expected: " +
        "00-<32 hex trace id>-<16 hex span id>-<2 hex flags>."
    );
  }

  const fields = match.groups;
  if (fields.trace_id === "0".repeat(32)) {
    throw new Error("Invalid traceparent: trace id must not be all zero.");
  }
  if (fields.span_id === "0".repeat(16)) {
    throw new Error("Invalid traceparent: span id must not be all zero.");
  }
  return fields;
}

function startOrContinueTrace(inputTraceparent) {
  if (inputTraceparent) {
    return parseTraceparent(inputTraceparent);
  }

  return {
    version: "00",
    trace_id: newHex(16),
    span_id: newHex(8),
    trace_flags: "01",
  };
}

function buildEvent({
  taskId,
  stepIndex,
  incoming,
  actor,
  spanName,
  artifactKind,
}) {
  const currentSpanId = newHex(8);
  const outgoingTraceparent = makeTraceparent(
    incoming.trace_id,
    currentSpanId,
    incoming.trace_flags
  );

  return {
    step: stepIndex,
    runtime: "nodejs",
    task_id: taskId,
    actor,
    span_name: spanName,
    trace_id: incoming.trace_id,
    parent_span_id: incoming.span_id,
    span_id: currentSpanId,
    incoming_carrier: {
      traceparent: makeTraceparent(
        incoming.trace_id,
        incoming.span_id,
        incoming.trace_flags
      ),
      tracestate: "",
    },
    outgoing_carrier: {
      traceparent: outgoingTraceparent,
      tracestate: "",
    },
    artifact_ref: `artifact://${artifactKind}/${taskId}.json`,
    notes: "Only ids and artifact references are propagated; no prompt or secret.",
  };
}

function simulate(inputTraceparent, taskId) {
  let incoming = startOrContinueTrace(inputTraceparent);
  const events = [];

  AGENT_STEPS.forEach(([actor, spanName, artifactKind], index) => {
    const event = buildEvent({
      taskId,
      stepIndex: index + 1,
      incoming,
      actor,
      spanName,
      artifactKind,
    });
    events.push(event);
    incoming = parseTraceparent(event.outgoing_carrier.traceparent);
  });

  return {
    task_id: taskId,
    runtime: "nodejs",
    trace_id: events[0].trace_id,
    span_count: events.length,
    agents: events.map((event) => event.actor),
    events,
  };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const result = simulate(args.inputTraceparent, args.taskId);
  const output = JSON.stringify(result, null, 2);

  if (args.output) {
    const outputPath = path.resolve(args.output);
    fs.mkdirSync(path.dirname(outputPath), { recursive: true });
    fs.writeFileSync(outputPath, `${output}\n`, "utf8");
    console.log(`Wrote trace context simulation to ${outputPath}`);
  } else {
    console.log(output);
  }
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
