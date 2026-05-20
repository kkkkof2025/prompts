# Saga：补偿事务与流程编排

最后核验：2026-05-19

Saga 解决的是跨多个服务、多个 agent 或多个本地事务的长流程一致性问题。它不是把分布式事务硬塞回一个全局锁里，而是把大流程拆成一串本地事务；如果中间失败，就执行补偿动作，把系统拉回一个可接受状态。

如果只记一句话，可以记成：

```text
把长任务拆成一串本地动作，每一步都可审计；失败时不要幻想全局回滚，而是准备好补偿。
```

这页和 [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)、[CQRS：读写分离与多 agent 查询视图](cqrs.md) 是一组。事件溯源负责记录过程，Outbox 负责可靠分发，Saga 负责把分布式长任务编排起来。

如果流程需要跨崩溃、重启、人工等待和外部回调继续执行，可以继续看 [Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md)。

## 这个模式解决什么

在多 agent 或多服务系统里，常见的任务不是一次性 CRUD，而是这种链路：

```text
草稿完成 -> 复核通过 -> 人工批准 -> 发布推送 -> 站点可见
```

每一步都可能成功，也可能失败。你很难让它们共享一个大事务，因为：

- 每一步可能在不同服务里。
- 每一步可能依赖不同权限。
- 每一步可能花不同时间。
- 每一步失败后的恢复方式不同。

Saga 的思路是：每一步先做本地提交，再决定下一步；如果失败，就执行逆向动作或补偿流程。

## 两种组织方式

| 方式 | 怎么运作 | 适合 | 风险 |
| --- | --- | --- | --- |
| Choreography | 各参与方通过事件自己触发下一步 | 参与者少、流程简单 | 难以追踪，容易出现依赖环 |
| Orchestration | 中央协调器决定下一步让谁做什么 | 参与者多、流程复杂、需要统一可见性 | 协调器本身会变成一个关键依赖 |

对于 OpenClaw 这类多 agent 工作台，**编排式 Saga** 更容易看懂，因为它和任务调度、状态机、审批流更像。

## 一个书稿发布 Saga

下面是一个很贴近本书的例子：

| 步骤 | 本地动作 | 补偿动作 | 说明 |
| --- | --- | --- | --- |
| 1 | `draft_written` | 删除或标记草稿失效 | 只在本地写草稿，不对外发布 |
| 2 | `review_passed` | 重新打开复核 | 如果后续失败，复核不应继续沿用旧结论 |
| 3 | `approved` | 撤销批准 | 人工批准不是不可撤回的神谕 |
| 4 | `publish_started` | 标记失败、释放锁 | 发布开始不等于发布完成 |
| 5 | `push_succeeded` | 无补偿，进入完成态 | 这一步通常是最终可见点 |

一个失败例子：

```text
approved -> publish_started -> push_failed
```

如果发布失败，Saga 不应该假装任务已经完成，而应该：

```text
1. 把任务标记为 failed 或 publishing_failed。
2. 释放发布锁。
3. 通知 review 或 human 重新处理。
4. 记录失败原因和重试次数。
```

## Process Manager 是什么

Process Manager 可以理解成 Saga 的协调器实现。它负责：

- 记录当前流程走到哪一步。
- 根据事件决定下一条 command。
- 遇到失败时触发补偿。
- 把长流程状态写回数据库或事件流。

一个最小状态表可以是：

```sql
CREATE TABLE saga_instances (
  saga_id TEXT PRIMARY KEY,
  saga_name TEXT NOT NULL,
  task_id TEXT NOT NULL,
  current_step TEXT NOT NULL,
  status TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE saga_step_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  saga_id TEXT NOT NULL,
  step_name TEXT NOT NULL,
  command_id TEXT NOT NULL,
  status TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

这不是事实源，而是流程控制器的运行状态。真正的事实仍然应该在事件流里留痕。

## 一个最小编排伪代码

```text
on event task_created:
    emit command claim_task

on event task_claimed:
    emit command add_evidence

on event review_passed:
    emit command request_approval

on event approved:
    emit command publish_task

on event push_failed:
    emit command reopen_review
    emit command release_publish_lock
```

这个写法的关键是：Saga 不直接“神奇地修复一切”，它只是把后续动作变成明确的命令和补偿命令。

## 在 OpenClaw 里怎么用

在 OpenClaw 任务系统里，Saga 很适合这些长流程：

- 书稿章节从草稿到发布。
- 多 agent 共同完成一次资料核验。
- 一个任务要同时更新黑板、读模型、Git 和通知系统。
- 一个失败步骤必须触发补偿，而不是静默覆盖状态。

如果你已经在用 [Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)，那么 Saga 可以把“可靠发出去”的事件编成“可靠往前走的流程”。

## 和 Event Sourcing、Outbox、CQRS 的关系

```text
Event Sourcing = 记录发生过什么
Transactional Outbox = 可靠把消息发出去
Saga = 可靠把多个步骤串起来
CQRS / Read Model = 可靠把当前状态查出来
```

四者一起时，常见分工是：

- 事件流保存每一步的真实记录。
- Outbox 保证流程事件可靠传递。
- Saga / Process Manager 决定下一步做什么。
- 读模型显示当前任务处于哪一段流程。

## 什么时候值得用

值得：

- 任务跨多个服务、多个 agent 或多个审批人。
- 中间失败后需要补偿，而不是直接终止。
- 你想把流程状态显式建模出来。
- 你需要审计、重试、观察和补偿日志。

不值得：

- 只是单表更新。
- 只需要一次性脚本。
- 没有明确的补偿动作。
- 团队还没有准备好处理最终一致和流程状态机。

## 练习

把你正在处理的一条长任务写成 Saga：

```text
任务名称：
步骤 1：
步骤 2：
步骤 3：
每一步的补偿动作：
哪个步骤之后不可逆：
谁来当 Process Manager：
失败后怎么恢复：
```

如果你写不出补偿动作，这条流程暂时还不适合做成 Saga。

## 参考与复核说明

- [Microsoft Learn: Saga pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/saga/saga)：用于核验 Saga 的本地事务、补偿事务、编排与协作式实现方式。
- [Microsoft Learn: Cloud-native data patterns](https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/distributed-data)：用于核验分布式数据、一致性、Saga 与 CQRS/Event Sourcing 的关系。
- [microservices.io: Pattern - Saga](https://microservices.io/patterns/data/saga.html)：用于核验 Saga 在数据库 per service 场景中的经典解释。

本页把 Saga、Process Manager 和补偿事务映射到 OpenClaw 多 agent 长流程，是本书的工程化推演。
