# CQRS：读写分离与多 agent 查询视图

最后核验：2026-05-19

CQRS 是 Command Query Responsibility Segregation 的缩写，通常译作“命令查询职责分离”。它的核心思想是：改变状态的写操作和读取状态的查询操作，可以使用不同模型、不同接口，甚至不同存储。

如果只记一句话，可以记成：

```text
写入负责改变世界，查询负责看清世界。
```

这对多 agent 系统很重要。因为 agent 协作时，一边会产生大量任务事件，一边又需要快速查询“哪些任务待审”“哪些任务失败”“哪个 agent 正在写”“哪些内容已批准”。

## Command 和 Query

| 类型 | 做什么 | 例子 | 是否改变状态 |
| --- | --- | --- | --- |
| Command | 发出改变系统状态的意图 | 创建任务、认领任务、写入证据、批准发布 | 是 |
| Query | 查询当前状态或视图 | 查待审批任务、查失败任务、查某 agent 负载 | 否 |

在简单系统里，读写可以共用一套表。但当系统变成多 agent、多状态、多复核、多审计时，共用模型会变得别扭：写入模型关注一致性和规则，查询模型关注速度和可读性。

## 和 Event Sourcing 的关系

[Event Sourcing：事件溯源与任务回放](event-sourcing.md) 负责保存状态变化历史，CQRS 负责把写入和查询分开。二者常一起出现，但不是必须绑定。

组合起来时，常见结构是：

```text
Command -> 写入事件流 -> 更新快照/读模型 -> Query 读取视图
```

例如：

```text
task_claimed 事件写入事件流
        ↓
更新 tasks_current 视图
        ↓
查询“当前谁拥有这个任务”
```

事件流适合回放，读模型适合查询。不要让每次查询都从头回放所有事件，否则系统会越来越慢。

## 多 agent 系统为什么需要它

一个 OpenClaw / CLI 多 agent 系统至少有两类需求：

### 写入侧

- 创建任务。
- 认领任务。
- 写入证据。
- 生成上下文包。
- 写入草稿。
- 提交复核结果。
- 批准或拒绝发布。
- 发布或回滚。

这些操作需要严格检查权限、状态流转和幂等性。

### 查询侧

- 今天有哪些任务等待人工审批。
- 哪些任务失败超过 2 次。
- 哪个 agent 正在占用锁。
- 最近 24 小时哪些任务消耗最多。
- 哪些草稿有安全风险标签。
- 哪些任务已经发布但还没写回总结。

这些查询更关心速度、筛选和面向人的视图。

CQRS 的意义，就是不要用同一个结构同时满足两类完全不同的需求。

## 一个最小 CQRS 设计

```text
commands/
  create_task
  claim_task
  add_evidence
  request_review
  approve_task
  publish_task

event_log/
  task-20260519-001.jsonl

read_models/
  tasks_current
  tasks_waiting_approval
  agent_workload
  failed_tasks
```

写入时：

```text
command -> validate -> append event -> update read model
```

查询时：

```text
query -> read model -> response
```

读模型可以是 SQLite 表、JSON 文件、搜索索引、看板视图或云文档表。关键是它为查询优化，不承担事实来源职责。

如果你要把这套结构真正落地，下一步要理解两个词：[Read Model 与 Projection：读模型与投影](read-model-projections.md)。读模型是查询视图，Projection 是把事件或写入模型持续转换成读模型的更新逻辑。

## 把 CQRS 落到 SQLite

对 OpenClaw、本地 CLI、多 agent 书稿维护和个人工作台来说，SQLite 是很合适的第一版读模型。它不需要复杂服务，却能让任务状态、agent 工作量、审批队列和风险清单变成稳定查询。

一个轻量结构可以是：

```text
task_events        = 事实历史，按时间追加
tasks_current      = 当前任务状态
agent_workload     = agent 当前工作量
risk_queue         = 待人工复核风险队列
projection_state   = 每个读模型处理到哪个事件
```

对应的查询可以很直接：

```sql
SELECT task_id, title, owner, priority, risk_level
FROM tasks_current
WHERE status = 'waiting_approval'
ORDER BY risk_level DESC, priority ASC, updated_at ASC;
```

这类查询不应该每次从事件流重新计算。更好的方式是：写入侧产生事件，Projection 更新 `tasks_current`，查询侧只查读模型。

## Projection 刷新节奏

CQRS 的一个常见坑，是以为所有读模型都必须实时一致。实际系统里，应该按风险和用途分级。

| 读模型 | 推荐刷新 | 原因 |
| --- | --- | --- |
| 发布审批队列 | 同步或短延迟异步 | 人会据此批准外部发布 |
| 当前任务看板 | 异步，允许几秒延迟 | 主要用于协作观察 |
| agent 工作量 | 异步或定时 | 调度需要新鲜，但不一定毫秒级 |
| 成本和失败统计 | 定时刷新 | 更像报表 |
| 风险队列 | 短延迟异步，并显示更新时间 | 安全相关，不能长期落后 |

