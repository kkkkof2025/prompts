# OpenTelemetry 最小接入样例

最后核验：2026-05-20

这个样例接在 [Agent Trace 可观测性样例](index.md) 后面。前一个样例用 JSONL 和 SQLite 讲清楚 trace 数据怎么落地；本页继续说明：当你的 agent 已经从个人脚本变成常驻服务，怎样把同样的运行路径接入 OpenTelemetry。

先记住一个分层：

```text
JSONL / SQLite = 本地、低成本、便于学习和回放
OpenTelemetry = 跨服务、跨进程、可接入 Collector 和后端平台
```

不要第一天就把系统做重。建议先用 JSONL 统一 `task_id`、`trace_id`、`span_id`、`actor` 和证据链接；等任务开始跨进程、跨机器、跨 agent 后，再接入 OpenTelemetry。

## 文件

- `otel_agent_trace_minimal.py`：一个最小 Python 示例，默认把 span 输出到控制台。
- `trace-spans.jsonl`：同目录的无依赖 trace 样例，适合先理解字段。
- `trace-dashboard-schema.sql`：把 JSONL 投影到 SQLite 的查询视图。

## 安装依赖

最小本地控制台输出：

```powershell
python -m pip install opentelemetry-api opentelemetry-sdk
```

如果要发送到 OpenTelemetry Collector 或兼容 OTLP 的后端，再安装 HTTP exporter：

```powershell
python -m pip install opentelemetry-exporter-otlp-proto-http
```

本仓库不会把这些依赖写进默认文档构建依赖里，因为它们属于运行样例依赖，不是 MkDocs 构建依赖。

## 运行

在仓库根目录运行：

```powershell
python examples/trace-observability/otel_agent_trace_minimal.py
```

默认会使用 `ConsoleSpanExporter`，把 span 打印到标准输出。你应该能看到类似这些 span 名称：

```text
agent.workflow book_update_publish
build_context_pack
chat frontier-research-model
run_static_checks
human_review
```

如果你已经有 Collector，可以设置 OTLP endpoint：

```powershell
$env:OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318"
python examples/trace-observability/otel_agent_trace_minimal.py
```

示例脚本会自动把 traces 发送到 `$env:OTEL_EXPORTER_OTLP_ENDPOINT/v1/traces`。真实项目里可以把这个地址交给环境变量、配置文件或部署平台管理。

## Collector 最小调试配置

官方 Python exporter 文档推荐生产环境优先经过 OpenTelemetry Collector，再转发到具体后端。本地调试可以用一个只输出到控制台的 Collector：

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
exporters:
  debug:
    verbosity: detailed
service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [debug]
```

这个配置的价值是先验证“应用确实发出了 span”。等字段、采样和脱敏策略稳定后，再接 Jaeger、Grafana Tempo、Datadog、Honeycomb、SigNoz 或其他后端。如果你还没确定后端路线，先看 [Trace Backend 选型与查询策略](trace-backend-selection.md)。

## 字段映射

OpenTelemetry 的 GenAI semantic conventions 已经给出了生成式 AI span 的字段方向，但部分字段仍要以后续官方文档为准。实践中可以采用“双层字段”：

| 本书字段 | OpenTelemetry 字段方向 | 说明 |
| --- | --- | --- |
| `task_id` | `agent.task.id` | 自定义字段，保持团队内稳定 |
| `workflow` | `agent.workflow.name` / `gen_ai.workflow.name` | 业务流程名，是否使用 GenAI 字段要看当前规范 |
| `actor` | `agent.actor` | 自定义字段，记录 agent、CLI 或人工节点 |
| `name` | span name | 推荐让 span name 可读，例如 `chat model-name` |
| `kind=model` | `gen_ai.operation.name` | 模型调用可用 `chat` 等操作名 |
| 模型名称 | `gen_ai.request.model` / `gen_ai.response.model` | 记录请求模型和实际响应模型 |
| token | `gen_ai.usage.input_tokens` / `gen_ai.usage.output_tokens` | 成本分析的关键字段 |
| 证据链接 | 自定义 `agent.evidence.*` 或 span event | 不建议把正文、密钥或完整私有资料直接放进属性 |

这不是说自定义字段比官方字段更好，而是说两者解决的问题不同。官方字段负责互操作，自定义字段负责你的业务可读性。稳定做法是：能对齐官方字段就对齐，不能确定时先用 `agent.*` 命名空间保留语义，后续再做映射。

## 真实失败排障案例

假设 OpenClaw 接了三个 CLI：`codex-cli` 负责改稿，`claude-cli` 负责审阅，`publish-cli` 负责发布。某次任务失败，页面只显示“安全复核失败”。如果没有 trace，维护者只能翻聊天记录和 CI 日志。

接入 OpenTelemetry 后，trace 可能长这样：

```text
agent.workflow book_update_publish
  load_task_card                     ok
  build_context_pack                 ok
  chat frontier-research-model        ok
  call codex-cli.write_draft          ok
  call claude-cli.review              error
  compensation reopen_review          ok
