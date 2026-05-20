# OpenTelemetry 生产化加固样例

最后核验：2026-05-20

这个样例接在 [OpenTelemetry 最小接入样例](otel-minimal-instrumentation.md) 后面。最小样例证明“agent 能产生 span”；生产化加固要回答另一个问题：

```text
这些 span 能不能安全、低成本、可排障、可留存地进入团队系统？
```

如果只加 SDK，不做采样、脱敏、Collector 安全和事故复盘，trace 很快会从“排障工具”变成“成本和隐私风险来源”。

## 文件

- `otel-collector-agent-traces.yaml`：一个面向 agent trace 的 Collector Contrib 配置模板。
- `otel_agent_trace_minimal.py`：产生示例 span 的 Python 脚本。
- `trace-spans.jsonl`：不依赖 OpenTelemetry 的本地 trace 样例。

## 生产化四件事

| 能力 | 解决什么 | 不能做什么 |
| --- | --- | --- |
| 采样 | 控制成本，保留错误、慢请求和高风险任务 | 不能弥补字段设计混乱 |
| 脱敏 | 防止 token、邮箱、电话、密钥进入后端 | 不能替代源头数据最小化 |
| Collector 管道 | 统一接收、处理、转发、限流和调试 | 不能自动判断业务合规 |
| 事故复盘 | 把 trace 转成行动、补偿和流程改进 | 不能替代审批记录和事件日志 |

本页只写 agent trace，不把 metrics 和 logs 一起展开。真实平台应三者一起设计。

## Collector 模板

示例配置在 [otel-collector-agent-traces.yaml](otel-collector-agent-traces.yaml)。

这个配置默认只输出到 `debug` exporter，便于本地验证。真实接入后端时，再把注释里的 `otlphttp/trace_backend` 改成你的后端地址，并补齐认证、TLS、队列、重试和留存策略。后端还没确定时，先用 [Trace Backend 选型与查询策略](trace-backend-selection.md) 比较 JSONL/SQLite、Jaeger、Tempo 和托管平台的边界。

运行时需要使用包含 `redaction` 和 `tail_sampling` 的 Collector Contrib 发行版，而不是只包含核心组件的最小 Collector。

```powershell
otelcol-contrib --config examples/trace-observability/otel-collector-agent-traces.yaml
```

另一个终端发送示例 trace：

```powershell
$env:OTEL_EXPORTER_OTLP_ENDPOINT="http://127.0.0.1:4318"
python examples/trace-observability/otel_agent_trace_minimal.py
```

看到 Collector 输出 span 后，先检查三件事：

1. `agent.task.id`、`agent.workflow.name`、`agent.actor` 是否还在。
2. token、email、phone、secret、password 等字段是否被移除或遮蔽。
3. 错误、高风险和慢 trace 是否更容易被保留。

## 采样策略

OpenTelemetry 文档把采样分成两个典型位置：在 trace 开始时做的 head sampling，以及在 Collector 中看完整或接近完整 trace 后做的 tail sampling。

对 agent 系统，建议分层：

| 场景 | 建议 |
| --- | --- |
| 本地开发 | 全量采集，先看清字段 |
| 小团队试点 | 全量错误和高风险任务，普通任务按比例采样 |
| 常驻生产 | SDK 侧做少量 head sampling，Collector 侧做 tail sampling |
| 高风险任务 | 不依赖随机采样，按 `agent.risk_level`、错误状态、审批失败保留 |
| 大流量低风险任务 | 低比例保留，同时用 metrics 监控整体趋势 |

`otel-collector-agent-traces.yaml` 里的 `tail_sampling/agent` 示例保留四类 trace：

- 有 `ERROR` 状态的 trace。
- `agent.risk_level` 是 `high` 或 `critical` 的 trace。
- 超过 30 秒的慢 trace。
- 10% 普通 trace，作为代表性样本。

这不是推荐给所有团队的固定比例。正确做法是先估算每天 trace 数量、平均 span 数量、后端费用、隐私等级和排障需求，再设置采样规则。

如果 Collector 需要横向扩容，tail sampling 还有一个重要限制：同一条 trace 的所有 span 最好进入同一个执行采样决策的 Collector 实例。否则一个任务的不同片段可能被不同实例分别处理，采样结果会变得不稳定。真实部署时通常要把“接收层”和“tail sampling 层”分开，或者使用能按 trace 分流的负载策略。

## 脱敏策略

OpenTelemetry 官方安全文档强调，实现者需要自己判断哪些数据敏感。系统不会天然知道你的客户姓名、内部项目代号、学校学号、订单号或密钥是否能进入 trace。

建议采用三层防线：

| 防线 | 做法 | 例子 |
| --- | --- | --- |
| 源头最小化 | SDK 侧不要写完整 prompt、输出和密钥 | 写 `artifact://...`，不写正文 |
| Collector 脱敏 | 用 allow list、blocked key、blocked value 处理属性 | 只允许 `agent.*` 和 `gen_ai.*` 核心字段 |
| 后端治理 | 控制访问、留存、导出和审计 | 生产 trace 留 30 天，高风险 trace 单独审批 |

模板里的 `redaction/agent_safe` 采用 fail-closed 思路：只保留允许列表中的字段。这样会牺牲一些灵活性，但更适合书稿维护、教育、客户资料、代码仓库这类容易混入敏感信息的 agent 场景。

脱敏后仍要人工抽查。正则只能覆盖常见形态，不能保证识别所有私有资料。

## Collector 管道顺序

模板使用这个顺序：

```text
otlp receiver
  -> memory_limiter
  -> redaction
  -> tail_sampling
  -> batch
  -> debug / backend exporter
```

原因：

