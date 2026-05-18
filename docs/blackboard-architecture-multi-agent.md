# Blackboard Architecture：黑板架构与多 agent 协作

最后核验：2026-05-19

Blackboard Architecture 可以译成“黑板架构”。它来自早期 AI 系统设计：多个专门模块不直接互相私聊，而是围绕一个共享黑板协作。每个模块读取黑板上的当前状态、证据和中间结论，然后把自己的发现写回黑板；控制器再决定下一步该让哪个模块行动。

如果只记一句话，可以记成：

```text
黑板不是聊天群，而是共享工作台。
```

这对今天的多 agent 系统很有启发。很多多 agent 失败，不是因为 agent 不够多，而是因为没有一个共同可见、可审计、可仲裁的工作空间。

## 历史背景

黑板系统不是 2026 年才出现的新词。Hearsay-II 语音理解系统通常被视为早期代表，H. Penny Nii 在 1986 年的 AI Magazine 文章中系统整理了黑板模型、黑板框架和黑板系统的演化。

它的核心思想很朴素：复杂问题往往无法由一个模块按固定顺序解决，需要多个知识源在不同抽象层次上逐步贡献线索。黑板保存问题状态，中间假设、证据、约束和候选答案；控制机制决定哪个知识源在什么时候行动。

在 LLM 时代，黑板架构重新值得讨论，因为多 agent 系统也遇到了类似问题：

- 多个 agent 如何共享证据，而不是重复搜索。
- 多个 agent 如何看见彼此的中间结论，而不是只看最终消息。
- 系统如何决定下一个应该行动的是研究 agent、写作 agent、复核 agent 还是发布 agent。
- 冲突结论如何保留、比较和裁决。
- 人工确认点如何进入协作流程，而不是散落在聊天记录里。

## 三个基本组成

| 组件 | 在传统黑板系统中 | 在多 agent 系统中 |
| --- | --- | --- |
| Blackboard | 共享问题状态和中间结果 | 任务表、证据区、上下文包、决策记录、输出草稿 |
| Knowledge Sources | 专门知识源或推理模块 | 研究 agent、写作 agent、代码 agent、复核 agent、发布 agent |
| Control | 决定哪个知识源何时触发 | 调度器、状态机、优先级规则、人工审批闸门 |

这三者缺一不可。只有共享文档，没有控制器，会变成混乱文档。只有多个 agent，没有黑板，会变成群聊。只有控制器，没有知识源，就只是任务队列。

## 和普通消息协作的区别

| 维度 | 普通群聊式多 agent | 黑板式多 agent |
| --- | --- | --- |
| 信息位置 | 分散在消息流里 | 集中在共享状态里 |
| 中间结论 | 容易被后续消息淹没 | 可被标记、版本化、引用 |
| 冲突处理 | 依赖谁最后发言 | 保留假设、证据和裁决记录 |
| 任务调度 | agent 互相喊话 | 控制器根据黑板状态触发 |
| 审计 | 需要翻聊天记录 | 看任务、证据、状态和决策日志 |
| 适用场景 | 临时讨论 | 长任务、多角色、可复盘协作 |

黑板架构不要求所有系统都很重。一个 Markdown 文件、一张云文档表、一组 GitHub Issue 或一个 SQLite 表，都可以是最小黑板。关键不在工具，而在“共享状态是否结构化、是否有版本、是否能触发下一步”。

## 一个最小黑板结构

```yaml
blackboard_id: bb-20260519-001
task:
  title: 扩充 OpenClaw 多 agent 联动教程
  goal: 增加共享上下文、状态机和黑板架构说明
  status: drafting
  priority: high
context:
  rules:
    - 不提供绕过平台授权的方法
    - 新概念必须标注来源和边界
  sources:
    - docs/openclaw-multi-agent-linkage.md
    - docs/context-engineering.md
evidence:
  accepted:
    - 黑板系统是早期 AI 架构之一
    - 多 agent 可以通过共享状态减少重复搜索和消息丢失
  uncertain:
    - 某些 LLM 黑板架构论文仍属早期实验，不应写成行业标准
hypotheses:
  - 云文档可以作为人类可见黑板
  - Git issue 可以作为审计型黑板
locks:
  owner: writer-agent
  expires_at: 2026-05-19T18:00:00+08:00
decisions:
  - id: d1
    decision: 将黑板架构作为独立前沿专题接入目录
    by: human
outputs:
  draft: docs/blackboard-architecture-multi-agent.md
review:
  required:
    - markdown links
    - terminology
    - mkdocs strict build
```

这个结构看起来像任务卡，但它比任务卡更完整：它把任务、上下文、证据、假设、锁、决策、输出和复核放在同一个工作空间里。

## Agent 如何围绕黑板行动

```text
Observe：读取黑板上的任务、证据、状态和权限。
Propose：提出下一步行动或候选结论。
Write：把发现写回 evidence、hypotheses、outputs 或 decisions。
Control：调度器根据状态决定下一个 agent。
Review：复核 agent 或人工检查引用、权限、冲突和完成标准。
Commit：发布 agent 只处理已批准结果。
```

这比固定流水线更灵活。固定流水线适合步骤明确的任务；黑板架构适合“不知道下一步一定是谁最合适”的任务，比如研究、写作、代码排错、复杂资料整合和多角色复盘。

## 案例：AI 书稿维护黑板

假设你要维护一本 AI 学习方法书。一个任务从“想扩充 OpenClaw 联动教程”开始，但它可能需要多个 agent：

