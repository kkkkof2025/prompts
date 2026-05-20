# Durable Execution：持久化执行与 agent 长任务

最后核验：2026-05-20

Durable Execution 可以译成“持久化执行”。它关注的是：一个长时间运行的任务，即使进程崩溃、机器重启、网络中断或等待人工审批，也能从已完成步骤继续，而不是从头再来。

如果只记一句话，可以记成：

```text
不是让代码永远不失败，而是让失败后知道已经做到哪一步，并从那里继续。
```

这页和 [Saga：补偿事务与流程编排](saga-process-manager.md)、[Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md) 是一组。Saga 关注长流程怎么补偿，Durable Execution 关注长流程怎么跨失败继续执行。

## 它解决什么

agent 长任务经常不是几秒钟就完成：

- 等待人工批准。
- 等待外部 API 返回。
- 等待 GitHub Actions 构建。
- 等待网页、飞书、Telegram、云文档回调。
- 多次调用模型、工具、浏览器和 CLI。
- 中途被重启、断网或额度限制打断。

如果只用普通脚本，常见问题是：

- 脚本中断后不知道哪一步完成了。
- 重跑会重复执行已经完成的步骤。
- 等人工审批时需要自己保存状态。
- 定时器、重试、回调和补偿散落在各处。

Durable Execution 的目标，就是把这些“长任务状态”变成基础设施能力。

## 基本模型

不同平台叫法不同，但大致都有这些概念：

| 概念 | 白话解释 | 在 agent 系统里的例子 |
| --- | --- | --- |
| Workflow | 长流程定义 | 书稿发布、资料复核、代码修复 |
| Activity / Step | 可重试的外部动作 | 调模型、跑测试、提交 Git、发通知 |
| Durable Timer | 可恢复的等待 | 等 30 分钟后重试、等到明天提醒 |
| Event History | 工作流历史 | 记录每一步输入、输出、定时器和信号 |
| Signal / Callback | 外部事件进入流程 | 人工批准、构建完成、消息回复 |
| Replay | 用历史重放工作流决策 | 崩溃后恢复到正确状态 |

一个最小结构：

```text
Workflow code
  -> schedule activity
  -> persist event history
  -> wait timer / signal
  -> replay decision
  -> continue from next step
```

## 和普通队列的区别

普通队列通常适合“把一件事交给 worker 做”。Durable Execution 更适合“一个长任务由很多步骤组成，中间会等待、重试、恢复和观察”。

| 方式 | 适合 | 不足 |
| --- | --- | --- |
| 普通脚本 | 一次性本地任务 | 中断后恢复难 |
| 任务队列 | 独立短任务 | 长流程状态要自己管 |
| Cron | 定时触发 | 不知道前后步骤关系 |
| Saga | 流程与补偿建模 | 仍要处理执行状态持久化 |
| Durable Execution | 长流程、等待、重试、恢复 | 要遵守确定性和版本管理约束 |

它不是替代所有队列，而是把“长流程运行时”抽出来。

## 在 OpenClaw 里的例子

假设 OpenClaw 要执行一个“发布书稿章节”的长任务：

```text
1. 生成上下文包。
2. 调用写作 agent。
3. 等待复核 agent。
4. 等待人工批准。
5. 调用发布 agent。
6. 等待 GitHub Pages 构建。
7. 检查线上页面。
8. 写回发布记录。
```

普通脚本容易在第 4 步或第 6 步断掉。Durable Execution 的做法是：每完成一步都把历史写下来；如果中断，恢复时不会重新调用已经完成的写作 agent，也不会重复发批准消息，而是继续等下一步。

## 和 Saga 的关系

Saga 关注“失败后怎么补偿”，Durable Execution 关注“失败后怎么继续跑”。

它们可以一起用：

```text
Durable Execution = 让流程活下来
Saga = 让失败有补偿路径
```

例如：

- Durable Execution 记录 `publish_started` 已经完成。
- 发布失败后，Saga 决定触发 `release_lock` 和 `reopen_review`。
- Outbox 把补偿命令可靠发出去。
- Read Model 显示任务进入 `publishing_failed`。

## 和 Event Sourcing 的关系

二者都依赖历史记录，但关注点不同。

| 概念 | 历史记录用来做什么 |
| --- | --- |
| Event Sourcing | 重建业务状态，审计发生过什么 |
| Durable Execution | 恢复工作流执行，避免重复跑已完成步骤 |

