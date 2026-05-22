# Observability / Tracing：智能体可观测性与运行追踪

最后核验：2026-05-20

Observability 可以译成“可观测性”。Tracing 可以译成“追踪”或“分布式追踪”。放到 AI agent 系统里，它关注的不是“模型能不能回答”，而是：

```text
一个任务从接收、分派、上下文准备、模型调用、工具调用、人工审批、重试到写回，究竟发生了什么？
```

如果只记一句话，可以记成：

```text
Event Sourcing 记录业务事实，Tracing 记录一次运行路径，Metrics 记录系统健康，Logs 记录细节证据。
```

这页和 [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](cqrs.md)、[Read Model 与 Projection：读模型与投影](read-model-projections.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)、[Saga：补偿事务与流程编排](saga-process-manager.md)、[Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md) 是一组。前面几页解决“状态怎么可靠流转”，这一页解决“运行过程怎样被看见、定位和复盘”。

## 它解决什么

普通脚本失败时，开发者还能看报错。多 agent 系统失败时，问题会复杂很多：

- 是调度器分派错了，还是 agent 理解错了？
- 是模型输出不稳定，还是上下文包缺少关键证据？
- 是工具调用超时，还是权限不足？
- 是同一任务重复执行，还是消息重复投递？
- 是人工审批没回来，还是审批结果没被流程接收？
- 是成本超预算，还是某个 agent 一直重试？
- 是最后结果错了，还是中间某一步已经偏了？

如果没有可观测性，维护者只能在聊天记录、日志文件、Git diff、云文档评论、CI 输出和消息群里手工找线索。系统越强，这种方式越不可持续。

## 三类信号

可观测性通常由三类信号组成。

| 信号 | 记录什么 | 在 agent 系统里的例子 |
| --- | --- | --- |
| Logs | 单条细节记录 | 某次工具调用的输入摘要、错误码、审批备注 |
| Metrics | 可聚合指标 | 成功率、延迟、token 成本、重试次数、人工等待时长 |
| Traces | 一次请求或任务的路径 | 从任务创建到写回发布的全部 span |

它们不是互相替代关系：

- Logs 适合查细节。
- Metrics 适合看趋势。
- Traces 适合定位链路。

一个成熟 agent 系统通常需要三者同时存在。

## Trace 和 Span

Trace 是一次完整运行路径。Span 是 trace 里的一个步骤。

例如一个“更新书稿并发布”的任务，可以拆成：

```text
trace: task-20260520-obs-001
  span: load_task_card
  span: build_context_pack
  span: call_research_agent
  span: call_writer_agent
  span: run_markdown_checks
  span: wait_human_approval
  span: git_commit
  span: git_push
  span: write_release_note
```

每个 span 至少要知道：

- 它属于哪个 trace。
- 它的父 span 是谁。
- 它什么时候开始、什么时候结束。
- 它是否成功。
- 它调用了哪个模型、工具、CLI、API 或人工节点。
- 它消耗了多少时间、token、金额或重试次数。
- 它产生了哪些证据链接。

## 最小 Trace Schema

一个最小可用结构可以这样写：

```json
{
  "trace_id": "trace-20260520-001",
  "task_id": "task-20260520-007",
  "workflow": "book_update_publish",
  "root_actor": "orchestrator-agent",
  "status": "ok",
  "started_at": "2026-05-20T10:00:00+08:00",
  "ended_at": "2026-05-20T10:08:42+08:00",
  "cost": {
    "tokens_input": 18500,
    "tokens_output": 6200,
    "tool_calls": 14,
    "seconds": 522
  },
  "evidence_refs": [
    "git://commit/abc123",
    "mkdocs://build/20260520-001",
    "feishu://task/task-20260520-007"
  ]
}
```

Span 可以更细：

```json
{
  "trace_id": "trace-20260520-001",
  "span_id": "span-run-checks-001",
  "parent_span_id": "span-write-draft-001",
  "name": "run_markdown_checks",
  "kind": "tool",
  "actor": "publish-agent",
  "status": "error",
  "started_at": "2026-05-20T10:05:12+08:00",
  "ended_at": "2026-05-20T10:05:38+08:00",
  "inputs": {
    "command": "markdownlint",
    "scope": "changed_files"
  },
  "outputs": {
    "error_summary": "MD024 duplicate heading in observability page"
  },
  "retry": {
    "attempt": 1,
    "max_attempts": 3
  },
  "links": {
    "log": "artifact://logs/markdownlint-001.txt",
    "file": "docs/observability-tracing-agent-workflows.md"
  }
}
```

