# 术语回链索引

这页解决一个具体问题：读到一个术语时，怎样快速回到定义、章节、案例和常见误解。术语的白话解释仍以 [AI 术语表](appendix-glossary.md) 为准；这页更像“导航表”。

## 使用方法

- 第一次看到术语：先点术语表，确认它在本书里的日常含义。
- 想知道怎么用：跳到关联章节，看它解决什么问题。
- 想做练习：跳到配套材料或案例页，按模板改写自己的任务。
- 想避免踩坑：先看常见误解，再去做练习。

## 核心术语回链表

| 术语 | 先读定义 | 关联章节 | 配套材料 | 常见误解 |
| --- | --- | --- | --- | --- |
| Prompt | [Prompt](appendix-glossary.md#prompt) | [第 3 章](chapters/03-prompt-basics.md)、[第 4 章](chapters/04-prompt-workflows.md) | [Prompt 模式实践模板](../examples/prompt-patterns.md)、[Prompt 调试指南](prompt-debugging-guide.md) | 把 prompt 当成“神奇咒语”，忽略目标、背景、约束和验收标准 |
| System Prompt | [System Prompt](appendix-glossary.md#system-prompt) | [第 3 章](chapters/03-prompt-basics.md)、[第 13 章](chapters/13-safety-governance.md) | [AI 安全案例更新指南](safety-case-updates.md) | 以为系统提示能替代权限控制和人工复核 |
| Blackboard Architecture | [Blackboard Architecture](appendix-glossary.md#blackboard-architecture) | [Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md)、[第 8 章](chapters/08-agents.md)、[第 10 章](chapters/10-openclaw.md) | [OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)、[Context Engineering：上下文工程](context-engineering.md) | 把黑板误解成聊天群或共享文件夹，忽略控制器、状态、锁、分区和人工裁决 |
| Style Engineering | [Style Engineering](appendix-glossary.md#style-engineering) | [Style Engineering 与 AI Native 创作](style-engineering-ai-native.md)、[第 3 章](chapters/03-prompt-basics.md)、[第 4 章](chapters/04-prompt-workflows.md) | [Prompt 调试指南](prompt-debugging-guide.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 把风格工程当成单次 prompt，而不是长期约束、样例、反例和评估系统 |
| Context Window | [Context Window](appendix-glossary.md#context-window) | [第 2 章](chapters/02-ai-basics.md)、[第 6 章](chapters/06-tools-rag.md) | [AI 任务选择决策指南](task-decision-guide.md) | 以为上下文越长越可靠，忽略结构化和引用 |
| Context Engineering | [Context Engineering](appendix-glossary.md#context-engineering) | [Context Engineering：上下文工程](context-engineering.md)、[第 6 章](chapters/06-tools-rag.md)、[第 9 章](chapters/09-memory.md) | [RAG、Skill、Agent 与 Memory 连续案例](cases/rag-skill-agent-memory.md)、[前沿资料季度复核执行手册](frontier-review-playbook.md) | 把上下文工程当成“把所有资料塞进去”，忽略选择、排序、压缩、隔离和来源追踪 |
| CQRS | [CQRS](appendix-glossary.md#cqrs) | [CQRS：读写分离与多 agent 查询视图](cqrs.md)、[Event Sourcing：事件溯源与任务回放](event-sourcing.md) | [OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 把 CQRS 当成所有系统默认架构，忽略它带来的复杂度和最终一致问题 |
| Read Model / Projection | [Read Model](appendix-glossary.md#read-model)、[Projection](appendix-glossary.md#projection) | [Read Model 与 Projection：读模型与投影](read-model-projections.md)、[CQRS：读写分离与多 agent 查询视图](cqrs.md) | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 把读模型当成事实源，或忘记投影失败、延迟和重建机制 |
| Materialized View | [Materialized View](appendix-glossary.md#materialized-view) | [Read Model 与 Projection：读模型与投影](read-model-projections.md) | [CQRS：读写分离与多 agent 查询视图](cqrs.md) | 误以为所有数据库都原生支持同名机制，或把物化视图当成事实源 |
| Transactional Outbox / Idempotent Consumer | [Transactional Outbox](appendix-glossary.md#transactional-outbox)、[Idempotent Consumer](appendix-glossary.md#idempotent-consumer) | [Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)、[Event Sourcing：事件溯源与任务回放](event-sourcing.md) | [Read Model 与 Projection：读模型与投影](read-model-projections.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 把事件分发当成一次性动作，忽略重复投递、重试和去重 |
| Inbox | [Inbox](appendix-glossary.md#inbox) | [Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md) | [Read Model 与 Projection：读模型与投影](read-model-projections.md) | 把消费端去重表误解成另一个事实源 |
| Saga / Process Manager | [Saga](appendix-glossary.md#saga)、[Process Manager](appendix-glossary.md#process-manager)、[Compensation](appendix-glossary.md#compensation) | [Saga：补偿事务与流程编排](saga-process-manager.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md) | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 把 Saga 当成自动回滚，忽略补偿设计和流程状态 |
| Durable Execution | [Durable Execution](appendix-glossary.md#durable-execution)、[Durable Timer](appendix-glossary.md#durable-timer) | [Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md)、[Saga：补偿事务与流程编排](saga-process-manager.md) | [OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md) | 以为持久化执行能保证模型内容正确，忽略评估、复核和人工闸门 |
| Observability / Tracing | [Observability](appendix-glossary.md#observability)、[OpenTelemetry](appendix-glossary.md#opentelemetry)、[Metric](appendix-glossary.md#metric)、[Span](appendix-glossary.md#span)、[Trace](appendix-glossary.md#trace) | [Observability / Tracing：智能体可观测性](observability-tracing-agent-workflows.md)、[Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md) | [Agent Trace 可观测性样例](../examples/trace-observability/index.md)、[OpenTelemetry 最小接入样例](../examples/trace-observability/otel-minimal-instrumentation.md)、[OpenTelemetry 生产化加固样例](../examples/trace-observability/otel-production-hardening.md)、[跨 Agent Trace Context 传播样例](../examples/trace-observability/trace-context-propagation.md)、[Agent Trace 生产事故复盘长案例](cases/agent-trace-incident-retrospective.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 把 trace 当成事实源，或把敏感输入、密钥和个人资料直接写进日志 |
| Token | [Token](appendix-glossary.md#token) | [第 2 章](chapters/02-ai-basics.md) | [AI 学习与使用速查讲义](quick-reference.md) | 只把 token 理解为字数，忽略成本、截断和上下文预算 |
| Hallucination | [Hallucination](appendix-glossary.md#hallucination) | [第 2 章](chapters/02-ai-basics.md)、[第 5 章](chapters/05-evaluation.md) | [常见误区与纠偏指南](common-pitfalls.md)、[章节复盘题与小测](chapter-review-questions.md) | 以为模型“自信”就等于事实正确 |
| Evaluation | [Evaluation](appendix-glossary.md#evaluation) | [第 5 章](chapters/05-evaluation.md) | [AI 能力评估量表](assessment-rubric.md)、[章节练习与验收映射表](chapter-validation-map.md) | 只看一次输出好不好，不建立可重复的评估样例 |
| Event Sourcing | [Event Sourcing](appendix-glossary.md#event-sourcing) | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) | [OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 为简单任务过度设计，或把普通日志误当成可回放的事件源 |
| RAG | [RAG](appendix-glossary.md#rag) | [第 6 章](chapters/06-tools-rag.md) | [AI 工作流配方库](workflow-recipes.md)、[模型选型案例](model-selection-cases.md) | 以为接入知识库就不会错，忽略检索质量和权限边界 |
| Embedding | [Embedding](appendix-glossary.md#embedding) | [第 6 章](chapters/06-tools-rag.md) | [图解：AI 工作系统](diagrams.md) | 把向量相似度当成事实证明 |
| Vector Database | [Vector Database](appendix-glossary.md#vector-database) | [第 6 章](chapters/06-tools-rag.md) | [团队 AI 落地手册](team-adoption-playbook.md) | 只关注存储工具，忽略文档分块、更新和删除机制 |
| Function Calling / Tool Use | [Function Calling](appendix-glossary.md#function-calling)、[Tool Use](appendix-glossary.md#tool-use) | [第 6 章](chapters/06-tools-rag.md)、[第 8 章](chapters/08-agents.md) | [Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md) | 工具能执行就直接放权，缺少确认、日志和回滚 |
| Skill | [Skill](appendix-glossary.md#skill) | [第 7 章](chapters/07-skills.md) | [AI Skill/Card 可复用模板](../examples/skill-card-template.md) | 把 skill 当成单条 prompt，而不是可维护的能力包 |
| Agent | [Agent](appendix-glossary.md#agent) | [第 8 章](chapters/08-agents.md)、[第 10 章](chapters/10-openclaw.md) | [前沿与过时技术案例库](technology-evolution-cases.md) | 以为 agent 越自主越好，忽略权限、观察和停止条件 |
| Memory | [Memory](appendix-glossary.md#memory) | [第 9 章](chapters/09-memory.md) | [AI 安全事故复盘案例集](safety-incident-retrospectives.md) | 把长期记忆当成无风险便利功能，忽略更新、删除和隐私 |
| MCP | [MCP](appendix-glossary.md#mcp) | [第 11 章](chapters/11-hermes-himes-open-models.md)、[第 12 章](chapters/12-frontier-landscape.md) | [资源与引用](appendix-resources.md)、[前沿资料季度复核执行手册](frontier-review-playbook.md) | 把协议名当成万能生态，忽略具体实现和权限模型 |
| A2A | [A2A](appendix-glossary.md#a2a) | [第 11 章](chapters/11-hermes-himes-open-models.md)、[第 12 章](chapters/12-frontier-landscape.md) | [前沿资料季度复核记录表](frontier-review-log.md) | 只讨论多 agent 协作，忽略任务状态、责任边界和失败恢复 |
| Alignment / Guardrail | [Alignment](appendix-glossary.md#alignment)、[Guardrail](appendix-glossary.md#guardrail) | [第 13 章](chapters/13-safety-governance.md) | [AI 安全与模型选型工作坊](workshop-safety-model-selection.md) | 以为有安全声明就等于有治理流程 |
| Multimodal | [Multimodal](appendix-glossary.md#multimodal) | [第 2 章](chapters/02-ai-basics.md)、[第 12 章](chapters/12-frontier-landscape.md) | [模型选型案例](model-selection-cases.md) | 只看是否支持图片或视频，不检查隐私、识别错误和成本 |
| Long Context | [Long Context](appendix-glossary.md#long-context) | [第 2 章](chapters/02-ai-basics.md)、[第 12 章](chapters/12-frontier-landscape.md) | [前沿与过时技术案例库](technology-evolution-cases.md) | 把长上下文当成 RAG 的完全替代 |
| Fine-tuning | [Fine-tuning](appendix-glossary.md#fine-tuning) | [第 5 章](chapters/05-evaluation.md)、[第 11 章](chapters/11-hermes-himes-open-models.md) | [中外 AI 模型特色概览](model-landscape-china-global.md) | 还没做 prompt、RAG 和评估，就急着微调 |
| Reasoning Model | [Reasoning Model](appendix-glossary.md#reasoning-model) | [第 5 章](chapters/05-evaluation.md)、[第 12 章](chapters/12-frontier-landscape.md) | [AI 模型选型实战案例集](model-selection-cases.md) | 把“推理强”误解为所有任务都更适合 |
| Prompt Injection | [Prompt Injection](appendix-glossary.md#prompt-injection) | [第 13 章](chapters/13-safety-governance.md) | [AI 安全案例更新指南](safety-case-updates.md)、[AI 安全事故复盘案例集](safety-incident-retrospectives.md) | 只在用户输入里找风险，忽略网页、邮件、文档和图片里的间接指令 |
| OpenClaw | [OpenClaw](appendix-glossary.md#openclaw) | [第 10 章](chapters/10-openclaw.md) | [前沿资料季度复核执行手册](frontier-review-playbook.md) | 把具体工具当成唯一答案，而不是个人 AI 工作台案例 |
| Hermes / HiMeS | [Hermes](appendix-glossary.md#hermes)、[HiMeS](appendix-glossary.md#himes) | [第 11 章](chapters/11-hermes-himes-open-models.md) | [资源与引用](appendix-resources.md)、[前沿资料季度复核记录表](frontier-review-log.md) | 混淆开放模型路线和个性化记忆系统，或把研究状态写成稳定产品结论 |

## 按问题回链

```text
输出不可信 -> Hallucination -> Evaluation -> 常见误区与纠偏指南
资料太长 -> Context Window -> Long Context -> RAG -> 第 6 章
资料很多但 AI 总看错 -> Context Engineering -> RAG -> Memory -> 第 6/9 章
想固化经验 -> Prompt -> Workflow -> Skill -> 第 7 章
想保持长期风格 -> Style Engineering -> Prompt 调试指南 -> Style Engineering 与 AI Native 创作
想让 AI 执行动作 -> Tool Use -> Agent -> Agent 安全检查清单
想让多个 agent 协作但不混乱 -> Blackboard Architecture -> OpenClaw 多 agent 联动教程
想回放和审计 agent 过程 -> Event Sourcing -> Blackboard Architecture -> OpenClaw 多 agent 联动教程
想让事件流变成好查的视图 -> CQRS -> Event Sourcing -> OpenClaw 超级大脑架构
想把任务事件做成看板 -> Read Model / Projection -> CQRS -> Event Sourcing
想排查 agent 为什么慢、贵、失败或误判 -> Observability / Tracing -> Durable Execution -> Event Sourcing
想做团队知识库 -> RAG -> Vector Database -> 团队 AI 落地手册
担心数据和权限 -> Guardrail -> Prompt Injection -> 第 13 章
想理解前沿术语 -> MCP / A2A / OpenClaw / Hermes / HiMeS -> 前沿资料复核
```

## 维护规则

新增术语时，至少检查四个位置：

- [AI 术语表](appendix-glossary.md)：是否有一句话白话解释。
- 本页：是否能回链到章节、材料和常见误解。
- [主题索引](topic-index.md)：是否属于已有主题，或需要新增主题入口。
- [术语写法规范](term-style-guide.md)：是否需要固定大小写、中文译名或缩写写法。

不要为了显得前沿而堆术语。一个术语进入正文，最好能回答三个问题：它解决什么问题，它在哪些场景有用，它容易被误解成什么。
