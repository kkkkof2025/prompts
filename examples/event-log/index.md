# 任务事件日志样例

这个目录提供一个最小任务事件流，用来配合 [Event Sourcing：事件溯源与任务回放](../../docs/event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](../../docs/cqrs.md) 和 [Read Model 与 Projection：读模型与投影](../../docs/read-model-projections.md) 阅读。如果你想看一次运行路径怎样被 trace 记录，可以继续看 [Agent Trace 可观测性样例](../trace-observability/index.md)。

它解决的是一个很具体的问题：多 agent 协作时，当前状态会不断变化，但复盘时真正需要知道的是“谁在什么时候做了什么，为什么进入这个状态，是否重复投递，是否需要人工介入”。事件日志把这些变化写成追加式记录，再通过回放生成读模型。

## 文件

- `task-events.jsonl`：按 JSONL 保存的任务事件，每行一条事件。
- `replay-task-events.ps1`：把事件流回放成读模型快照。

## 事件字段

本样例使用自定义事件格式，不是生产协议。字段设计故意保持简单，方便读者看清事件溯源、CQRS 和 Projection 的关系。

| 字段 | 作用 | 示例 |
| --- | --- | --- |
| `event_id` | 全局唯一事件编号，用于幂等去重 | `evt-20260519-0007` |
| `task_id` | 被事件影响的任务 | `task-book-001` |
| `type` | 业务事件类型 | `review_blocked` |
| `actor` | 触发事件的人或 agent | `review-agent` |
| `timestamp` | 事件发生时间 | `2026-05-19T09:48:00+08:00` |
| `schema_version` | 事件格式版本，方便以后迁移 | `1` |
| `correlation_id` | 同一条任务链路的关联编号 | `run-book-001` |
| `causation_id` | 当前事件由哪条事件触发 | `evt-20260519-0006` |
| `payload` | 业务载荷，不同事件类型可以不同 | `{"reason":"缺少对事件同步失败的处理说明"}` |

后续如果要接入更正式的事件总线，可以参考 CloudEvents 这类事件元数据规范，把 `id`、`type`、`source`、`time` 等通用字段和业务 `data` 分开。本样例没有实现 CloudEvents，只保留“元数据和业务载荷分离”的设计思想。

## 事件类型

当前样例覆盖一条 AI 写作维护任务从创建到发布的常见路径：

| 事件类型 | 说明 | 回放后的典型状态 |
| --- | --- | --- |
| `task_created` | 人创建任务，写入标题、优先级和风险等级 | `open` |
| `task_claimed` | 某个 agent 认领任务 | `claimed` |
| `evidence_added` | 研究或复核 agent 添加证据来源 | 保持当前状态，增加证据计数 |
| `context_pack_generated` | 上下文 agent 生成上下文包 | 记录 `context_pack` |
| `draft_written` | 写作 agent 写入草稿 | `drafting` |
| `review_requested` | 草稿进入复核 | `waiting_review` |
| `review_blocked` | 复核发现阻塞问题 | `blocked` |
| `review_passed` | 复核通过，等待人工批准 | `waiting_approval` |
| `approved` | 人工批准 | `approved` |
| `publish_started` | 发布开始 | `publishing` |
| `push_succeeded` | 推送成功 | `published` |
| `push_failed` | 推送失败 | `failed` |
| `rolled_back` | 已回滚 | `rolled_back` |

这组事件不是为了覆盖所有业务，而是为了让读者看到一条典型多 agent 工作流：写作、研究、上下文整理、复核、人工审批、发布和失败处理。

## 回放

在仓库根目录运行：

```powershell
./scripts/replay-task-events.ps1 -InputPath examples/event-log/task-events.jsonl
```

生成 JSON 快照：

```powershell
./scripts/replay-task-events.ps1 -InputPath examples/event-log/task-events.jsonl -OutputPath tmp/task-read-models.json
```

回放结果包含三类读模型：

- `tasks_current`：每个任务的当前状态、负责人、风险等级、草稿文件、阻塞原因和最后更新时间。
- `agent_workload`：每个 agent 当前活跃任务、阻塞任务和待复核任务数量。
- `risk_queue`：高风险或被阻塞的任务队列，适合给人工维护者优先处理。

这就是 CQRS 在样例里的落点：事件日志是写入事实，读模型是为了查询和看板而生成的视图。读模型可以删掉重建，但事件日志不应该随便改。

## 这个样例演示什么

- 一个任务从创建、认领、写草稿、复核、批准到推送成功。
- 一个任务停在 `waiting_review`，适合显示在待复核看板。
- 一个高风险任务停在 `blocked`，适合显示在风险队列。
- 最后一条事件故意重复了 `event_id`，用来演示消费者按事件编号幂等跳过重复投递。

## 怎样读失败样例

`task-book-003` 是这个样例里最值得看的部分。它的主题是“复核 AI 公益站与注册自动化风险案例”，风险等级为 `high`，最后停在 `blocked`。这说明安全 agent 不是简单地继续生成教程，而是把任务卡在人工需要判断的位置。

这个设计对应本书的安全边界：涉及账号、授权、注册自动化、规避限制、隐私或版权时，事件日志应该记录“为什么不能继续自动执行”。如果未来把这个样例接入 OpenClaw、飞书或 Telegram，风险队列就可以直接变成一个人工审批入口。

重复的 `evt-20260519-0019` 是第二个关键点。现实系统中消息队列、Webhook、云文档回调和重试机制都可能重复发送同一件事。消费者不能只因为收到两次就把阻塞原因写两遍，也不能重复触发审批、发布或回滚。最小做法是保留 `event_id` 去重；更完整的做法是增加 Inbox 表、处理状态、重试次数和死信队列。

## 和 trace、runtime log 的区别

事件日志、trace 和 runtime log 很容易混在一起。本书按下面方式区分：

| 材料 | 记录什么 | 主要用途 |
| --- | --- | --- |
| 任务事件日志 | 业务事实：任务创建、复核、批准、发布、阻塞 | 审计、回放、生成读模型 |
| Trace / span | 运行路径：哪段代码、哪个 agent、哪个工具调用耗时多久 | 排障、性能分析、上下文传播 |
| Runtime log | 面向人类复盘的运行摘要 | 教学、截图、事故复盘、人工沟通 |

如果一次任务发布失败，事件日志回答“业务状态如何变化”，trace 回答“运行链路在哪里断了”，runtime log 回答“人应该怎样读懂这次失败”。

## 可以怎样扩展

- 增加 `traceparent` 字段，把业务事件和 OpenTelemetry trace 连接起来。
- 增加 `source` 字段，区分来自飞书、Telegram、GitHub、CLI、定时任务还是人工输入。
- 增加 `idempotency_key`，把“命令请求去重”和“事件消费去重”分开。
- 增加 `schema_version` 迁移样例，演示 v1 事件如何投影到 v2 读模型。
- 把回放结果写入 SQLite，和 [Trace Backend 选型与查询策略](../trace-observability/trace-backend-selection.md) 一起比较 JSONL、SQLite 和正式后端的边界。

这个样例不是生产级事件系统，只是把书里的概念变成可以运行和检查的最小材料。

## 参考与复核说明

- [CloudEvents 规范](https://github.com/cloudevents/spec)：用于理解事件元数据和业务数据分离的通用思路。本样例没有实现 CloudEvents 标准。
- [OpenTelemetry Logs](https://opentelemetry.io/docs/concepts/signals/logs/)：用于区分业务事件、运行日志和可观测性日志的边界。
- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于理解后续如果增加 `traceparent` 字段，应怎样和跨系统 trace 关联。