这里的输入输出不要无脑记录全文。真正系统里要做脱敏、摘要和引用链接，避免把密钥、个人隐私、内部资料直接写进 trace。

## Agent 系统特别要追什么

普通 Web 服务追踪请求、数据库和外部 API。Agent 系统还要追踪更多 AI 特有对象。

| 对象 | 应追踪字段 | 为什么重要 |
| --- | --- | --- |
| 模型调用 | 模型名、版本、输入输出 token、温度、工具调用结果 | 排查质量波动和成本异常 |
| 上下文包 | 资料来源、截断策略、引用、权限级别 | 判断是不是给错资料 |
| 工具调用 | 工具名、参数摘要、结果摘要、错误码 | 排查执行失败和权限问题 |
| Agent 交接 | 交给谁、交接原因、上下文摘要 | 判断是否路由错误 |
| 人工审批 | 审批人、审批结果、等待时间、备注链接 | 保留责任边界 |
| 记忆写入 | 写入内容摘要、来源、过期规则 | 防止错误记忆长期污染 |
| 安全拦截 | 触发规则、风险等级、处理结果 | 复盘安全策略是否有效 |
| 成本预算 | token、时间、工具费用、重试次数 | 防止任务无限消耗 |

这也是为什么只保存聊天记录不够。聊天记录能说明“说了什么”，trace 才能说明“系统做了什么”。

## 运行日志层

Trace 已经足够诊断，但课堂、试点和复盘时，读者往往还需要一层更容易扫读的文本化视图。这就是 runtime log。

它介于 trace 和 event log 之间：

- 比 trace 更像人能直接扫读的叙事。
- 比 event log 更强调一次运行过程，而不是业务事实重建。
- 比原始 stdout / stderr 更安全，因为它应该保留摘要、状态和 artifact 引用，而不是整段输出。

一个 runtime log 适合包含这些字段：

- `timestamp`
- `runtime`
- `actor`
- `event_type`
- `task_id`
- `trace_id`
- `span_id`
- `parent_span_id`
- `status`
- `artifact_ref`

如果你想看一个把 Python + Node.js bridge 合并成运行日志的例子，继续看 [多语言运行日志回放样例](../examples/trace-observability/trace-runtime-log-replay.md)。

如果你想把运行日志继续变成可搜索索引和失败队列，继续看 [多语言运行日志投影与失败回放样例](../examples/trace-observability/trace-runtime-log-projection.md)。

## OpenClaw 任务 Trace 示例

假设 OpenClaw 执行“扩充七层 AI 文明架构并发布”的任务，一个可观测版本应该像这样：

```text
Trace: update-seven-layer-chapter
  1. task_loaded
     - source: feishu task table
     - task_id: task-20260520-117
  2. context_pack_built
     - included: user note, existing chapter, roadmap rules
     - excluded: unrelated private notes
  3. research_checked
     - sources: official docs, prior notes, repository pages
     - pending: newest external facts require manual review
  4. draft_written
     - output: docs/seven-layer-ai-civilization.md
     - style: book chapter, long case allowed
  5. review_started
     - checks: links, terminology, invented fact risk
  6. human_gate
     - needed: if external publication changes policy or credentials
  7. publish
     - commands: git commit, git push
  8. release_recorded
     - commit: abc123
     - status: published
```

这条 trace 不一定要求第一天就接入复杂平台。最小实现可以是 JSONL 文件，进阶实现可以接 OpenTelemetry、可视化看板、日志平台或专门的 LLM observability 工具。

## 和 Event Sourcing 的区别

Event Sourcing 和 Tracing 很容易混淆。