| Agent | 观察黑板 | 写回黑板 |
| --- | --- | --- |
| 资料 agent | 读取任务目标和资料需求 | 写入来源、摘要、不确定点 |
| 架构 agent | 读取现有章节和用户设想 | 写入状态机、模块边界、数据结构 |
| 写作 agent | 读取证据和结构 | 写入正文草稿 |
| 复核 agent | 读取草稿和规则 | 写入断链、术语、事实边界和风险标签 |
| 发布 agent | 读取批准状态 | 写入 commit hash、检查结果和发布记录 |

黑板里至少应该保留：

- 任务目标：这次到底要扩充什么。
- 资料来源：哪些事实已经核验。
- 上下文包：哪些规则、风格、权限和历史决定必须进入当前任务。
- 假设区：哪些是本书判断，不是外部事实。
- 冲突区：不同 agent 的结论哪里不一致。
- 决策区：谁批准了什么，为什么。
- 结果区：改了哪些文件，检查是否通过，提交号是什么。

这样做的好处是，下一次维护者不需要翻几百条对话，只要打开黑板就能恢复现场。

## 五种落地方式

| 方式 | 黑板载体 | 优点 | 短板 |
| --- | --- | --- | --- |
| Markdown 黑板 | `tasks/*.md` 或 `blackboard/*.md` | Git 留痕强，适合书稿和代码 | 实时性弱，并发控制要额外做 |
| 云文档黑板 | 飞书、多维表格、Notion、语雀 | 人类可见，适合审批和团队协作 | API、权限和格式需要治理 |
| Issue 黑板 | GitHub/GitLab Issue | 状态、讨论、提交关联清楚 | 对非工程团队不够友好 |
| SQLite 黑板 | 本地或轻量服务数据库 | 查询、锁、版本控制方便 | 需要写一层服务或脚本 |
| 事件流黑板 | Kafka、NATS、Redis Stream 等 | 适合高频自动化和多系统 | 对学习项目过重 |

对个人或小团队来说，最稳妥的起点通常是“云文档黑板 + Git 留痕 + 本地调度器”。等任务量和自动化需求真的上来，再把状态层迁移到 SQLite 或事件流。

## 和 Context Engineering 的关系

[Context Engineering：上下文工程](context-engineering.md) 关注“模型下一步应该看到什么”。黑板架构关注“多个 agent 如何共享和更新问题状态”。两者结合起来，会形成更稳定的多 agent 协作：

- 黑板保存全量任务状态。
- 上下文工程从黑板中选择当前 agent 需要看的最小信息。
- agent 处理任务后把新证据、新假设、新输出写回黑板。
- 控制器根据黑板状态决定下一步。

一个常见错误是把黑板整个塞给每个 agent。正确做法是：黑板是共享事实源，上下文包是本轮行动视图。不同 agent 看到的上下文应该不同。

## 和 OpenClaw 的关系

OpenClaw 这类个人 AI 工作台适合做执行入口，但多 agent 联动不能只靠入口。更稳的设计是：

```text
OpenClaw / CLI agent = 执行者
黑板 = 共享状态
Context Engineering = 当前视图生成器
Skill registry = 能力目录
Human gate = 审批和责任边界
Git / 云文档 = 结果留痕
```

这也解释了为什么“飞书 + Telegram + 云文档 + OpenClaw”不是简单拼工具，而是把任务源、通知层、黑板层、执行层和审计层分开。

## 常见失败模式

| 失败模式 | 表现 | 修复 |
| --- | --- | --- |
| 黑板变成垃圾桶 | 所有内容都往里塞，没人清理 | 分区、状态、过期、归档 |
| 每个 agent 都看全量黑板 | 成本高，噪音大，权限风险高 | 用上下文工程生成最小视图 |
| 没有控制器 | agent 都在写，但没人决定下一步 | 状态机、优先级、人工闸门 |
| 只保留最终结果 | 复盘时不知道为什么这样写 | 保留证据、假设、决策记录 |
| 冲突被覆盖 | 后写入的内容覆盖旧结论 | 冲突区、版本号、裁决记录 |
| 黑板权限过宽 | agent 看到不该看的资料 | 分区、脱敏、只读视图 |

## 什么时候不该用

以下情况不需要黑板架构：

- 单轮问答。
- 一个人一次性完成的小任务。
- 步骤非常固定的简单自动化。
- 不需要审计、不需要复盘、不需要多角色协作的任务。

黑板架构适合复杂任务，不适合为了显得高级而引入复杂度。

## 练习

选一个多 agent 或多人协作任务，写一个最小黑板：

```text
黑板名称：
任务目标：
黑板载体：
有哪些 agent 或角色：
每个角色能读什么：
每个角色能写什么：
哪些内容需要人工裁决：
完成后写回哪里：
如何复盘：
```

如果你写完后发现大部分字段都为空，说明这个任务可能暂时不需要多 agent，也不需要黑板架构。

## 参考与复核说明

- [H. Penny Nii, Blackboard Application Systems, Blackboard Systems and a Knowledge Engineering Perspective](https://ojs.aaai.org/aimagazine/index.php/aimagazine/article/view/550/0)：用于核验黑板系统与 Hearsay-II、应用系统、骨架系统等历史脉络。
- [H. Penny Nii, The Blackboard Model of Problem Solving and the Evolution of Blackboard Architectures](https://doi.org/10.1609/aimag.v7i2.537)：用于核验黑板模型、问题求解和架构演化的经典来源。
- [Exploring Advanced LLM Multi-Agent Systems Based on Blackboard Architecture](https://arxiv.org/abs/2507.01701)：用于了解黑板架构在 LLM 多 agent 系统中的近期研究尝试。该论文属于 2025 年预印本，应作为研究线索，不应写成已成为行业标准。

本页把黑板架构映射到 OpenClaw、云文档、Git、上下文工程和多 agent 协作，是本书的工程化推演；历史来源只支持黑板模型本身和相关系统脉络。
