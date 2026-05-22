# 主题索引

这是一份手工整理的主题导航页，不依赖额外插件。它的目的很简单：当你只有一个问题时，先找到对应主题，再进入章节、案例或工具页。

## 核心标签

| 主题标签 | 适合先看 | 相关章节 | 相关案例或材料 | 风险提醒 |
| --- | --- | --- | --- | --- |
| `prompt` / `对话` / `输出格式` | [第 1 章](chapters/01-dialogue-basics.md)、[第 3 章](chapters/03-prompt-basics.md) | 第 1-4 章 | [Prompt 模式实践模板](../examples/prompt-patterns.md)、[Prompt 调试指南](prompt-debugging-guide.md) | 任务不清时不要急着写长 prompt |
| `workflow` / `模板` / `复用` | [第 4 章](chapters/04-prompt-workflows.md)、[AI 工作流配方库](workflow-recipes.md) | 第 4 章 | [AI 工作流配方库](workflow-recipes.md)、[常用检查清单](appendix-checklists.md) | 没有检查点时别把复杂任务一次交给 AI |
| `评估` / `选型` / `验证` | [第 5 章](chapters/05-evaluation.md)、[模型选型实战案例集](model-selection-cases.md) | 第 5 章 | [中外 AI 模型特色概览](model-landscape-china-global.md)、[AI 能力评估量表](assessment-rubric.md)、[产品案例](cases/product.md) | 不要只看榜单或宣传；AI 功能要用最小实验验证 |
| `工具` / `RAG` / `知识库` | [第 6 章](chapters/06-tools-rag.md) | 第 6 章 | [RAG、Skill、Agent 与 Memory 连续案例](cases/rag-skill-agent-memory.md)、[教学资料库连续案例](cases/teaching-rag-skill-agent-memory.md)、[连续案例练习与复盘评分表](cases/continuous-case-exercises.md)、[团队 AI 落地手册](team-adoption-playbook.md)、[安全案例更新指南](safety-case-updates.md) | 权限、引用和更新流程必须先定 |
| `skill` / `agent` / `memory` / `OpenClaw` | [第 7-10 章](chapters/07-skills.md)、[第 8 章](chapters/08-agents.md) | 第 7-10 章 | [RAG、Skill、Agent 与 Memory 连续案例](cases/rag-skill-agent-memory.md)、[教学资料库连续案例](cases/teaching-rag-skill-agent-memory.md)、[连续案例练习与复盘评分表](cases/continuous-case-exercises.md)、[AI Skill/Card 可复用模板](../examples/skill-card-template.md)、[Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md)、[图解：AI 工作系统](diagrams.md) | 能行动的系统必须有回滚和人工确认 |
| `OpenClaw` / `多 agent` / `超级大脑` | [第 10 章](chapters/10-openclaw.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 第 8-10、12 章 | [OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md)、[七层 AI 文明架构](seven-layer-ai-civilization.md)、[前沿与过时技术案例库](technology-evolution-cases.md) | 多 agent 协作要先定义任务源、状态、权限和人工闸门 |
| `代码` / `工程` / `测试` | [第 2 章](chapters/02-ai-basics.md)、[第 6-9 章](chapters/06-tools-rag.md) | 第 6-9 章 | [代码库问答连续案例](cases/codebase-rag-skill-agent-memory.md)、[工程案例](cases/engineering.md)、[图解：AI 工作系统](diagrams.md) | 不要读取秘密配置，不要盲改代码，不要让 AI 替人合并或上线 |
| `开放模型` / `前沿` / `协议` | [第 11-12 章](chapters/11-hermes-himes-open-models.md)、[前沿与过时技术案例库](technology-evolution-cases.md) | 第 11-12 章 | [资源与引用](appendix-resources.md)、[前沿资料季度复核执行手册](frontier-review-playbook.md) | 动态事实要标注核验日期 |
| `style engineering` / `风格工程` / `AI Native 创作` | [Style Engineering 与 AI Native 创作](style-engineering-ai-native.md)、[第 3 章](chapters/03-prompt-basics.md) | 第 3-4、7-9、12 章 | [Prompt 调试指南](prompt-debugging-guide.md)、[AI Skill/Card 可复用模板](../examples/skill-card-template.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 要区分稳定实践、个人风格判断和未经验证的概念 |
| `context engineering` / `上下文工程` / `上下文包` | [Context Engineering：上下文工程](context-engineering.md)、[第 6 章](chapters/06-tools-rag.md) | 第 6-9、12-13 章 | [RAG、Skill、Agent 与 Memory 连续案例](cases/rag-skill-agent-memory.md)、[术语回链索引](glossary-links.md)、[前沿资料季度复核执行手册](frontier-review-playbook.md) | 不要把“塞更多资料”误解成上下文工程；要做选择、排序、压缩、隔离和追踪 |
| `blackboard architecture` / `黑板架构` / `共享黑板` | [Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 第 8-10、12 章 | [Context Engineering：上下文工程](context-engineering.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 黑板不是聊天群，也不是把所有资料暴露给所有 agent；要做分区、锁、版本和人工裁决 |
| `event sourcing` / `事件溯源` / `任务回放` | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) | 第 8-10、12 章 | [OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)、[Context Engineering：上下文工程](context-engineering.md) | 不要为简单任务强上事件溯源；只有需要审计、回放和复盘时才值得引入 |
| `CQRS` / `读写分离` / `查询视图` | [CQRS：读写分离与多 agent 查询视图](cqrs.md)、[Event Sourcing：事件溯源与任务回放](event-sourcing.md) | 第 8-10、12 章 | [Read Model 与 Projection：读模型与投影](read-model-projections.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md)、[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) | CQRS 会增加复杂度；只有读写需求明显不同、查询视图复杂时才值得用 |
| `read model` / `projection` / `物化视图` | [Read Model 与 Projection：读模型与投影](read-model-projections.md)、[CQRS：读写分离与多 agent 查询视图](cqrs.md) | 第 8-10、12 章 | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 读模型不是事实源；投影失败后必须能重建，并处理最终一致 |
| `outbox` / `幂等消费` / `重复消息` | [Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)、[Event Sourcing：事件溯源与任务回放](event-sourcing.md) | 第 8-10、12 章 | [Read Model 与 Projection：读模型与投影](read-model-projections.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 双写和重复投递是常态，必须设计重试和去重 |
| `saga` / `process manager` / `补偿事务` | [Saga：补偿事务与流程编排](saga-process-manager.md)、[Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md) | 第 8-10、12 章 | [Event Sourcing：事件溯源与任务回放](event-sourcing.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | 不要把 Saga 当成全局回滚；补偿必须先设计 |
| `durable execution` / `持久化执行` / `长任务` | [Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md)、[Saga：补偿事务与流程编排](saga-process-manager.md) | 第 8-10、12 章 | [Transactional Outbox 与幂等消费](transactional-outbox-idempotency.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md) | 持久化执行解决流程恢复，不保证内容正确；模型输出仍要复核 |
| `observability` / `tracing` / `trace` / `OpenTelemetry` | [Observability / Tracing：智能体可观测性](observability-tracing-agent-workflows.md)、[Durable Execution：持久化执行与 agent 长任务](durable-execution-agent-workflows.md) | 第 8-10、12 章 | [Agent Trace 可观测性样例](../examples/trace-observability/index.md)、[OpenTelemetry 最小接入样例](../examples/trace-observability/otel-minimal-instrumentation.md)、[OpenTelemetry 生产化加固样例](../examples/trace-observability/otel-production-hardening.md)、[Trace Backend 选型与查询策略](../examples/trace-observability/trace-backend-selection.md)、[跨 Agent Trace Context 传播样例](../examples/trace-observability/trace-context-propagation.md)、[多语言 Trace Context 传播样例](../examples/trace-observability/trace-context-multilang.md)、[多语言 OpenTelemetry SDK 接入路线](../examples/trace-observability/trace-otel-sdk-multilang.md)、[Agent Trace 生产事故复盘长案例](cases/agent-trace-incident-retrospective.md)、[OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)、[OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) | Trace 不是事实源，不能替代 Event Sourcing；同时要做脱敏和留存策略 |
| `runtime log` / `运行日志` / `日志投影` / `回放` | [Observability / Tracing：智能体可观测性](observability-tracing-agent-workflows.md)、[多语言 Trace Context 传播样例](../examples/trace-observability/trace-context-multilang.md) | 第 8-10、12 章 | [多语言运行日志回放样例](../examples/trace-observability/trace-runtime-log-replay.md)、[多语言运行日志投影与失败回放样例](../examples/trace-observability/trace-runtime-log-projection.md)、[Agent Trace 可观测性样例](../examples/trace-observability/index.md) | 运行日志适合复盘和截图，不适合替代事实事件或原始 trace；日志投影必须保留脱敏和证据引用 |
| `AI 历史` / `公益站` / `社区生态` | [AI 发展历史与社区生态](ai-history-community-ecosystem.md)、[第 12 章](chapters/12-frontier-landscape.md) | 第 5、10-13 章 | [AI 安全事故复盘案例集](safety-incident-retrospectives.md)、[资源与引用](appendix-resources.md) | 公益站可学习，敏感数据和账号绕过不可取 |
| `文明架构` / `未来推演` / `认知经济` | [七层 AI 文明架构](seven-layer-ai-civilization.md)、[第 12 章](chapters/12-frontier-landscape.md) | 第 10-13 章 | [OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md)、[图解：AI 工作系统](diagrams.md) | 越往长期推演，越要区分事实、判断和想象 |
| `安全` / `治理` / `风险` | [第 13 章](chapters/13-safety-governance.md) | 第 13 章 | [AI 安全事故复盘案例集](safety-incident-retrospectives.md)、[团队 AI 落地手册](team-adoption-playbook.md) | 高风险任务必须保留人工责任 |
| `教学` / `学习` / `课堂` | [第 0 章](chapters/00-learning-map.md)、[教学版本材料包](teaching-kit.md) | 第 0、1、3、6-9、14 章 | [教学资料库连续案例](cases/teaching-rag-skill-agent-memory.md)、[连续案例课堂试跑版](cases/continuous-case-classroom-run.md)、[连续案例课堂投影短版](cases/continuous-case-slide-brief.md)、[连续案例样例库](cases/continuous-case-samples.md)、[分角色学习路径](learning-paths.md)、[课堂练习工作纸](classroom-worksheets.md)、[教学示范作业集](teaching-examples.md) | 学员任务要可执行，不能只讲概念 |
| `团队落地` / `试点` / `工作坊` | [团队 AI 落地完整路线图](team-ai-adoption-roadmap.md)、[30 天团队试点跟踪表](pilot-tracking-30days.md) | 第 12-14 章 | [团队 AI 落地案例集](team-adoption-cases.md)、[连续案例团队试点版](cases/continuous-case-team-pilot.md)、[连续案例样例库](cases/continuous-case-samples.md)、[AI 安全与模型选型工作坊](workshop-safety-model-selection.md)、[行业化工作坊案例集](workshop-industry-cases.md) | 先做低风险试点，再扩展 |
| `运营` / `活动` / `跨渠道` | [运营案例](cases/operations.md)、[团队 AI 落地案例集](team-adoption-cases.md) | 第 3-4、13-14 章 | [AI 工作流配方库](workflow-recipes.md)、[30 天团队试点跟踪表](pilot-tracking-30days.md) | 不要只让 AI 写文案，要检查素材、负责人、渠道指标和复盘节奏 |
| `管理` / `责任矩阵` / `试点治理` | [管理者案例](cases/management.md)、[团队 AI 落地手册](team-adoption-playbook.md) | 第 5-6、13-14 章 | [团队 AI 落地完整路线图](team-ai-adoption-roadmap.md)、[AI 安全与模型选型工作坊](workshop-safety-model-selection.md) | 不要只谈提效，要定义任务分级、复核人、最终责任人和暂停规则 |
| `职业发展` / `作品集` / `面试` / `接单` | [第 15 章](chapters/15-career-development.md)、[职业发展案例](cases/career-development.md) | 第 14-15 章 | [端到端实战项目指南](capstone-projects.md)、[附录 E：AI 求职资源大全](appendix-career-resources.md)、[社区参与与持续学习](community-continuous-learning.md) | 不要只包装简历；要保留项目证据、失败样例、评测记录和服务边界 |
| `维护` / `发布` / `自动化` / `结构审计` / `覆盖检查` | [项目维护指南](maintenance-guide.md)、[GitHub 发布指南](publishing-guide.md) | 第 0 章、附录和维护页 | [自动化维护与扩写方案](automation-content-workflow.md)、[书籍结构审计与内容健康治理](book-structure-audit.md)、[1.0 发布前总检查清单](release-checklist-1.0.md) | 自动化适合检查和候选稿，不适合无审查改正文；结构问题要同时看导航、目录和导出清单 |
| `案例` / `复盘` / `历史` | [案例索引表](cases/index.md)、[真实应用案例](case-studies.md) | 第 1-14 章 | [前沿与过时技术案例库](technology-evolution-cases.md) | 长案例可以保留，但要能复盘 |

## 按问题找

```text
我想写一个更稳定的 prompt -> 先看 第 1 章、第 3 章、Prompt 调试指南
我想知道该不该做 RAG -> 先看 第 6 章、团队 AI 落地手册、安全案例更新指南
我想把经验做成 skill -> 先看 第 7 章、AI Skill/Card 模板、教学示范作业集
我想判断要不要上 agent -> 先看 第 8 章、AI 任务选择决策指南、Agent 安全清单
我想看 RAG 到 agent 的完整演进 -> 先看 RAG/Skill/Agent/Memory 连续案例
我想把长案例转成练习和评分 -> 先看 连续案例练习与复盘评分表
我想把连续案例做成课堂 -> 先看 连续案例课堂试跑版
我想课堂投屏讲连续案例 -> 先看 连续案例课堂投影短版
我想把连续案例做成试点 -> 先看 连续案例团队试点版
我想看连续案例成品样例 -> 先看 连续案例样例库
我想理解 Style Engineering -> 先看 Style Engineering 与 AI Native 创作
我想让 AI 看到正确资料 -> 先看 Context Engineering：上下文工程
我想让多个 agent 共享任务现场 -> 先看 Blackboard Architecture：黑板架构与多 agent 协作
我想回放 agent 任务过程 -> 先看 Event Sourcing：事件溯源与任务回放
我想让 agent 状态好查 -> 先看 CQRS：读写分离与多 agent 查询视图
我想把事件流变成 SQLite 看板 -> 先看 Read Model 与 Projection：读模型与投影
我想可靠发事件并避免重复处理 -> 先看 Transactional Outbox 与幂等消费
我想编排长任务并准备补偿 -> 先看 Saga：补偿事务与流程编排
我想让 agent 长任务跨重启继续 -> 先看 Durable Execution：持久化执行与 agent 长任务
我想排查 agent 为什么慢、贵、失败或误判 -> 先看 Observability / Tracing：智能体可观测性
我想把 trace 接到 OpenTelemetry -> 先看 OpenTelemetry 最小接入样例
我想把 OpenTelemetry 用到团队生产环境 -> 先看 OpenTelemetry 生产化加固样例
我想选择 trace 后端和查询方式 -> 先看 Trace Backend 选型与查询策略
我想让多个 agent 保持同一条 trace -> 先看 跨 Agent Trace Context 传播样例
我想让 Python、Node.js 和 CLI adapter 保持同一条 trace -> 先看 多语言 Trace Context 传播样例
我想从手写 traceparent 迁移到 SDK -> 先看 多语言 OpenTelemetry SDK 接入路线
我想把运行过程整理成人能读的日志 -> 先看 多语言运行日志回放样例
我想把运行日志接到看板或失败队列 -> 先看 多语言运行日志投影与失败回放样例
我想看一次 trace 事故复盘 -> 先看 Agent Trace 生产事故复盘长案例
我想了解 AI 公益站和注册自动化风险 -> 先看 AI 发展历史与社区生态
我想看七层 AI 文明架构 -> 先看 七层 AI 文明架构
我想做 OpenClaw 多 agent 联动 -> 先看 OpenClaw 多 agent 联动教程
我想评估 Node.js、CLI 和超级大脑系统 -> 先看 OpenClaw、Node.js 与超级大脑架构
我想把教学资料做成助教助手 -> 先看 教学资料库连续案例、教学版本材料包
我想做代码库问答和修复助手 -> 先看 代码库问答连续案例、工程案例
我想做模型选型 -> 先看 第 5 章、模型特色概览、模型选型案例
我想做教学或培训 -> 先看 第 0 章、教学版本材料包、课堂练习工作纸
我想带团队试点 -> 先看 团队路线图、30 天试点跟踪表、团队案例集
我想找 AI 相关工作或接单 -> 先看 第 15 章、职业发展案例、端到端实战项目指南、AI 求职资源大全
我想检查安全边界 -> 先看 第 13 章、安全案例更新指南、事故复盘案例集
我想找案例 -> 先看 案例索引表、真实应用案例、前沿与过时技术案例库
我想做发布维护 -> 先看 维护指南、发布指南、自动化维护与扩写方案、书籍结构审计与内容健康治理
```

## 使用建议

- 先从你现在最接近的问题开始，不要从最宏大的概念开始。
- 主题索引只是入口，不是结论。
- 进入对应页面后，再回到章节、案例和练习材料。
- 动态事实仍要回到 `docs/appendix-resources.md` 和前沿复核流程核验。