| 维度 | Event Sourcing | Tracing |
| --- | --- | --- |
| 关心什么 | 业务事实怎么变化 | 一次运行经过哪些步骤 |
| 典型问题 | 当前任务状态能否从事件重建 | 为什么这次任务慢、贵、失败或误判 |
| 数据性质 | 事实源候选 | 诊断证据 |
| 生命周期 | 长期保存，可回放 | 可按成本、合规和排障需求保存 |
| 例子 | `task_approved`、`draft_published` | `call_model`、`run_test`、`wait_signal` |

不要把 trace 当成唯一事实源。Trace 里有运行细节、错误、重试和诊断信息，它能帮助解释业务事件为什么发生，但不一定适合直接重建业务状态。

更稳的组合是：

```text
Event Log = 事实历史
Trace = 运行路径
Runtime log = 人类可读的运行投影
Logs = 细节证据
Metrics = 趋势和告警
Read Model = 当前看板
```

## 和 Durable Execution 的关系

Durable Execution 关注“流程中断后怎样继续”。Tracing 关注“流程为什么卡在这里”。

两者配合后，系统能回答：

- 当前 workflow 卡在哪个 activity？
- 等的是人工 signal，还是外部回调？
- 上次重试为什么失败？
- 已经执行过哪些不可重复步骤？
- 这次恢复是从哪个历史点开始的？
- 某个模型调用失败后是否触发补偿？

如果只有 Durable Execution，没有 tracing，流程可能能恢复，但排障仍然困难。如果只有 tracing，没有 Durable Execution，维护者能看见失败，却仍要手工恢复任务。

## 和 Saga / Outbox 的关系

Saga、Outbox 和 Tracing 的分工可以这样理解：

| 模块 | 解决的问题 | Trace 中应该看到什么 |
| --- | --- | --- |
| Saga | 长流程失败后怎么补偿 | 当前步骤、补偿步骤、失败原因 |
| Process Manager | 下一步命令谁来发 | 状态判断、命令发出、命令结果 |
| Transactional Outbox | 事件怎样可靠发出去 | outbox 写入、relay 发布、重复投递 |
| Idempotent Consumer | 重复消息怎样去重 | 消费尝试、去重命中、最终状态 |

Trace 不替这些模式做决定，但它能证明这些模式有没有按预期工作。

## 告警不应该只看错误

Agent 系统的告警不只看 `error`。很多危险状态表面上是成功的。

建议至少看这些指标：

| 指标 | 风险信号 |
| --- | --- |
| 单任务 token 异常升高 | 上下文包过大、循环调用、模型反复修正 |
| 重试次数异常 | 工具不稳定、权限失败、外部 API 变化 |
| 人工等待时间过长 | 审批流程卡住、责任人不清 |
| 任务成功但复核失败率升高 | 模型输出质量下降或评估标准变了 |
| 上下文截断次数升高 | 资料组织方式需要重构 |
| 同一任务多 agent 抢占 | 锁和幂等设计失效 |
| 安全拦截次数突然下降 | 规则被绕过或日志采集失效 |

真正有价值的可观测性，不是把所有日志都收起来，而是把“需要人介入的异常”尽早浮出来。

## 最小落地方案

### 个人版

适合个人学习项目或小型书稿维护：

```text
trace.jsonl
task-events.jsonl
checks/
  markdownlint.txt
  mkdocs-build.txt
release-notes.md
```

每次任务追加一条 trace summary，关键检查结果保存到文件或 CI artifact。这样成本低，但能覆盖“发生了什么”和“检查是否通过”。

### 团队版

适合读书会、内容团队或小型研发团队：

```text
JSONL / SQLite = 本地事实和 trace
GitHub Actions artifact = 构建与检查日志
飞书 / Telegram = 告警通知
看板 / 云文档 = 当前状态
```

团队版的重点不是立刻上大型平台，而是统一 `trace_id`、`task_id`、`actor` 和 `evidence_ref`。只要这些 ID 稳定，后面迁移到更强系统也不会推倒重来。

### 服务版

适合常驻 agent 平台：

```text
OpenTelemetry SDK / Collector
日志平台
指标平台
Trace 可视化
成本与质量看板
审计和留存策略
```

这时要认真处理采样、脱敏、留存时间、权限隔离和跨系统 trace 传播。

## 可运行样例

如果你想直接看一个最小可运行版本，可以去看 [Agent Trace 可观测性样例](../examples/trace-observability/index.md)。那里给出了：

