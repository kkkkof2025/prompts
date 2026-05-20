# Agent Trace 可观测性样例

这个目录提供一个最小 agent trace 样例，用来配合 [Observability / Tracing：智能体可观测性与运行追踪](../../docs/observability-tracing-agent-workflows.md)、[Durable Execution：持久化执行与 agent 长任务](../../docs/durable-execution-agent-workflows.md)、[Saga：补偿事务与流程编排](../../docs/saga-process-manager.md) 和 [OpenClaw 多 agent 联动教程](../../docs/openclaw-multi-agent-linkage.md) 阅读。

它和 [任务事件日志样例](../event-log/index.md) 的关系是：

```text
任务事件日志 = 业务事实怎样变化
Agent trace = 一次运行怎样发生
```

## 文件

- `trace-spans.jsonl`：按 JSONL 保存的 agent span，每行一条 span。
- `trace-dashboard-schema.sql`：把 span 投影到 SQLite 看板时可参考的表和视图结构。
- `load-agent-traces-sqlite.py`：把 JSONL 导入 SQLite，并读取看板视图输出 JSON。
- `replay-agent-traces.ps1`：把 trace span 回放成 JSON 看板快照。
- `otel-minimal-instrumentation.md`：把同样的思路接到 OpenTelemetry 的最小实践页。
- `otel_agent_trace_minimal.py`：OpenTelemetry Python 最小 span 示例。
- `otel-production-hardening.md`：OpenTelemetry 生产化加固页，覆盖采样、脱敏、Collector 管道和事故复盘。
- `otel-collector-agent-traces.yaml`：用于 agent trace 的 Collector Contrib 配置模板。
- `trace-backend-selection.md`：Trace backend 选型与查询策略实践页。
- `trace-context-propagation.md`：跨 agent 传播 trace context 的实践页。
- `trace_context_bridge.py`：无外部依赖的 `traceparent` 传播演示脚本。
- `trace-context-multilang.md`：Python + Node.js 多语言 trace context 传播实践页。
- `trace_context_bridge_node.js`：无外部依赖的 Node.js `traceparent` 传播演示脚本。

## 回放

在仓库根目录运行：

```powershell
./scripts/replay-agent-traces.ps1 -InputPath examples/trace-observability/trace-spans.jsonl
```

生成 JSON 快照：

```powershell
./scripts/replay-agent-traces.ps1 -InputPath examples/trace-observability/trace-spans.jsonl -OutputPath tmp/trace-dashboard.json
```

如果你想先看控制台输出，也可以不传 `-OutputPath`。

### SQLite 导入

```powershell
python scripts/load-agent-traces-sqlite.py --input examples/trace-observability/trace-spans.jsonl --database tmp/trace-dashboard.sqlite --reset
```

这个脚本会：

- 按 `trace-dashboard-schema.sql` 建表和建视图。
- 把每个 span 写进 `agent_trace_spans`。
- 更新 `projection_checkpoints`。
- 再从 SQLite 视图里读回 `trace_summary`、`actor_cost`、`failure_queue` 和 `longest_spans`。

### 常用查询

```sql
SELECT trace_id, task_id, workflow, trace_status, critical_path_seconds, span_count
FROM trace_summary
ORDER BY started_at DESC;

SELECT actor, span_count, error_count, span_seconds
FROM actor_cost
ORDER BY span_seconds DESC;
```

```sql
SELECT trace_id, span_id, task_id, name, actor, status, duration_seconds
FROM longest_spans
ORDER BY duration_seconds DESC
LIMIT 5;

SELECT trace_id, span_id, task_id, name, actor, status
FROM failure_queue
ORDER BY started_at ASC;
```

## 这个样例演示什么

- 一个成功但带 warning 的书稿发布 trace。
- 一个被安全复核拦截的高风险 trace。
- 如何从 span 聚合出 trace summary、actor cost、failure queue 和 longest spans。
- 如何把相同的数据落到 SQLite，再把 SQLite 视图当成可查询看板。
- 如何继续过渡到 [OpenTelemetry 最小接入样例](otel-minimal-instrumentation.md)。
- 如何继续过渡到 [OpenTelemetry 生产化加固样例](otel-production-hardening.md)。
- 如何用 [Trace Backend 选型与查询策略](trace-backend-selection.md) 判断 JSONL、SQLite、Jaeger、Tempo 或托管平台的边界。
- 如何用 [跨 Agent Trace Context 传播样例](trace-context-propagation.md) 避免多 agent 运行链路断裂。
- 如何用 [多语言 Trace Context 传播样例](trace-context-multilang.md) 验证 Python agent 与 Node.js adapter 仍在同一条 trace 上。
- 为什么 trace 适合排障，不能替代 Event Sourcing 里的业务事实事件。

## 看板字段

| 看板 | 用途 |
| --- | --- |
| `trace_summaries` | 看每个 trace 的状态、耗时、span 数量、token 和工具调用 |
| `actor_cost` | 看每个 agent、CLI 或人工节点消耗了多少成本 |
| `failure_queue` | 看哪些 span 是 error 或 warn，适合排障 |
| `longest_spans` | 看耗时最高的步骤，适合优化 |
| `projection_checkpoints` | 看 SQLite 看板处理到哪个 span，适合复核和恢复 |

## 和 SQLite 的关系

`trace-dashboard-schema.sql` 给出的是最小 schema。真正落地时可以让 loader 把 JSONL 写入 `agent_trace_spans`，再用 `trace_summary`、`actor_cost`、`failure_queue`、`longest_spans` 和 `projection_checkpoints` 给人类看板、调度器和复核 agent 查询。

这个样例先用 PowerShell 回放成 JSON，是为了不要求读者本地安装 SQLite 或额外依赖。等流程稳定后，再把同样的数据写入 SQLite、DuckDB、PostgreSQL 或可观测性平台。

## 下一步：接入 OpenTelemetry

如果你已经理解 JSONL 和 SQLite 的关系，可以继续看 [OpenTelemetry 最小接入样例](otel-minimal-instrumentation.md)。那一页会把 `task_id`、`workflow`、`actor`、模型调用、token、人工审批和证据链接映射到 OpenTelemetry span，并给出一个可运行的 Python 示例。

如果你准备把 trace 放进团队系统，再继续看 [OpenTelemetry 生产化加固样例](otel-production-hardening.md)，重点检查采样、脱敏、Collector 安全和事故复盘。

如果你已经能把 span 发进 Collector，但还不知道后端接什么，再继续看 [Trace Backend 选型与查询策略](trace-backend-selection.md)，重点比较 JSONL/SQLite、Jaeger、Grafana Tempo 和托管平台的取舍。

如果你要让多个 agent 共享同一条运行链路，再继续看 [跨 Agent Trace Context 传播样例](trace-context-propagation.md)，重点理解 `traceparent`、任务元数据和 handoff carrier。

如果你的 agent 已经跨 Python、Node.js 或 CLI adapter，再继续看 [多语言 Trace Context 传播样例](trace-context-multilang.md)，重点验证不同运行时之间的 `trace_id` 和父子 span 关系是否连续。