```

此时排查顺序不是重跑任务，而是看失败 span：

1. `call claude-cli.review` 的 `agent.actor` 是谁。
2. `gen_ai.request.model` 和 `gen_ai.response.model` 是否符合预期。
3. `agent.evidence.refs` 是否指向本次草稿，而不是旧草稿。
4. span event 是否记录了安全复核摘要。
5. 是否存在完整 prompt、密钥、token 或私有资料泄露到 trace。
6. Saga 是否发出了 `compensation reopen_review`，任务是否回到 blocked 状态。

这个案例里，trace 不是用来判断“草稿是否应该发布”的事实源。事实源仍然应该是任务事件日志、审批记录和 Git commit。Trace 的作用是解释：复核失败发生在哪一步、谁做的、用了什么上下文、是否触发了补偿、下一步该由谁处理。

## 常见错误

| 错误 | 后果 | 改法 |
| --- | --- | --- |
| 把完整 prompt 和输出都写进 span attribute | 泄露隐私和内部资料，后端索引成本暴涨 | 默认只写摘要、hash、引用链接，必要时单独保存受控 artifact |
| 只记录模型 span，不记录工具和人工节点 | 看不到权限、文件、审批和发布失败 | 每个跨边界动作都建 span |
| 每个 agent 自己生成不相关 trace | 跨 agent 链路断裂 | 统一传播 trace context 或至少统一 `task_id` |
| 把 trace 当业务事实源 | 重试、失败和诊断信息污染状态重建 | Event Log 记录事实，Trace 记录运行路径 |
| 不设置采样和留存 | 成本不可控，敏感数据长期堆积 | 按风险等级、错误状态和任务类型设置采样策略 |

## 接入顺序

个人项目：

```text
JSONL -> SQLite -> markdown report
```

小团队：

```text
JSONL -> OpenTelemetry SDK -> ConsoleSpanExporter / Collector debug
```

常驻服务：

```text
OpenTelemetry SDK
  -> Collector
  -> trace backend
  -> metrics / alerting
  -> incident review artifact
```

多 agent 平台：

```text
task event log = 事实源
OpenTelemetry trace = 运行路径
read model = 当前看板
artifact store = 受控证据
human approval = 责任边界
```

下一步可以继续看 [OpenTelemetry 生产化加固样例](otel-production-hardening.md)。它会补采样、脱敏、Collector 管道和事故复盘模板，避免最小接入样例被误用成生产方案。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry 官方文档把 trace 定义为请求经过应用的路径，并用 span 表示其中的工作单元。
- OpenTelemetry Python exporter 文档说明可以用控制台 exporter 调试，也可以用 OTLP exporter 发送到 Collector 或后端。
- W3C Trace Context 定义了跨服务传播 trace context 的 HTTP header 格式和处理方向。
- OpenTelemetry GenAI semantic conventions 正在为 `gen_ai.operation.name`、`gen_ai.request.model`、`gen_ai.usage.input_tokens` 等字段提供命名方向；这些页面会继续演进，落地时应按当前版本复核。

本书判断：

- 对 agent 系统来说，OpenTelemetry 的价值不只是“看到 API 延迟”，更重要的是把模型调用、工具调用、上下文准备、人工审批和安全拦截放进同一条运行路径。
- 自定义 `agent.*` 字段是有必要的，因为很多业务语义不是通用 GenAI 字段能完全表达。
- 生产环境要先做脱敏和留存策略，再谈全量采集。

推演：

- 未来更强的 agent 平台会把 OpenTelemetry trace、事件溯源、读模型、审批系统和成本预算合并成一个诊断层。人看到的是“为什么失败、下一步谁处理、是否可以自动恢复”，而不是散落在多个工具里的日志碎片。

## 参考与复核说明

- [OpenTelemetry Traces](https://opentelemetry.io/docs/concepts/signals/traces/)：用于核验 trace、span、context propagation 和 exporter 的基本关系。
- [OpenTelemetry Python Exporters](https://opentelemetry.io/docs/languages/python/exporters/)：用于核验 Python 控制台 exporter、OTLP exporter 和 Collector 调试路径。
- [OpenTelemetry GenAI semantic conventions](https://opentelemetry.io/docs/specs/semconv/gen-ai/)：用于核验生成式 AI 相关字段方向。
- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于核验跨服务 trace context 传播标准。