- `trace-spans.jsonl`：两条 trace、十二个 span。
- `trace-dashboard-schema.sql`：可投影到 SQLite 的最小表和视图。
- `replay-agent-traces.ps1`：把 JSONL 回放成看板 JSON。
- `load-agent-traces-sqlite.py`：把 JSONL 导入 SQLite，再从 SQLite 视图读回看板。

这个样例的目标不是“模拟一个巨大平台”，而是把最关键的关系讲清楚：

```text
span -> trace summary -> actor cost -> failure queue
```

如果你已经有事件溯源页，可以把这个样例看成“运行视角的投影”；如果你还没有事件溯源页，可以先把它当成日志可视化和排障模板。

### SQLite 版的意义

JSONL 适合追加记录，SQLite 适合查询。两者放在一起，可以得到一个很小但完整的本地可观测性闭环：

```text
trace-spans.jsonl
  -> load-agent-traces-sqlite.py
  -> agent_trace_spans
  -> trace_summary / actor_cost / failure_queue / longest_spans
```

其中 `projection_checkpoints` 记录导入处理到哪个 span。这个表看起来不起眼，但很关键：一旦 loader 中断、schema 升级或样例变大，维护者就知道当前看板处理到了哪里，是否需要重建。

这也是 Read Model / Projection 思想在 trace 场景里的落地：原始 span 是运行证据，SQLite view 是给人和 agent 查询的视图。

### OpenTelemetry 版的意义

当任务还停留在个人脚本阶段，JSONL 和 SQLite 足够清楚；当任务开始跨 agent、跨 CLI、跨机器、跨服务时，就应该考虑 OpenTelemetry。

可以把三层关系写成：

```text
本地样例：trace-spans.jsonl -> replay script -> JSON 看板
查询样例：trace-spans.jsonl -> SQLite -> dashboard views
平台接入：OpenTelemetry SDK -> Collector -> trace backend
```

这三层不是互相替代。JSONL 适合教学、离线回放和轻量审计；SQLite 适合本地查询和物化视图；OpenTelemetry 适合跨进程传播、接入 Collector、对接现有可观测性平台。

配套的最小实践页在 [OpenTelemetry 最小接入样例](../examples/trace-observability/otel-minimal-instrumentation.md)。那一页演示怎样用 Python SDK 产生 span，怎样把 `task_id`、`actor`、模型名、token 和证据链接映射到 trace 字段，也说明哪些内容不能直接写进 trace。

如果要进入团队或生产场景，还要继续看 [OpenTelemetry 生产化加固样例](../examples/trace-observability/otel-production-hardening.md)。那里补充了采样、脱敏、Collector 管道顺序、redaction、tail sampling 和事故复盘模板。

如果你已经能发出 span，但还不知道 Collector 后面接 JSONL、SQLite、Jaeger、Grafana Tempo 还是托管平台，继续看 [Trace Backend 选型与查询策略](../examples/trace-observability/trace-backend-selection.md)。那一页把后端选择、查询字段、留存和隐私边界拆开讲。

如果你已经能串起 trace，但还想要一层更容易截图、讲课和快速复盘的文本视图，继续看 [多语言运行日志回放样例](../examples/trace-observability/trace-runtime-log-replay.md)。那一页会把 Python 和 Node.js bridge 的输出合并成一条 runtime log。若要继续接日志平台、看板或失败队列，再看 [多语言运行日志投影与失败回放样例](../examples/trace-observability/trace-runtime-log-projection.md)。若要从手写 `traceparent` 迁移到 SDK，则看 [多语言 OpenTelemetry SDK 接入路线](../examples/trace-observability/trace-otel-sdk-multilang.md)。

如果你的问题是“多个 agent 各自执行后 trace 断了”，继续看 [跨 Agent Trace Context 传播样例](../examples/trace-observability/trace-context-propagation.md)、[多语言 Trace Context 传播样例](../examples/trace-observability/trace-context-multilang.md) 和 [Agent Trace 生产事故复盘长案例](cases/agent-trace-incident-retrospective.md)。前者讲 `traceparent` 怎样传，多语言样例讲 Python 到 Node.js / CLI adapter 怎样不断链，事故案例讲一次 trace 断裂如何拖慢复盘。

