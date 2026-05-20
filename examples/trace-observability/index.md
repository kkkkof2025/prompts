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
- `replay-agent-traces.ps1`：把 trace span 回放成 JSON 看板快照。

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

## 这个样例演示什么

- 一个成功但带 warning 的书稿发布 trace。
- 一个被安全复核拦截的高风险 trace。
- 如何从 span 聚合出 trace summary、actor cost、failure queue 和 longest spans。
- 为什么 trace 适合排障，不能替代 Event Sourcing 里的业务事实事件。

## 看板字段

| 看板 | 用途 |
| --- | --- |
| `trace_summaries` | 看每个 trace 的状态、耗时、span 数量、token 和工具调用 |
| `actor_cost` | 看每个 agent、CLI 或人工节点消耗了多少成本 |
| `failure_queue` | 看哪些 span 是 error 或 warn，适合排障 |
| `longest_spans` | 看耗时最高的步骤，适合优化 |

## 和 SQLite 的关系

`trace-dashboard-schema.sql` 给出的是最小 schema。真正落地时可以让 loader 把 JSONL 写入 `agent_trace_spans`，再用 `trace_summary`、`actor_cost`、`failure_queue` 三个 view 给人类看板、调度器和复核 agent 查询。

这个样例先用 PowerShell 回放成 JSON，是为了不要求读者本地安装 SQLite 或额外依赖。等流程稳定后，再把同样的数据写入 SQLite、DuckDB、PostgreSQL 或可观测性平台。