最重要的是：每个读模型都要显示或记录自己更新到哪个事件。否则当读模型落后时，人和 agent 会把旧状态误当成新事实。

## 最终一致处理

CQRS 往往会引入最终一致。最终一致可以接受，但不能含糊。

建议规则：

- 写入成功只代表 command 或事件写入成功，不一定代表所有查询视图都更新完成。
- 对发布、删除、授权、付款等高风险动作，写后读要等待关键读模型更新。
- 对看板、统计、日志检索，可以允许延迟，但页面要显示更新时间。
- Projection 必须幂等，同一事件重复处理不应该让计数重复增加。
- 如果读模型损坏，应能从事件流清空重建。

这个边界也适合 agent 系统：agent 可以根据读模型做下一步建议，但高风险结论要回到事件、证据和人工复核。

## 任务系统示例

假设事件流里有这些事件：

```json
{"type":"task_created","task_id":"task-001","actor":"human"}
{"type":"task_claimed","task_id":"task-001","actor":"writer-agent"}
{"type":"draft_written","task_id":"task-001","actor":"writer-agent"}
{"type":"review_blocked","task_id":"task-001","actor":"review-agent","reason":"missing source"}
```

可以生成两个读模型：

```text
tasks_current
task_id   status          owner          blocker
task-001  review_blocked  writer-agent   missing source
```

```text
agent_workload
agent          active_tasks  blocked_tasks
writer-agent   1             1
review-agent   0             0
```

第一个视图给调度器看，第二个视图给人或控制台看。它们都来自同一批事件，但服务不同问题。

## 看板查询样例

在书稿维护系统中，读模型可以直接支撑多个看板。

### 待复核章节

```sql
SELECT chapter_id, title, missing_items, owner, updated_at
FROM chapter_status
WHERE review_status = 'needs_review'
ORDER BY updated_at ASC;
```

### 多次失败任务

```sql
SELECT task_id, title, failure_count, last_error
FROM tasks_current
WHERE failure_count >= 2
ORDER BY failure_count DESC, updated_at ASC;
```

### agent 负载

```sql
SELECT agent_id, active_tasks, blocked_tasks, waiting_review_tasks
FROM agent_workload
ORDER BY active_tasks DESC, blocked_tasks DESC;
```

这些查询的价值不是“更像数据库”，而是让人和 agent 不必翻长日志、不必读完整黑板，也能快速判断下一步。

## 和黑板架构的关系

[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) 关注共享工作台，CQRS 关注工作台背后的读写模型。

一个实际系统可以这样分层：

```text
Command side = 任务状态变化入口
Event log = 状态变化历史
Read model = 当前可查询视图
Blackboard = 人和 agent 共享的工作台
Context Engineering = 从黑板和读模型中生成本轮上下文
```

黑板可以显示读模型，但不一定直接就是写入模型。这样做可以减少并发冲突，也能让人工界面保持清晰。

## 常见误解

| 误解 | 更准确的说法 |
| --- | --- |
| CQRS 必须配合微服务 | 不必须，单体、本地工具和 SQLite 也可以用轻量 CQRS |
| CQRS 必须配合 Event Sourcing | 不必须，但二者经常一起使用 |
| CQRS 就是读写两个数据库 | 不一定，重点是模型和职责分离 |
| CQRS 能让系统自动变简单 | 相反，它会增加复杂度，只适合读写需求明显不同的场景 |
| 查询永远实时一致 | 很多 CQRS 系统接受最终一致，需要在界面上处理延迟 |

## 什么时候值得用

值得：

- 写入规则复杂，查询需求也复杂。
- 多个 agent 会频繁改变任务状态。
- 需要为人、调度器、复核 agent 提供不同视图。
- 需要事件溯源、审计和回放。
- 当前状态表已经难以同时服务写入和查询。

不值得：

- 任务很少。
- 只有一个 agent。
- 只需要简单 CRUD。
- 查询并不复杂。
- 团队还没有处理最终一致和读模型更新的经验。

## 练习

选一个真实任务系统，写出它的 Command 和 Query：

```text
系统名称：
会改变状态的 command：
不会改变状态的 query：
哪些 query 需要独立读模型：
读模型多久更新一次：
读模型和事件流不一致时怎么办：
```

如果你列不出明显不同的 command 和 query，说明这个系统暂时不需要 CQRS。

## 参考与复核说明

- [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html)：用于核验 CQRS 的基本定义、适用边界和复杂度提醒。
- [Microsoft Learn: CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)：用于核验 CQRS 作为读写分离架构模式的工程说明、优点、问题和适用场景。

本页把 CQRS 映射到 OpenClaw、多 agent、黑板架构和事件溯源，是本书的工程化推演；CQRS 本身不是 AI 专属概念。