## 一个排障清单

当多 agent 任务失败时，不要先问“是不是模型不行”。先按 trace 追：

1. 任务是否有唯一 `task_id` 和 `trace_id`？
2. 任务卡是否被正确读取？
3. 上下文包是否包含必要资料？
4. 是否出现 prompt injection 或权限拦截？
5. 模型调用是否超时、截断或返回格式错误？
6. 工具调用是否失败？
7. 是否重复执行不可重复动作？
8. 是否等待人工 signal？
9. Saga 是否触发补偿？
10. Outbox 是否可靠发出事件？
11. Read Model 是否投影延迟？
12. 最终输出是否通过评估和人工复核？

这套顺序能减少很多盲目重跑。盲目重跑在 agent 系统里经常会制造更多副作用。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry 是业界常用的可观测性框架，围绕 traces、metrics、logs 等信号提供规范和工具链。
- OpenTelemetry Logs 文档说明 logs 也是可观测性信号之一，适合与 traces、metrics 一起使用，但本页的 runtime log 仍然是本书的工程化投影视图，不等同于完整日志平台。
- W3C Trace Context 定义了跨系统传播 trace 上下文的标准方向。
- OpenAI Agents SDK 文档提供 tracing 相关能力入口，用于观察 agent workflow。
- OpenTelemetry 的 GenAI semantic conventions 正在为生成式 AI、模型调用和 agent 相关遥测字段提供统一命名方向，具体字段和稳定等级需要以当前官方文档为准。

本书判断：

- 多 agent 系统如果只做任务状态，不做 trace，很难排查成本、质量、权限和人工审批问题。
- 对个人和小团队来说，先统一 `task_id`、`trace_id`、`span_id` 和证据链接，比一开始采购复杂平台更重要。
- Trace 不是事实源，不能替代 Event Sourcing；它更适合排障、成本分析和质量追踪。
- Runtime log 不是事实源，也不能替代 trace 或 event log；它更适合课堂、试跑和复盘时的人类阅读。

推演：

- 未来 agent 平台很可能把 prompt、上下文包、模型调用、工具调用、人工审批、记忆写入和安全拦截都纳入统一 trace。
- 更强的“超级大脑”系统会把 trace 用作自我优化输入：统计哪些任务失败、哪些上下文包有效、哪些 agent 成本高、哪些 skill 需要重构。但这类自我优化必须经过权限和人工闸门，不能让系统无审查地修改自己的规则。
- 运行日志会成为 trace 之外的一层“人类可读投影”，让不同角色都能快速确认一次运行的关键证据。

## 练习

选择一个真实 agent 或自动化任务，写出它的 trace 设计：

```text
任务名称：
trace_id 规则：
关键 span：
需要记录的模型调用：
需要记录的工具调用：
需要记录的人工审批：
成本指标：
失败告警：
哪些内容不能进 trace：
最终证据链接：
```

如果你写不出“哪些内容不能进 trace”，说明你还没有设计日志脱敏和权限边界。

## 参考与复核说明

- [OpenTelemetry Docs](https://opentelemetry.io/docs/)：用于核验 traces、metrics、logs 等可观测性信号和工具链总入口。
- [OpenTelemetry Logs](https://opentelemetry.io/docs/concepts/signals/logs/)：用于核验 logs 作为可观测性信号的官方说明。
- [OpenTelemetry Traces](https://opentelemetry.io/docs/concepts/signals/traces/)：用于核验 trace、span 和分布式追踪的基本概念。
- [OpenTelemetry Semantic Conventions for Generative AI Systems](https://opentelemetry.io/docs/specs/semconv/gen-ai/)：用于核验生成式 AI 遥测字段的官方语义约定方向；字段稳定性以后续官方文档为准。
- [OpenAI Agents SDK Tracing](https://openai.github.io/openai-agents-python/tracing/)：用于核验 OpenAI Agents SDK 中 tracing 作为 agent workflow 观察能力的官方说明。
- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于核验跨系统 trace 上下文传播的标准。

本页把 Observability / Tracing 映射到 OpenClaw、多 agent、CLI、Event Sourcing、Saga 和 Durable Execution，是本书的工程化推演。Observability 本身不是 AI 专属概念。
