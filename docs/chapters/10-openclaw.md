# 第 10 章：OpenClaw 与个人 AI 助手工作台

OpenClaw 是一个开源个人 AI 助手项目。按照其官方仓库介绍，它把多通道输入、长期记忆、工具调用和 MCP 等能力组合到个人助手场景中。这里不把它当作唯一答案，而把它当作理解 agent 工作台的案例。

## 本章导读

- 预计阅读时间：12-18 分钟。
- 学习目标：把个人助手看成多能力组合；理解多通道输入、记忆、工具和协议如何协作；设计个人助手的最小需求和权限边界。
- 练习入口：[章节练习与验收映射表](../chapter-validation-map.md) 和 [Agent 工作流安全检查清单](../../examples/agent-workflow-checklist.md)。
- 相关材料：[图解：AI 工作系统](../diagrams.md)、[OpenClaw 多 agent 联动教程](../openclaw-multi-agent-linkage.md)、[Blackboard Architecture：黑板架构与多 agent 协作](../blackboard-architecture-multi-agent.md)、[Event Sourcing：事件溯源与任务回放](../event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](../cqrs.md)、[Read Model 与 Projection：读模型与投影](../read-model-projections.md)、[Transactional Outbox 与幂等消费](../transactional-outbox-idempotency.md)、[Saga：补偿事务与流程编排](../saga-process-manager.md)、[Durable Execution：持久化执行与 agent 长任务](../durable-execution-agent-workflows.md)、[Observability / Tracing：智能体可观测性](../observability-tracing-agent-workflows.md)、[OpenClaw、Node.js 与超级大脑架构](../openclaw-superbrain-architecture.md) 和 [前沿与过时技术案例库](../technology-evolution-cases.md)。

## 为什么关注 OpenClaw

学习 AI agent 时，很多概念会显得抽象：工具、记忆、上下文、协议、触发器、权限。OpenClaw 这类项目的价值，是把这些能力放进一个更完整的产品形态里。

你可以把个人 AI 助手工作台理解为：

```text
聊天入口 + 语音/文本/文件输入 + 记忆 + 工具 + 知识库 + 外部协议 + 自动化工作流
```

## OpenClaw 能帮助理解什么

多通道交互：AI 不只在网页聊天框中工作，也可以通过语音、桌面、移动端或其他入口交互。

长期记忆：助手需要知道用户偏好、历史项目和上下文。

工具生态：助手可以连接搜索、文件、日历、任务、浏览器、代码环境或其他服务。

MCP 集成：通过标准化协议连接外部工具和数据源，降低每个工具单独适配的成本。

本地与云端权衡：个人助手通常要平衡体验、隐私、成本和可用性。

## 学习 OpenClaw 的方式

不要一开始就急着安装所有东西。建议按以下顺序学习：

1. 阅读官方 README，理解项目目标和架构。
2. 看它支持哪些输入通道和工具。
3. 看记忆系统如何保存和检索信息。
4. 看 MCP 或外部工具如何接入。
5. 找一个最小任务测试，例如“读取一段资料并生成待办”。
6. 再考虑是否接入真实账户或私有数据。

如果你已经不满足于单个个人助手，可以继续看 [OpenClaw 多 agent 联动教程](../openclaw-multi-agent-linkage.md)。它把飞书、Telegram、云文档、统一 skill 包和任务状态表串成一个多 agent 协同案例。如果你想理解这种协同背后的共享工作台模型，可以继续读 [Blackboard Architecture：黑板架构与多 agent 协作](../blackboard-architecture-multi-agent.md)。

如果你想判断 OpenClaw 的技术选型，例如为什么会用 Node.js、Markdown 中间层是否够快、怎样和 Codex CLI 或 Claude CLI 协同，可以继续看 [OpenClaw、Node.js 与超级大脑架构](../openclaw-superbrain-architecture.md)。如果你想把任务状态做成可查询看板，再继续看 [Read Model 与 Projection：读模型与投影](../read-model-projections.md)；如果你想把发布、审批和回滚变成长流程状态机，再继续看 [Saga：补偿事务与流程编排](../saga-process-manager.md)；如果你想让长任务跨重启继续，继续看 [Durable Execution：持久化执行与 agent 长任务](../durable-execution-agent-workflows.md)；如果你想排查一次任务为什么慢、贵、失败或误判，继续看 [Observability / Tracing：智能体可观测性](../observability-tracing-agent-workflows.md)。

## 一个个人助手最小需求

