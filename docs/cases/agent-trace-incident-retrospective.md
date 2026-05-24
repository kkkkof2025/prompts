# Agent Trace 生产事故复盘长案例

最后核验：2026-05-20

这个案例演示一个多 agent 书稿发布系统如何用 trace、事件日志、审批记录和补偿动作复盘事故。它不是某个真实组织的事故记录，而是把本书前面几页的模式组合成一个可学习的长案例。

建议配合这些页面阅读：

- [Observability / Tracing：智能体可观测性](../observability-tracing-agent-workflows.md)
- [Agent Trace 可观测性样例](../../examples/trace-observability/index.md)
- [跨 Agent Trace Context 传播样例](../../examples/trace-observability/trace-context-propagation.md)
- [OpenTelemetry 生产化加固样例](../../examples/trace-observability/otel-production-hardening.md)
- [Event Sourcing：事件溯源与任务回放](../event-sourcing.md)
- [Saga：补偿事务与流程编排](../saga-process-manager.md)

## 背景

一个小团队维护一本 AI 学习方法开源书。系统里有几个 agent：

| 角色 | 责任 | 权限 |
| --- | --- | --- |
| `orchestrator-agent` | 读取任务卡，分派给其他 agent | 只读任务表和路线图 |
| `research-agent` | 核验资料和来源 | 可以访问公开网页和资源附录 |
| `writer-agent` | 修改 Markdown 草稿 | 可以改指定文件 |
| `review-agent` | 检查事实、安全、链接和敏感信息 | 可以读 diff、trace 和检查输出 |
| `publish-agent` | 运行检查、提交、推送 | 需要人工批准后才可发布 |

团队已经做了几件事：

- 任务状态写入事件日志。
- 每次运行产生 trace span。
- OpenTelemetry Collector 做采样和脱敏。
- 高风险任务必须人工审批。

看起来已经很稳，但一次事故暴露了两个问题：

1. 部分 agent handoff 没有传播 `traceparent`，导致 trace 断裂。
2. `writer-agent` 把“高风险注册自动化案例”的描述写得过细，触发安全复核。

## 事故摘要

```text
事故编号：INC-TRACE-20260520-001
发现时间：2026-05-20 10:06 +08:00
影响范围：一条书稿更新任务被阻塞，未发布到 GitHub Pages
关联 task_id：task-book-risk-041
关联 trace_id：trace-book-risk-041
最终状态：blocked，等待人工改写
```

读者要注意：这不是“发布事故”，因为高风险内容没有发布。它是“差点误发布 + 排障困难”的事故。系统挡住了风险，但排障体验很差。

## 事故前的错误设计

事故前，任务交接是这样的：

```text
orchestrator-agent -> writer-agent -> review-agent -> publish-agent
```

任务卡里只有：

```json
{
  "task_id": "task-book-risk-041",
  "title": "补 AI 注册自动化和公益站风险案例",
  "risk_level": "high"
}
```

没有 `traceparent`。每个 agent 自己启动时都新建 trace。结果看板里出现三条记录：

```text
trace-a: writer-agent wrote draft
trace-b: review-agent blocked draft
trace-c: publish-agent saw no approval
```

人能看出它们可能有关，但系统不能自动把它们连起来。

## 时间线

| 时间 | 事件 | 证据 |
| --- | --- | --- |
| 10:00 | 任务被创建 | `task_created` event |
| 10:01 | `orchestrator-agent` 分派任务 | trace-a root span |
| 10:02 | `writer-agent` 写草稿 | trace-b root span |
| 10:04 | `review-agent` 标记高风险 | trace-c root span |
| 10:05 | `publish-agent` 拒绝发布 | `publish_blocked` event |
| 10:06 | 维护者收到阻塞通知 | 飞书任务状态 |
| 10:12 | 维护者开始复盘 | trace 看板、事件日志、diff |
| 10:28 | 改写为合规说明 | Git diff |
| 10:36 | 复核通过，等待发布 | `approval_granted` event |

## 看板上的症状

`trace_summary` 里看到三条 trace：

| trace_id | workflow | status | actor | 问题 |
| --- | --- | --- | --- | --- |
| `trace-a` | `book_update` | ok | `orchestrator-agent` | 只看到分派 |
| `trace-b` | `book_update` | ok | `writer-agent` | 看不到上游任务卡 |
| `trace-c` | `book_update` | error | `review-agent` | 看不到草稿生成过程 |

`failure_queue` 只显示：

```text
review-agent / safety_review / error / blocked_reason=unsafe_detail
```

这条信息有用，但不够。维护者还要知道：

- 这段内容是谁写的？
- 用了哪个上下文包？
- 是否来自用户笔记、公开网页，还是 agent 自己扩写？
- 是否已经进入 Git commit？
- 是否触发了补偿动作？

## 事件日志里的事实

事件日志提供事实源：

```json
{"event_type":"task_created","task_id":"task-book-risk-041","risk_level":"high"}
{"event_type":"draft_written","task_id":"task-book-risk-041","draft_ref":"git://worktree/docs/ai-history-community-ecosystem.md"}
{"event_type":"review_failed","task_id":"task-book-risk-041","reason":"unsafe_detail"}
{"event_type":"publish_blocked","task_id":"task-book-risk-041","reason":"missing_approval"}
```

这些事件说明：

- 任务确实存在。
- 草稿确实被写入工作区。
- 复核确实失败。
- 发布确实被阻止。

但事件日志不解释运行细节。它不会告诉你 `writer-agent` 为什么写出高风险细节，也不会告诉你上下文从哪里断了。这正是 trace 的作用。

## Trace 复盘

维护者手工把三条 trace 对齐后，发现断点：

