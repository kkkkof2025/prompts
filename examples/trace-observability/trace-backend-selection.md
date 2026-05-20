# Trace Backend 选型与查询策略

最后核验：2026-05-20

这页接在 [OpenTelemetry 生产化加固样例](otel-production-hardening.md) 和 [跨 Agent Trace Context 传播样例](trace-context-propagation.md) 后面。前面两页解决“怎样安全地采集和传播 trace”，本页解决另一个实际问题：

```text
Collector 后面到底接什么？后端怎样选？维护者怎样查？
```

Trace backend 不是越重越好。对 agent 系统来说，后端选错常见有两种结果：

- 个人项目第一天就上复杂平台，维护成本超过排障收益。
- 团队系统长期只靠 JSONL，任务变多后查不到跨 agent 链路和高成本步骤。

正确做法是先把字段和传播链路做稳，再按团队规模、查询需求、留存要求和隐私等级选择后端。

## 先分清三层

```text
Instrumentation / SDK
  负责在代码里产生 span

OpenTelemetry Collector
  负责接收、脱敏、采样、批处理、转发

Trace backend
  负责存储、查询、可视化、留存和权限
```

不要把这三层混在一起。SDK 写死某个后端，会让迁移变困难；后端功能再强，也不能替你自动补齐 `task_id`、`trace_id`、`actor`、`risk_level` 和 `evidence_ref`。

## 选择树

```text
只是个人学习或书稿维护？
  -> JSONL + SQLite

需要团队共享 UI、按 service/operation/tag 查 trace？
  -> Jaeger 或同类自托管 tracing backend

团队已有 Grafana，想把 traces、logs、metrics 串起来？
  -> Grafana Tempo + Grafana

需要企业级权限、留存、告警、SLA 和托管运维？
  -> 托管可观测性平台，并保留 Collector 作为中间层
```

这个选择树不是采购建议，而是学习路径建议。第一版的核心目标是“能稳定找到失败步骤”，不是追求最完整平台。

## 路线对比

| 路线 | 适合 | 优点 | 主要代价 |
| --- | --- | --- | --- |
| JSONL + SQLite | 个人项目、教学、样例回放 | 零后端依赖，方便进仓库和离线复盘 | 不适合多人并发查询和长期留存 |
| Jaeger | 自托管团队、需要独立 trace UI | 经典 tracing 系统，collector / query / all-in-one 角色清晰 | 需要维护存储、权限、部署和升级 |
| Grafana Tempo | 已用 Grafana、需要与日志和指标联动 | 面向大规模 trace 存储，支持 TraceQL 查询和 Grafana 生态 | 需要理解 Grafana、存储和查询模型 |
| 托管平台 | 企业生产、跨团队审计、稳定 SLA | 运维轻，权限和告警能力通常更完整 | 成本、数据合规和供应商绑定要评估 |

对 OpenClaw、Codex CLI、Claude CLI 这类多 agent 工作流，本书建议：

1. 先用 JSONL + SQLite 把字段设计跑通。
2. 再用 OpenTelemetry Collector 统一入口。
3. 最后再在 Jaeger、Tempo 或托管平台之间选择。

## 什么时候用 Jaeger

Jaeger 适合想先拥有一个独立 trace 系统的团队。它的价值不在于“更 AI”，而在于把 collector、query、ingester、all-in-one 等部署角色讲得清楚，维护者容易理解一条 trace 从接收到查询的路径。

适合场景：

- 团队需要一个独立 trace UI。
- 主要问题是查慢 trace、失败 span、服务或 agent 之间的调用关系。
- 你希望先用 all-in-one 或较简单部署验证字段，再逐步拆分组件。

不适合场景：

- 只是个人书稿维护，还没有多人排障需求。
- 还没有脱敏、采样和字段规范，却想直接把所有 prompt 打进后端。
- 团队已经深度使用 Grafana，并希望 traces、logs、metrics 在一个查询体验中联动。

## 什么时候用 Tempo

Grafana Tempo 更适合已经在 Grafana 生态里组织可观测性数据的团队。它的关键价值不是“比别的后端更高级”，而是把 trace 后端和 Grafana 查询、TraceQL、日志指标联动放在同一个工作台里。

适合场景：

- 团队已经有 Grafana。
- 需要把 trace、日志、指标放在同一套排障路径里。
- 希望按 attribute 查询 agent 任务，例如 `agent.task.id`、`agent.actor`、`agent.risk_level`。
- trace 数量会增长，需要认真考虑存储和留存。

不适合场景：

- 只是想演示一个本地 trace 样例。
- 团队没有 Grafana 运维经验。
- 还没想清楚哪些字段允许进入后端。

## Agent trace 的查询问题

普通服务常问“哪个接口慢”。Agent 系统还要问更多问题：

| 查询问题 | 需要的字段 |
| --- | --- |
| 哪个 agent 最耗时 | `agent.actor`、`duration` |
| 哪个模型调用最贵 | `gen_ai.request.model`、`gen_ai.usage.*` |
| 哪些任务被安全拦截 | `agent.risk_level`、`agent.review.status` |
| 哪些任务等待人工最久 | `span.kind=human`、`duration` |
| 哪些任务 trace 断裂 | `trace_id`、`parent_span_id`、`traceparent` |
| 哪些任务没有证据链接 | `agent.evidence.*` |

