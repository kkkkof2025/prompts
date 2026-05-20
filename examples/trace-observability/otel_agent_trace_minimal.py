#!/usr/bin/env python3
"""Minimal OpenTelemetry instrumentation for an agent workflow.

The script exports spans to stdout by default. If OTEL_EXPORTER_OTLP_ENDPOINT is
set, it uses the OTLP HTTP exporter and sends spans to that endpoint.
"""

from __future__ import annotations

import json
import os
import sys
from typing import Any

try:
    from opentelemetry import trace
    from opentelemetry.sdk.resources import Resource
    from opentelemetry.sdk.trace import TracerProvider
    from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
    from opentelemetry.trace import Status, StatusCode
except ImportError as exc:
    raise SystemExit(
        "Missing packages. Install with: "
        "python -m pip install opentelemetry-api opentelemetry-sdk"
    ) from exc


TASK_ID = "task-book-otel-001"
WORKFLOW = "book_update_publish"
TRACE_SCOPE = "examples.trace_observability.otel_agent_trace_minimal"


def create_span_processor() -> BatchSpanProcessor:
    endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "").strip()
    if not endpoint:
        return BatchSpanProcessor(ConsoleSpanExporter())

    try:
        from opentelemetry.exporter.otlp.proto.http.trace_exporter import (
            OTLPSpanExporter,
        )
    except ImportError as exc:
        raise SystemExit(
            "OTEL_EXPORTER_OTLP_ENDPOINT is set, but the OTLP HTTP exporter "
            "is missing. Install with: "
            "python -m pip install opentelemetry-exporter-otlp-proto-http"
        ) from exc

    trace_endpoint = endpoint.rstrip("/") + "/v1/traces"
    return BatchSpanProcessor(OTLPSpanExporter(endpoint=trace_endpoint))


def configure_tracing() -> trace.Tracer:
    resource = Resource.create(
        {
            "service.name": "agent-book-publisher",
            "service.version": "0.1.0",
            "deployment.environment.name": "local-example",
        }
    )
    provider = TracerProvider(resource=resource)
    provider.add_span_processor(create_span_processor())
    trace.set_tracer_provider(provider)
    return trace.get_tracer(TRACE_SCOPE)


def add_json_event(span: trace.Span, name: str, payload: dict[str, Any]) -> None:
    span.add_event(name, {"agent.event_json": json.dumps(payload, ensure_ascii=False)})


def set_agent_fields(span: trace.Span, actor: str, step: str) -> None:
    span.set_attribute("agent.task.id", TASK_ID)
    span.set_attribute("agent.workflow.name", WORKFLOW)
    span.set_attribute("agent.actor", actor)
    span.set_attribute("agent.step", step)


def run_workflow(tracer: trace.Tracer) -> None:
    with tracer.start_as_current_span("agent.workflow book_update_publish") as root:
        set_agent_fields(root, "orchestrator-agent", "root")
        root.set_attribute("agent.risk_level", "medium")
        root.set_attribute("agent.evidence.refs", "git://worktree/docs")

        with tracer.start_as_current_span("build_context_pack") as span:
            set_agent_fields(span, "context-agent", "build_context_pack")
            span.set_attribute("agent.context.included_sources", 5)
            span.set_attribute("agent.context.excluded_sources", 2)
            span.set_attribute("agent.context.permission_scope", "project-docs")
            add_json_event(
                span,
                "context_pack_ready",
                {
                    "context_pack": "artifact://context-packs/task-book-otel-001.md",
                    "redaction": "secret values are replaced by references",
                },
            )

        with tracer.start_as_current_span("chat frontier-research-model") as span:
            set_agent_fields(span, "research-agent", "call_model")
            span.set_attribute("gen_ai.provider.name", "example-provider")
            span.set_attribute("gen_ai.operation.name", "chat")
            span.set_attribute("gen_ai.request.model", "frontier-research-model")
            span.set_attribute("gen_ai.response.model", "frontier-research-model")
            span.set_attribute("gen_ai.usage.input_tokens", 4200)
            span.set_attribute("gen_ai.usage.output_tokens", 900)
            span.set_attribute("gen_ai.response.finish_reasons", ["stop"])
            add_json_event(
                span,
                "model_output_summary",
                {
                    "sources_checked": 4,
                    "uncertain_claims": 1,
                    "content_capture": "disabled",
                },
            )

        with tracer.start_as_current_span("run_static_checks") as span:
            set_agent_fields(span, "publish-agent", "run_static_checks")
            span.set_attribute("agent.checks", "links,terminology,markdownlint,mkdocs")
            span.set_attribute("agent.warning", "mkdocs-material-future-version-notice")
            span.set_status(Status(StatusCode.OK, "warning captured as attribute"))
            add_json_event(
                span,
                "check_result",
                {
                    "status": "warn",
                    "build_log": "artifact://checks/mkdocs-build-otel-001.txt",
                },
            )

        with tracer.start_as_current_span("human_review") as span:
            set_agent_fields(span, "maintainer", "human_review")
            span.set_attribute("agent.review.decision", "approved")
            span.set_attribute("agent.review.scope", "facts,links,safety")
            add_json_event(
                span,
                "approval_received",
                {"approval": "feishu://approval/task-book-otel-001"},
            )


def main() -> int:
    tracer = configure_tracing()
    run_workflow(tracer)
    provider = trace.get_tracer_provider()
    if hasattr(provider, "shutdown"):
        provider.shutdown()
    return 0


if __name__ == "__main__":
    sys.exit(main())