- `memory_limiter` 放前面，先保护 Collector 自己。
- `redaction` 放在采样和导出前，避免敏感字段流到后面的处理和后端。
- `tail_sampling` 在看到更多 span 后再决定是否保留 trace。
- `batch` 放后面，减少发送开销。

如果团队要做更复杂的路由，例如高风险 trace 发安全后端、普通 trace 发低成本后端，可以继续增加 routing 或多个 exporter。但第一版不要一开始就把管道做成迷宫。

## 生产事故复盘模板

下面是一个可复制的复盘模板。它不替代事件日志和审批记录，只用于把 trace 证据转成工程改进。

```text
事故编号：
发现时间：
影响范围：
关联 task_id：
关联 trace_id：

现象：

关键 span：
- span_id：
  actor：
  status：
  duration：
  evidence_ref：
  发现：

采样是否保留了关键 trace：
□ 是
□ 否，原因：

脱敏检查：
□ 未发现敏感字段
□ 已发现并处理
□ 需要删除后端数据

事实源核对：
□ 任务事件日志
□ 审批记录
□ Git commit
□ 发布记录

根因判断：

补偿动作：

后续改进：
□ 调整采样
□ 调整脱敏
□ 调整上下文包
□ 调整工具权限
□ 调整人工闸门
□ 调整 read model / 看板
```

## 真实案例设计：安全复核失败

假设一次 OpenClaw 书稿更新失败，任务状态只显示：

```text
blocked: safety_review_failed
```

没有 trace 时，人只能猜测是模型误判、上下文包缺资料、审查规则太严，还是草稿真的泄露了敏感内容。

有生产化 trace 后，复盘可以这样走：

| 步骤 | 看什么 | 结论 |
| --- | --- | --- |
| 1 | `trace_summary` 里 trace 状态 | `error`，失败发生在审查阶段 |
| 2 | `failure_queue` 里失败 span | `claude-cli.review` 返回安全失败 |
| 3 | span attributes | `agent.risk_level=high`，采样规则应保留 |
| 4 | redaction audit | token 字段已被移除，但草稿摘要包含“授权绕过” |
| 5 | task event log | 任务被补偿到 `blocked`，没有发布 |
| 6 | human approval | 维护者要求改为“授权流程说明”，不写绕过步骤 |

这个案例的重点不是“把所有内容都记录下来”，而是用最少证据回答：

```text
哪一步失败？
有没有发布？
有没有泄露敏感字段？
下一步由谁处理？
系统规则要不要改？
```

如果事故里还出现“每个 agent 都有自己的 trace，看不出上下游”的问题，继续看 [跨 Agent Trace Context 传播样例](trace-context-propagation.md)。生产化加固解决“哪些 trace 被保留、怎样脱敏、怎样进入后端”；trace context 传播解决“多个 agent 是否仍然属于同一条链路”。

如果事故里出现“trace 已经采到了，但后端查不出任务、agent、成本或风险等级”的问题，继续看 [Trace Backend 选型与查询策略](trace-backend-selection.md)。那一页会把后端选择和查询字段一起处理，而不是只比较产品名称。

如果事故里涉及 Python agent、Node.js adapter、Codex CLI 或 Claude CLI 之间的交接，再继续看 [多语言 Trace Context 传播样例](trace-context-multilang.md)，重点检查 carrier 是否被写入任务元数据，而不是只停留在某个运行时内存里。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry 官方文档说明采样可用于减少可观测性成本，并区分 head sampling 与 tail sampling。
- OpenTelemetry Collector 的 processors 位于 receivers 和 exporters 之间，可用于转换、过滤、脱敏、批处理和采样。
- OpenTelemetry 安全文档强调敏感数据处理是实现者责任，Collector 配置应考虑加密、认证、最小组件、权限和拒绝服务风险。
- `tail_sampling`、`redaction` 等处理器属于 Collector Contrib 生态，具体字段和稳定等级要按当前版本复核。

本书判断：

- Agent trace 生产化时，应该优先保留错误、高风险、慢 trace 和人工审批失败，而不是简单按固定比例随机丢弃所有 trace。
- 对含客户、学生、合同、代码和凭据的任务，应默认 fail-closed：先限制字段，再按需放开。
- Trace 复盘必须和 Event Log、审批记录、Git commit 一起看，不能单独当事实源。

推演：

- 更成熟的 agent 平台会把采样策略和任务风险等级联动：普通任务低成本采样，高风险任务强制保留关键 span，敏感字段只保留受控 artifact 引用。
- 未来的“超级大脑”系统如果要自我优化，也应该只读脱敏后的 trace 聚合结果，而不是直接读取完整 prompt、用户资料和凭据。

## 参考与复核说明

- [OpenTelemetry Sampling](https://opentelemetry.io/docs/concepts/sampling/)：用于核验 head sampling、tail sampling 和采样适用条件。
- [OpenTelemetry Collector Processors](https://opentelemetry.io/docs/collector/components/processor/)：用于核验 processors 在 Collector 管道中的位置和组件类型。
- [OpenTelemetry Collector configuration best practices](https://opentelemetry.io/docs/security/config-best-practices/)：用于核验 Collector 认证、加密、组件最小化、敏感数据清理和资源保护建议。
- [OpenTelemetry Handling sensitive data](https://opentelemetry.io/docs/security/handling-sensitive-data/)：用于核验敏感数据处理责任和数据最小化原则。
- [Tail Sampling Processor README](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/tailsamplingprocessor/README.md)：用于核验 `status_code`、`latency`、`string_attribute`、`probabilistic` 等策略方向。
- [Redaction Processor README](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/redactionprocessor/README.md)：用于核验 allowed keys、blocked values、blocked key patterns 和 HMAC hash 等配置方向。