| 步骤 | 发现 | 判断 |
| --- | --- | --- |
| 分派 | `orchestrator-agent` 没有把 carrier 写入任务元数据 | trace 传播断裂 |
| 写作 | `writer-agent` 从任务标题直接扩写，没有读取安全案例更新指南 | 上下文包缺安全材料 |
| 复核 | `review-agent` 发现“绕过授权”类细节 | 安全拦截有效 |
| 发布 | `publish-agent` 没有看到人工批准 | 发布闸门有效 |

这里有两个好消息：

- 高风险内容没有发布。
- 发布动作没有绕过人工审批。

也有两个坏消息：

- Trace 断裂导致复盘慢。
- 写作 agent 的上下文包没有把安全边界放在足够靠前的位置。

## 根因

根因不是“模型不够聪明”。根因是工程系统没有把边界传进去。

```text
直接原因：
writer-agent 写出了过细的高风险操作描述。

流程原因：
任务标题要求“补注册自动化案例”，但上下文包没有强制包含安全案例更新指南和禁止边界。

可观测性原因：
handoff 没有传播 traceparent，导致运行路径断裂。

治理原因：
风险等级虽然写在任务卡里，但没有自动影响采样、上下文包和人工闸门。
```

## 修复方案

### 1. 传播 trace context
{: #1-传播tracecontext }

任务卡增加：

```json
{
  "task_id": "task-book-risk-041",
  "risk_level": "high",
  "trace": {
    "traceparent": "00-4bf92f3577b34da6a3ce929d0e0e4736-1111111111111111-01",
    "tracestate": ""
  }
}
```

每个 agent 读取上游 carrier，创建自己的 span，再写出新的 carrier。这样看板里会变成一条 trace：

```text
trace-book-risk-041
  load_task_card
  build_context_pack
  write_draft
  safety_review
  compensation_reopen_review
  wait_human_approval
```

### 2. 高风险任务强制上下文包
{: #2-高风险任务强制上下文包 }

`risk_level=high` 时，`context-agent` 必须加入：

- 安全案例更新指南。
- 事故复盘案例集。
- 本书关于“不得提供绕过授权、批量注册、破解或规避风控步骤”的维护规则。
- 输出边界：可以讲风险、治理、识别和合法替代流程，不能写绕过步骤。

### 3. 采样策略联动风险等级
{: #3-采样策略联动风险等级 }

Collector tail sampling 增加规则：

```text
agent.risk_level in ["high", "critical"] -> keep
status == ERROR -> keep
latency > 30s -> keep
normal task -> probabilistic sample
```

这样高风险任务不依赖随机采样，不会因为“普通比例采样”而丢掉关键 trace。

### 4. 脱敏和引用策略
{: #4-脱敏和引用策略 }

Trace 中只保存：

- `artifact://context-packs/task-book-risk-041.md`
- `git://worktree/docs/ai-history-community-ecosystem.md`
- `review://safety/task-book-risk-041`

Trace 中不保存：

- 完整 prompt。
- 原始用户私密笔记。
- token、cookie、API key。
- 任何可以被误用的绕过步骤。

### 5. 补偿动作
{: #5-补偿动作 }

`review_failed` 后，Saga 不直接重跑写作，而是进入补偿：

```text
compensation_reopen_review
  -> task.status = blocked
  -> assign = maintainer
  -> require rewrite plan
  -> forbid publish until approval
```

这一步很重要。很多 agent 系统失败后会自动重试，但高风险内容不适合盲目重试。应该先转人工复核。

## 修复后的验收标准

| 验收项 | 通过标准 |
| --- | --- |
| trace 连续 | 一条 trace 能看到分派、上下文、写作、复核、补偿 |
| 事实源完整 | 事件日志能重建任务状态 |
| 敏感字段 | trace 后端不出现密钥、邮箱、token、完整 prompt |
| 高风险采样 | `risk_level=high` 的 trace 必须保留 |
| 人工闸门 | review failed 后不能自动发布 |
| 可复盘 | 维护者能在 10 分钟内定位责任步骤和下一步动作 |

## 改写后的安全内容样例

错误写法：

```text
下面列出绕过授权验证和批量注册的具体操作步骤……
```

可接受写法：

```text
注册自动化可以作为安全治理案例讨论，但不应提供绕过授权、规避风控或批量创建账号的操作步骤。合规方向是：明确授权范围、限制测试环境、记录审计日志、使用官方 API 或沙箱账号，并由人工审批确认目的、频率和数据范围。
```

这个改写保留了学习价值，但把可执行滥用细节换成了治理、审计和授权流程。

## 复盘结论

这次事故说明：

- Trace context 传播不是锦上添花。没有它，多 agent 排障会退回手工拼图。
- 安全拦截成功不代表系统体验好。拦住以后，还要能说明为什么拦、谁来改、怎样恢复。
- 高风险任务不适合和普通任务用同样的采样、上下文和重试策略。
- Event Log、Trace、Read Model、审批记录各有职责，不能互相替代。

## 可复制复盘模板

```text
任务：
风险等级：
是否发布：

事件日志是否能重建状态：
trace 是否连续：
是否有断裂的 agent handoff：
失败 span：
失败原因：
上下文包缺口：
脱敏检查结果：
补偿动作：
人工审批结果：

根因：
改进动作：
验收标准：
```

## 练习

把你自己的一个 agent 工作流套进这个模板：

1. 选一个高风险或中风险任务。
2. 写出 task event log 的四个事件。
3. 写出 trace 的六个 span。
4. 标出哪个 handoff 最容易丢 trace context。
5. 写出如果复核失败，应该进入重试、补偿还是人工审批。

如果你只能写出“失败了就重跑”，说明这个流程还不适合自动化。