```text
目标：
每天帮我整理学习资料和待办。

输入：
- 我粘贴的文章链接或笔记。
- 我当天的任务想法。

输出：
- 3 条关键摘要。
- 今日待办。
- 需要后续学习的问题。

记忆：
- 记录我长期学习 AI 的目标。
- 记录我偏好的输出格式。

工具：
- 可以搜索公开资料。
- 可以读写指定项目目录。

边界：
- 不访问密码、密钥和私人账户。
- 不自动发布内容。
- 删除文件前必须确认。
```

## OpenClaw 类项目的风险

个人助手越强，越可能接触敏感数据。使用前要考虑：

- 它会保存什么记忆。
- 记忆存在哪里。
- 哪些工具有写权限。
- 是否会把数据发送到第三方模型。
- 是否有日志和删除机制。
- 项目是否仍在活跃维护。

### 实战：AI助手的一天

与其抽象描述，不如看一次真实的24小时。下面是一个产品经理使用 AI 助手的工作日流水：

```text
08:30 助手自动执行：
  - 读取昨天的会议记录 → 生成今日待办
  - 检查日历 → 提醒 10:00 有评审会
  - 从知识库检索上周的产品数据 → 生成会前摘要

10:00 评审会期间：
  - 用户粘贴会议聊天记录
  - 助手提取 3 条决定 + 5 条待办 + 2 个风险点
  - 自动标记"待办"给对应负责人

14:00 下午工作：
  - 用户提供竞品截图 → 助手分析差异点 → 生成对比表
  - 助手检测到上次周报模板有更新 → 自动追加新字段

17:30 收尾：
  - 助手总结今日完成事项 + 未完成事项
  - 更新项目状态到记忆文件
  - 为明天的待办做预排序（紧急/重要矩阵）

20:00 长期维护（自动）：
  - 检查知识库是否有过期文档（>90天未更新但未标记"已存档"）
  - 生成"本周 AI 使用复盘"：今天哪些 prompt 有效、哪些需要改进
```

> **关键观察**：好的助手不只"回答问题"，而是**主动预判需求**。它知道你的日程、你的项目、你的输出偏好。这靠的不是"更聪明"的模型，而是**设计得当的记忆和自动触发器**。

### 搭建个人助手的四步决策

不管你选择 OpenClaw 还是其他平台，决策顺序是一样的：

```text
第一步：定范围
  ✅ 只做资料整理和待办提醒
  ❌ 不要直接发邮件、付款、删文件

第二步：选入口
  📱 手机（随时随地记录想法）
  💻 桌面（重度工作时用）
  🤖 聊天工具（飞书/微信等已熟悉的界面）

第三步：接工具
  必须的：日历、任务列表、文件读写
  可选的：浏览器搜索、代码执行、云文档
  不要的：支付、删除、发布

第四步：跑 1 周再改
  不要一天配完所有功能。
  先跑最核心的 1 个任务（如"每天整理资料→生成待办"）。
  一周后看日志：哪些对了，哪些烦了，哪些根本没用。
```

> **最重要的决定**：不是选哪个平台，而是你决定让助手做什么、不让它做什么。30 天实践的第 22-24 天就是让你实践这些的。

## 不依赖某个工具的学习重点

即使你不用 OpenClaw，也应该掌握以下能力：

- 为个人助手定义任务边界。
- 管理长期记忆。
- 给工具设置权限。
- 设计可复用 skill。
- 为 agent 行动设置人工确认点。
- 定期审查自动化结果。

## 练习

设计你的个人 AI 助手说明书：

```text
助手名称：
主要用途：
每天固定任务：
允许读取的资料：
允许写入的位置：
禁止动作：
需要记住的信息：
需要定期遗忘的信息：
```

## 本章收尾

- 本章练习：设计一个个人 AI 助手的最小需求清单，写清输入入口、记忆范围、可用工具、权限边界和人工确认点。
- 相关案例：结合 [图解：AI 工作系统](../diagrams.md)、[OpenClaw 多 agent 联动教程](../openclaw-multi-agent-linkage.md)、[Observability / Tracing：智能体可观测性](../observability-tracing-agent-workflows.md)、[OpenClaw、Node.js 与超级大脑架构](../openclaw-superbrain-architecture.md) 和 [前沿与过时技术案例库](../technology-evolution-cases.md) 理解助手工作台的演进。
- 下一步：进入 [第 11 章](11-hermes-himes-open-models.md)，把个人助手背后的模型路线和记忆研究分开看。

## 章节导航

[上一章：第 9 章：记忆系统与个性化助手](09-memory.md) | [下一章：第 11 章：Hermes、HiMeS 与开源模型路线](11-hermes-himes-open-models.md)
