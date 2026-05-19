# Event Sourcing：事件溯源与任务回放

最后核验：2026-05-19

Event Sourcing 通常译作“事件溯源”。它的核心不是只保存系统当前状态，而是保存状态是如何一步步变化出来的事件序列。

如果只记一句话，可以记成：

```text
不是只存结果，而是存结果怎么发生。
```

这对 AI 协作系统很有用，因为多 agent 任务最难复盘的，往往不是最终结果，而是中间发生了什么、谁改了什么、为什么改、是否被批准。

## 为什么它重要

在复杂协作里，单纯的当前状态表不够：

- 你知道任务现在是 `published`，但不知道它经历过哪些修改。
- 你知道某条结论被采纳，但不知道哪条证据、哪个 agent、哪次复核促成了它。
- 你知道结果出错了，但不知道是检索错了、写作错了，还是审批错了。
- 你想重放一次任务流程，但当前状态已经覆盖了中间路径。

事件溯源把这些变化保留下来，适合审计、回放、复盘和恢复。

## 和普通状态表的区别

| 方式 | 存什么 | 优点 | 短板 |
| --- | --- | --- | --- |
| 状态表 | 当前结果 | 简单、好查 | 看不到历史路径 |
| 事件流 | 每次变化 | 可回放、可审计、可复盘 | 设计更复杂 |
| 快照 + 事件流 | 当前结果 + 历史 | 查询和复盘都兼顾 | 需要维护两套视图 |

事件溯源系统通常会把事件流当作事实来源，再从事件流生成可查询的当前视图或快照。

## 一个事件记录

```yaml
event_id: evt-20260519-0012
task_id: task-20260519-001
type: evidence_added
actor: research-agent
timestamp: 2026-05-19T10:32:18+08:00
payload:
  source: docs/openclaw-multi-agent-linkage.md
  summary: 黑板适合承载任务、证据、假设和决策
  confidence: confirmed
```

一个任务的常见事件可能包括：

- `task_created`
- `task_claimed`
- `evidence_added`
- `context_pack_generated`
- `draft_written`
- `review_requested`
- `review_blocked`
- `approved`
- `published`
- `rolled_back`

这些事件最好是追加写入，而不是覆盖原记录。这样你才能知道一次任务到底经历了什么。

## 和黑板架构的关系

[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) 更关注“当前共享工作台”。
[Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) 更关注“工作台是如何一步步变化出来的”。

两者合在一起时，分工通常是：

- 黑板保存当前任务的可见状态。
- 事件流保存每次状态变化的历史。
- 快照从事件流计算出当前状态。
- 回放时可以按时间顺序重建任务过程。

对 OpenClaw、云文档、Git 和看板来说，这种组合很自然：

- 黑板负责给 agent 和人看现在。
- 事件流负责给审计、复盘和恢复看过去。

## 和 OpenClaw 的关系

在 OpenClaw 多 agent 联动里，事件溯源可以记录：

- 谁创建了任务。
- 谁认领了任务。
- 哪个 agent 写入了证据。
- 哪次复核阻止了发布。
- 哪次人工批准推动了提交。
- 哪次回滚撤销了错误结果。

这样一来，协作不是只剩一份最终稿，而是留下完整的演化链。

## 什么时候适合用

适合：

- 多 agent 协作。
- 需要审计和复盘。
- 需要重放任务路径。
- 需要保留人工批准链。
- 需要把状态变化同步到多个读模型。

不太适合：

- 只有一个小任务。
- 只想做简单 CRUD。
- 没有复盘和审计需求。
- 团队还没准备好处理事件演化和查询视图的复杂度。

## 事件溯源的代价

它不是默认答案。Microsoft Learn 也明确提示，这个模式有明显权衡：

- 数据模型更复杂。
- 并发控制更难。
- 查询通常要靠快照或物化视图。
- 迁移成本高。
- 不是所有系统都值得上。

所以，在本书里，事件溯源更适合被用作“黑板和多 agent 协作的审计层”，而不是所有 AI 项目的默认数据层。

## 练习

把一个真实协作任务写成事件流：

```text
任务名称：
会发生哪些事件：
谁能写事件：
哪些事件需要人工确认：
如何从事件流重建当前状态：
是否需要快照：
```

如果你能把任务写成事件序列，说明你已经开始从“记录结果”走向“记录过程”。

## 参考与复核说明

- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)：用于理解事件溯源作为架构模式的经典定义。
- [Microsoft Learn: Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)：用于核验事件溯源的优点、权衡、快照和读模型思路。

本页把事件溯源映射到 AI 协作、黑板架构和 OpenClaw，是本书的工程化推演；它不是在说所有 AI 工作都必须用事件溯源。