所以后端选型之前，先确认字段。没有字段规范，后端只能保存一堆难以检索的 span。

## 一个最小团队方案

如果你要把本书样例改成团队试点，可以这样分阶段：

```text
第 1 周：
  trace-spans.jsonl
  trace-dashboard.sqlite
  每天人工看 failure_queue

第 2 周：
  Python / Node agent 接入 OpenTelemetry SDK
  Collector 只输出 debug exporter
  检查字段和脱敏

第 3 周：
  Collector 增加 batch、redaction、tail sampling
  后端先接 Jaeger 或 Tempo 的测试环境
  只保留低敏任务和测试任务

第 4 周：
  高风险任务强制采样保留
  敏感字段进入 artifact 引用，不进 trace backend
  形成排障 SOP 和留存策略
```

这条路径的关键是渐进。先让系统能解释一次失败，再让平台承载更多团队协作。

## 留存和隐私

选择后端时，至少写清楚五件事：

| 问题 | 建议 |
| --- | --- |
| 保留多久 | 个人项目可以本地长期保存，生产 trace 应按合规和成本设置期限 |
| 谁能看 | 高风险任务 trace 应限制到维护者、安全复核人和责任人 |
| 存什么 | 存 ID、摘要、证据链接；不存完整 prompt、密钥和个人资料 |
| 怎么删 | 误写敏感信息时，要有后端删除和密钥轮换流程 |
| 怎么迁移 | SDK 尽量接 Collector，不直接绑死单一后端 |

如果一个 trace backend 让你更容易泄露数据，而不是更容易排障，它就不是当前阶段的正确选择。

## 常见错误

| 错误 | 后果 | 修正 |
| --- | --- | --- |
| 后端先行，字段后补 | UI 很漂亮，但查不到任务原因 | 先定义 `task_id`、`actor`、`risk_level` |
| SDK 直连后端 | 后续换后端困难 | 用 Collector 做中间层 |
| 没有脱敏就全量采集 | prompt、密钥、个人资料进入后端 | 源头最小化 + Collector redaction |
| 只看 error trace | 成功但高成本、高风险任务被忽略 | 增加成本、风险、人工等待查询 |
| 不写留存策略 | 成本失控或合规风险 | 按敏感等级设置保存期限 |

## 和本书其他页的关系

- [Agent Trace 可观测性样例](index.md)：先把本地 JSONL 和 SQLite 看板跑通。
- [OpenTelemetry 最小接入样例](otel-minimal-instrumentation.md)：把 span 从本地脚本发到 Collector。
- [OpenTelemetry 生产化加固样例](otel-production-hardening.md)：在进入后端前做采样、脱敏和 Collector 安全。
- [跨 Agent Trace Context 传播样例](trace-context-propagation.md)：保证多个 agent 仍属于同一条 trace。
- [Agent Trace 生产事故复盘长案例](../../docs/cases/agent-trace-incident-retrospective.md)：把后端里看到的 trace 转成事故复盘和补偿动作。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry Collector 的定位是接收、处理并导出遥测数据，exporter 负责把数据发往后端或其他系统。
- Jaeger 官方文档把 collector、query、ingester、all-in-one 等角色作为部署和查询链路的一部分，并支持接收 OpenTelemetry 数据。
- Grafana Tempo 官方文档把 Tempo 定位为分布式 tracing backend，并提供 TraceQL 等查询能力。

本书判断：

- 对学习项目，JSONL + SQLite 比第一天上后端更稳。
- 对团队项目，Collector 应该成为 SDK 和后端之间的稳定边界。
- 对 agent 系统，后端选型必须和脱敏、采样、字段规范、人工审批和证据链接一起设计。

推演：

- 更成熟的 OpenClaw 类系统会把 trace backend 做成可插拔能力：本地模式写 SQLite，团队模式写 Jaeger 或 Tempo，企业模式写托管平台，但对上层 agent 暴露同一套 `task_id`、`trace_id` 和 `evidence_ref`。

## 参考与复核说明

- [OpenTelemetry Collector Exporters](https://opentelemetry.io/docs/collector/components/exporter/)：用于核验 exporter 在 Collector 中负责把遥测数据发送到后端或其他系统。
- [Jaeger Architecture](https://www.jaegertracing.io/docs/latest/architecture/)：用于核验 Jaeger collector、query、ingester、all-in-one 和 OpenTelemetry 数据接入方向。
- [Grafana Tempo Docs](https://grafana.com/docs/tempo/latest/)：用于核验 Tempo 作为分布式 tracing backend 的官方入口。
- [Grafana Tempo Architecture](https://grafana.com/docs/tempo/latest/operations/architecture/)：用于核验 Tempo 组件、存储和查询链路。
- [Grafana Tempo TraceQL](https://grafana.com/docs/tempo/latest/traceql/)：用于核验 Tempo 的 trace 查询语言方向。