在简单系统里，可以用同一份事件流做两件事；在更严肃的系统里，工作流历史和业务事件最好分开。因为“工作流调度历史”和“业务事实历史”不是同一个概念。

## 确定性约束

很多 Durable Execution 系统会用 replay 恢复工作流。也就是说，系统会重新执行 workflow 代码，但根据历史跳过已完成步骤。

这会带来一个重要约束：workflow 决策代码要尽量确定性。

不要在 workflow 决策层直接做这些事：

- 读取当前随机数。
- 读取当前系统时间。
- 直接调用外部 API。
- 依赖会变化的全局状态。

更好的做法是：

- 把外部动作放到 Activity / Step。
- 把时间等待放到 Durable Timer。
- 把人工回复作为 Signal / Callback。
- 把不可重复副作用交给幂等 activity 或 Outbox。

这条规则对 agent 很重要：模型调用、浏览器操作、Git 操作和 API 调用都应该是 activity，而不是藏在 workflow 决策层里。

## 版本升级问题

长流程可能跑几小时、几天甚至几周。你不能假设所有任务都会在你改代码前结束。

升级时要考虑：

- 正在运行的旧流程还会继续 replay。
- 旧流程可能看不懂新字段。
- 新流程不能破坏旧历史。
- 有些系统需要显式版本标记。

一个稳妥做法：

```text
workflow_version: 1
schema_version: 1
activity_contract_version: 1
```

升级时先让新任务使用新版本，旧任务按旧版本跑完；不要让未完成的长任务突然换规则。

## 和 AI agent 的特殊关系

Durable Execution 对 AI agent 尤其有用，因为 agent 动作天然不稳定：

- 模型输出可能波动。
- 工具调用可能失败。
- 浏览器页面可能变化。
- 人工批准可能隔很久才回来。
- 多 agent 交接可能中断。

但也要小心：Durable Execution 不能保证模型输出一定正确，它只保证流程状态更可靠。内容质量仍然要靠评估、证据、复核和人工闸门。

## 最小设计模板

```text
workflow_name:
workflow_id:
workflow_version:
trigger:
steps:
  - step_name:
    activity:
    retry_policy:
    timeout:
    idempotency_key:
    compensation:
waits:
  - signal_name:
    timeout:
read_models:
  - tasks_current
  - risk_queue
human_gates:
  - approval_required_before_publish
```

这个模板可以用在 OpenClaw、Codex CLI、Claude CLI 或任何自建 agent 工作台里。重点不是立刻安装某个平台，而是先把长流程的状态和恢复规则写清楚。

## 什么时候值得用

值得：

- 任务会运行很久。
- 中间会等待人工、定时器或外部回调。
- 重复执行会造成成本或风险。
- 需要清楚看到流程卡在哪一步。
- 需要跨重启、崩溃和网络失败继续。

不值得：

- 一次性短脚本。
- 失败后直接重跑也没成本。
- 没有长等待、回调或人工审批。
- 团队还没有能力处理确定性和版本升级。

## 练习

选一个真实 agent 长任务，按下面格式写一页：

```text
长任务名称：
可能持续多久：
哪些步骤不能重复：
哪些步骤可以重试：
哪里需要人工 signal：
哪里需要 durable timer：
失败后从哪里继续：
是否需要 Saga 补偿：
```

如果你找不到“不能重复”的步骤，说明这个任务可能暂时不需要 Durable Execution。

## 参考与复核说明

- [Temporal Docs](https://docs.temporal.io/)：用于核验 durable execution、workflow、activity、事件历史和失败后恢复的基本描述。
- [Microsoft Learn: Durable Functions](https://learn.microsoft.com/en-us/azure/azure-functions/durable-functions/)：用于核验 Durable Functions 作为 Azure Functions 的有状态编排扩展。
- [Restate Docs: Durable Execution](https://docs.restate.dev/concepts/durable_execution/)：用于核验 durable execution 作为持久化步骤、恢复和跳过已完成步骤的运行时能力。
- [DBOS Docs](https://docs.dbos.dev/)：用于核验 DBOS 作为基于工作流状态和执行历史的 durable execution / durable workflow 工具路线。

本页把 Durable Execution 映射到 OpenClaw、多 agent 和 CLI 长任务，是本书的工程化推演。Durable Execution 本身不是 AI 专属概念。
