# Transactional Outbox 与幂等消费

最后核验：2026-05-19

Transactional Outbox 解决的是一个很常见的分布式问题：同一次业务操作里，既要写数据库，又要发事件或消息。只要这两个动作分开做，就会出现“双写”风险。

如果只记一句话，可以记成：

```text
先把事件和业务数据放进同一个事务里，再让独立 worker 可靠地把事件送出去；消费端则要能重复处理同一条消息而不出错。
```

这页和 [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](cqrs.md) 以及 [Read Model 与 Projection：读模型与投影](read-model-projections.md) 是一组。事件溯源负责记录事实，读模型负责查询，Transactional Outbox 负责把事实可靠送到下游。

## 为什么需要它

假设一个 agent 完成任务后要同时做两件事：

1. 更新本地任务状态。
2. 通知下游的投影 worker、通知系统或另一个 agent。

如果这两件事分开执行，就会出现两类失败：

- 数据库成功了，但消息没发出去。
- 消息发出去了，但数据库回滚了。

AWS 和 Microsoft 的架构说明都强调，这类双写会导致不一致。Outbox 的思路，就是把“业务数据”和“待发事件”放在同一个数据库事务里，先保证落库一致，再由独立 worker 负责发布。

## 最小结构

```text
command -> DB transaction -> business table + outbox table -> relay worker -> message broker -> consumer
```

### 业务表

业务表保存系统事实，例如任务标题、状态、责任人、风险等级。

### Outbox 表

Outbox 表保存“要发出去的事件”。

```sql
CREATE TABLE outbox_events (
  outbox_id TEXT PRIMARY KEY,
  event_id TEXT NOT NULL,
  aggregate_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL,
  published_at TEXT
);

CREATE INDEX idx_outbox_status_created_at ON outbox_events(status, created_at);
CREATE UNIQUE INDEX idx_outbox_event_id ON outbox_events(event_id);
```

一个常见做法是：业务表更新成功的同时，Outbox 表也插入一条待发布记录。

## 可靠发布流程

```text
1. command 进入写入侧。
2. 同一个事务里更新业务表和 outbox_events。
3. relay worker 扫描 pending 记录。
4. worker 发送消息到消息总线或事件流。
5. 发送成功后，把 outbox 记录标成 published。
6. 发送失败时保留 pending，稍后重试。
```

这个流程的关键不是“绝对不出错”，而是“出错后可重试、可恢复、不会丢事实”。

## 消费端为什么必须幂等

即使 Outbox 已经做了可靠发布，消费者仍然可能收到重复消息。AWS 在事务发件箱模式里明确提醒，消费端应该按已处理消息做幂等处理；Microsoft 也把它和可靠事件发布联系起来。

幂等消费的最小做法，是给消费者维护一张“已处理事件表”。有些团队把它叫 `inbox_events`，有些团队叫 `processed_messages`。名字不重要，目的只有一个：同一条消息处理第二次时，不要重复改变结果。

```sql
CREATE TABLE processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TEXT NOT NULL,
  consumer_name TEXT NOT NULL
);
```

消费伪代码：

```text
if message_id already in processed_messages:
    skip
else:
    apply message
    write message_id to processed_messages
```

## 在 OpenClaw 里怎么用

在多 agent 工作台里，Transactional Outbox 很适合这些场景：

- 一个 agent 写完草稿，要通知投影 worker 更新读模型。
- 一个 agent 完成复核，要通知发布流程。
- 一个 agent 写入证据，要通知别的 agent 重新计算风险队列。

这样设计后，agent 不必直接调用所有下游系统，只要把事实写入本地事务和 Outbox，后续由 relay 负责发出去。

这比“写完马上手动调用三个系统”更稳，因为它把可靠性问题收敛到了一个可审计的发布通道。

## 和 Event Sourcing 的关系

Event Sourcing 更关心“事实怎么记”；Transactional Outbox 更关心“事实怎么可靠发”。

可以把它们组合起来理解：

```text
Event Sourcing = 事实源
Transactional Outbox = 事实分发通道
Projection = 事实的查询转换器
Idempotent Consumer = 重复消息的安全阀
```

一个任务系统常见结构是：

- 事件流保存真相。
- Outbox 保存待发消息。
- Projection worker 消费消息更新读模型。
- 消费端用幂等表跳过重复消息。

## 和读模型的关系

如果你的 `tasks_current`、`agent_workload` 或 `risk_queue` 是由事件驱动更新的，那么 Outbox 可以作为“从写入侧通向读模型”的可靠出口。

```text
write model -> outbox -> relay -> projection worker -> read model
```

这个链路里，任何一环都不能假设“只会收到一次”。因此：

- Outbox 表要能重试。
- 消费端要能幂等。
- 读模型要能按 `event_id` 或 `message_id` 去重。

仓库里的 [任务事件日志样例](../examples/event-log/index.md) 故意放了一条重复 `event_id`，就是为了演示幂等消费应该怎样跳过重复投递。

如果你的任务不是单次消息分发，而是多步骤长流程，可以继续看 [Saga：补偿事务与流程编排](saga-process-manager.md)。

## 什么时候值得用

值得：

- 写入和发消息必须同时可靠。
- 任务状态要通知多个下游系统。
- 需要减少双写一致性问题。
- 读模型更新依赖事件分发。

不值得：

- 只是本地脚本一次性写文件。
- 没有下游消费者。
- 系统还没有明确的重试和审计需求。

## 练习

选一个你正在维护的任务流，回答这几个问题：

```text
业务表是什么：
Outbox 表保存什么：
谁负责 relay：
消费端怎么去重：
哪一步允许重试：
哪一步不能重复执行：
```

如果你答不出“消费端怎么去重”，说明这个系统还不能放心异步发事件。

## 参考与复核说明

- [AWS Prescriptive Guidance: Transactional outbox pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)：用于核验双写问题、Outbox 表、重试、顺序和幂等消费的工程说明。
- [Microsoft Learn: Transactional Outbox pattern with Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transactional-outbox-cosmos)：用于核验 Transactional Outbox 与可靠消息、变更馈送和幂等处理的关系。
- [Microsoft Learn: Implement the Transactional Outbox Pattern by Using Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/architecture/databases/guide/transactional-out-box-cosmos)：用于核验已处理标记、发布成功后更新状态和可靠事件发布流程。

本页里的“inbox”主要指消费端的幂等记录表，不是独立于幂等消费之外的另一套神秘概念。
