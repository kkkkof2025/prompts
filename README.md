# AI 学习方法全景书

这是一本面向普通学习者、创作者、产品经理、工程师和组织管理者的中文 AI 学习方法开源书。它从最基本的对话开始，逐步进入 prompt、结构化工作流、skills、agent、记忆系统、OpenClaw、Hermes/HiMeS、MCP/A2A，以及截至 2026-05-07 的 AI 技术发展全景。

本项目采用 Markdown 写作，并使用 MkDocs Material 作为唯一在线阅读版式。站点首页、书稿章节、`examples/` 实践模板和维护材料都会被 MkDocs 纳入同一个 GitHub Pages 站点；根目录 `README.md` 保留为 GitHub 仓库说明。

## 读者路线

- 没有基础：从 [第 0 章](docs/chapters/00-learning-map.md) 到 [第 4 章](docs/chapters/04-prompt-workflows.md)，先学会与 AI 稳定协作。
- 想提高工作效率：重点读 [第 5 章](docs/chapters/05-evaluation.md)、[第 6 章](docs/chapters/06-tools-rag.md)、[第 7 章](docs/chapters/07-skills.md)。
- 想理解 AI agent：重点读 [第 8 章](docs/chapters/08-agents.md)、[第 9 章](docs/chapters/09-memory.md)、[第 10 章](docs/chapters/10-openclaw.md)。
- 想跟进前沿：重点读 [第 11 章](docs/chapters/11-hermes-himes-open-models.md)、[第 12 章](docs/chapters/12-frontier-landscape.md)、[Style Engineering 与 AI Native 创作](docs/style-engineering-ai-native.md)、[Context Engineering：上下文工程](docs/context-engineering.md)、[Blackboard Architecture：黑板架构与多 agent 协作](docs/blackboard-architecture-multi-agent.md)、[Event Sourcing：事件溯源与任务回放](docs/event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](docs/cqrs.md)、[Read Model 与 Projection：读模型与投影](docs/read-model-projections.md)、[Transactional Outbox 与幂等消费](docs/transactional-outbox-idempotency.md)、[Saga：补偿事务与流程编排](docs/saga-process-manager.md)、[Durable Execution：持久化执行与 agent 长任务](docs/durable-execution-agent-workflows.md)、[Observability / Tracing：智能体可观测性](docs/observability-tracing-agent-workflows.md)、[AI 发展历史与社区生态](docs/ai-history-community-ecosystem.md)、[七层 AI 文明架构](docs/seven-layer-ai-civilization.md)、[中外 AI 模型特色概览](docs/model-landscape-china-global.md)、[AI 模型选型实战案例集](docs/model-selection-cases.md)、[前沿与过时技术案例库](docs/technology-evolution-cases.md)、[资源与引用](docs/appendix-resources.md) 和 [前沿资料季度复核记录表](docs/frontier-review-log.md)。
- 想研究 OpenClaw 和超级系统：读 [OpenClaw 多 agent 联动教程](docs/openclaw-multi-agent-linkage.md) 和 [OpenClaw、Node.js 与超级大脑架构](docs/openclaw-superbrain-architecture.md)。
- 想直接套用：读 [AI 任务选择决策指南](docs/task-decision-guide.md)、[AI 安全案例更新指南](docs/safety-case-updates.md)、[AI 安全事故复盘案例集](docs/safety-incident-retrospectives.md)、[真实应用案例](docs/case-studies.md)、[常用检查清单](docs/appendix-checklists.md) 和 `examples/` 模板。
- 想组织学习：读 [分角色学习路径](docs/learning-paths.md)、[读书会与教学方案](docs/facilitation-guide.md)、[教学版本材料包](docs/teaching-kit.md)、[连续案例练习与复盘评分表](docs/cases/continuous-case-exercises.md)、[连续案例课堂试跑版](docs/cases/continuous-case-classroom-run.md)、[连续案例课堂投影短版](docs/cases/continuous-case-slide-brief.md)、[连续案例团队试点版](docs/cases/continuous-case-team-pilot.md)、[连续案例样例库](docs/cases/continuous-case-samples.md)、[团队 AI 落地完整路线图](docs/team-ai-adoption-roadmap.md)、[AI 安全与模型选型工作坊](docs/workshop-safety-model-selection.md)、[行业化工作坊案例集](docs/workshop-industry-cases.md)、[30 天团队试点跟踪表](docs/pilot-tracking-30days.md)、[课堂练习工作纸](docs/classroom-worksheets.md)、[教学示范作业集](docs/teaching-examples.md)、[试读与试跑反馈包](docs/feedback-validation-kit.md)、[团队 AI 落地手册](docs/team-adoption-playbook.md) 和 [团队 AI 落地案例集](docs/team-adoption-cases.md)。
- 想快速复习：读 [AI 学习与使用速查讲义](docs/quick-reference.md)、[学习进度清单](docs/learning-progress.md)、[术语回链索引](docs/glossary-links.md)、[常见误区与纠偏指南](docs/common-pitfalls.md)、[Prompt 调试指南](docs/prompt-debugging-guide.md) 和 [章节复盘题与小测](docs/chapter-review-questions.md)。
- 想直接落地：读 [团队 AI 落地完整路线图](docs/team-ai-adoption-roadmap.md)、[AI 任务选择决策指南](docs/task-decision-guide.md)、[AI 工作流配方库](docs/workflow-recipes.md)、[团队 AI 落地手册](docs/team-adoption-playbook.md)、[团队 AI 落地案例集](docs/team-adoption-cases.md) 和 [AI 能力评估量表](docs/assessment-rubric.md)。
- 想发布维护：读 [章节练习与验收映射表](docs/chapter-validation-map.md)、[试读与试跑反馈包](docs/feedback-validation-kit.md)、[前沿资料季度复核执行手册](docs/frontier-review-playbook.md)、[前沿资料季度复核记录表](docs/frontier-review-log.md)、[自动化维护与扩写方案](docs/automation-content-workflow.md)、[1.0 发布前总检查清单](docs/release-checklist-1.0.md)、[项目维护指南](docs/maintenance-guide.md)、[GitHub 发布指南](docs/publishing-guide.md) 和 [电子书与离线阅读指南](docs/ebook-guide.md)。

## 项目结构

```text
.
├── README.md                 # 项目总说明
├── MEMORY.md                 # 进度记忆与后续维护记录
├── CHANGELOG.md              # 版本变更记录
├── LICENSE.md                # CC BY-SA 4.0 许可证说明
├── CONTRIBUTING.md           # 贡献指南
├── mkdocs.yml                # MkDocs 站点配置
├── requirements-docs.txt     # MkDocs 构建依赖
├── agents/
│   └── index.md              # agent 协作约定和本次使用记录
├── .github/
│   ├── ISSUE_TEMPLATE/       # GitHub Issue 模板
│   ├── workflows/            # Markdown 检查、内容健康报告、MkDocs Pages 和定期外链检查
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── index.md              # 书稿首页
│   ├── SUMMARY.md            # 全书目录
│   ├── stylesheets/          # MkDocs 自定义样式
│   ├── chapters/             # 书稿章节
│   ├── cases/                # 分角色应用案例
│   └── appendix-resources.md # 资源、引用、版本核验清单
├── scripts/                  # 本地检查和电子书导出脚本
└── examples/                 # 可复制的 prompt、skill、agent 模板
```

## 发布到 GitHub Pages

1. 把项目推送到 GitHub。
2. 在仓库设置中打开 Pages。
3. Source 选择 `GitHub Actions`。
4. 推送到当前发布分支后等待 `MkDocs Pages` workflow 构建和部署；本仓库当前使用 `master`。
5. 访问 `https://你的用户名.github.io/你的仓库名/`。

## 写作原则

- 由浅入深：每章都先讲问题，再讲方法，最后给实践。
- 面向真实使用：每个概念尽量给可复制模板或检查清单。
- 不追单一厂商：同时覆盖闭源模型、开源模型、本地模型、agent 协议和安全治理。
- 可维护：快速变化的事实集中放入 [资源与引用](docs/appendix-resources.md)，并在 [MEMORY.md](MEMORY.md) 记录核验日期。

## 实践模板

- [Prompt 模式实践模板](examples/prompt-patterns.md)
- [AI Skill/Card 可复用模板](examples/skill-card-template.md)
- [Agent 工作流安全检查清单](examples/agent-workflow-checklist.md)
- [真实应用案例](docs/case-studies.md)
- [案例索引表](docs/cases/index.md)
- [主题索引](docs/topic-index.md)
- [RAG、Skill、Agent 与 Memory 连续案例](docs/cases/rag-skill-agent-memory.md)
- [教学资料库连续案例](docs/cases/teaching-rag-skill-agent-memory.md)
- [代码库问答连续案例](docs/cases/codebase-rag-skill-agent-memory.md)
- [Agent Trace 生产事故复盘长案例](docs/cases/agent-trace-incident-retrospective.md)
- [连续案例练习与复盘评分表](docs/cases/continuous-case-exercises.md)
- [连续案例课堂试跑版](docs/cases/continuous-case-classroom-run.md)
- [连续案例团队试点版](docs/cases/continuous-case-team-pilot.md)
- [连续案例样例库](docs/cases/continuous-case-samples.md)（含客户反馈、教学资料库、代码库三组质量层级对照）
- [连续案例课堂投影短版](docs/cases/continuous-case-slide-brief.md)
- [学习进度清单](docs/learning-progress.md)
- [术语回链索引](docs/glossary-links.md)
- [学生案例](docs/cases/student.md)
- [教师案例](docs/cases/teacher.md)
- [运营案例](docs/cases/operations.md)
- [产品案例](docs/cases/product.md)
- [工程案例](docs/cases/engineering.md)
- [管理者案例](docs/cases/management.md)
- [术语表](docs/appendix-glossary.md)
- [术语写法规范](docs/term-style-guide.md)
- [练习参考答案](docs/appendix-exercise-answers.md)
- [常用检查清单](docs/appendix-checklists.md)
- [分角色学习路径](docs/learning-paths.md)
- [读书会与教学方案](docs/facilitation-guide.md)
- [教学版本材料包](docs/teaching-kit.md)
- [团队 AI 落地完整路线图](docs/team-ai-adoption-roadmap.md)
- [AI 安全与模型选型工作坊](docs/workshop-safety-model-selection.md)
- [行业化工作坊案例集](docs/workshop-industry-cases.md)
- [30 天团队试点跟踪表](docs/pilot-tracking-30days.md)
- [课堂练习工作纸](docs/classroom-worksheets.md)
- [教学示范作业集](docs/teaching-examples.md)
- [试读与试跑反馈包](docs/feedback-validation-kit.md)
- [AI 工作系统图解](docs/diagrams.md)
- [任务事件日志样例](examples/event-log/index.md)
- [Agent Trace 可观测性样例](examples/trace-observability/index.md)
- [OpenTelemetry 最小接入样例](examples/trace-observability/otel-minimal-instrumentation.md)
- [OpenTelemetry 生产化加固样例](examples/trace-observability/otel-production-hardening.md)
- [跨 Agent Trace Context 传播样例](examples/trace-observability/trace-context-propagation.md)
- [章节复盘题与小测](docs/chapter-review-questions.md)
- [章节练习与验收映射表](docs/chapter-validation-map.md)
- [AI 学习与使用速查讲义](docs/quick-reference.md)
- [常见误区与纠偏指南](docs/common-pitfalls.md)
- [Prompt 调试指南](docs/prompt-debugging-guide.md)
- [AI 任务选择决策指南](docs/task-decision-guide.md)
- [AI 安全案例更新指南](docs/safety-case-updates.md)
- [AI 安全事故复盘案例集](docs/safety-incident-retrospectives.md)
- [中外 AI 模型特色概览](docs/model-landscape-china-global.md)
- [AI 模型选型实战案例集](docs/model-selection-cases.md)
- [前沿与过时技术案例库](docs/technology-evolution-cases.md)
- [Style Engineering 与 AI Native 创作](docs/style-engineering-ai-native.md)
- [Context Engineering：上下文工程](docs/context-engineering.md)
- [Blackboard Architecture：黑板架构与多 agent 协作](docs/blackboard-architecture-multi-agent.md)
- [Event Sourcing：事件溯源与任务回放](docs/event-sourcing.md)
- [CQRS：读写分离与多 agent 查询视图](docs/cqrs.md)
- [Read Model 与 Projection：读模型与投影](docs/read-model-projections.md)
- [Transactional Outbox 与幂等消费](docs/transactional-outbox-idempotency.md)
- [Saga：补偿事务与流程编排](docs/saga-process-manager.md)
- [Durable Execution：持久化执行与 agent 长任务](docs/durable-execution-agent-workflows.md)
- [Observability / Tracing：智能体可观测性](docs/observability-tracing-agent-workflows.md)
- [AI 发展历史与社区生态](docs/ai-history-community-ecosystem.md)
- [七层 AI 文明架构](docs/seven-layer-ai-civilization.md)
- [OpenClaw 多 agent 联动教程](docs/openclaw-multi-agent-linkage.md)
- [OpenClaw、Node.js 与超级大脑架构](docs/openclaw-superbrain-architecture.md)
- [AI 工作流配方库](docs/workflow-recipes.md)
- [团队 AI 落地手册](docs/team-adoption-playbook.md)
- [团队 AI 落地案例集](docs/team-adoption-cases.md)
- [AI 能力评估量表](docs/assessment-rubric.md)
- [前沿资料季度复核执行手册](docs/frontier-review-playbook.md)
- [前沿资料季度复核记录表](docs/frontier-review-log.md)
- [自动化维护与扩写方案](docs/automation-content-workflow.md)
- [电子书与离线阅读指南](docs/ebook-guide.md)
- [1.0 发布前总检查清单](docs/release-checklist-1.0.md)

## 参与贡献

贡献方式见 [CONTRIBUTING.md](CONTRIBUTING.md)。项目采用 [CC BY-SA 4.0](LICENSE.md) 许可证。

## 维护与发布

- [GitHub 发布指南](docs/publishing-guide.md)
- [项目维护指南](docs/maintenance-guide.md)
- [自动化维护与扩写方案](docs/automation-content-workflow.md)
- [前沿资料季度复核执行手册](docs/frontier-review-playbook.md)
- [1.0 发布前总检查清单](docs/release-checklist-1.0.md)
- [变更记录](CHANGELOG.md)
- [项目路线图](ROADMAP.md)
- 自动化检查脚本：[scripts/check-markdown-links.ps1](scripts/check-markdown-links.ps1)
- 内容健康报告脚本：[scripts/content-health-report.ps1](scripts/content-health-report.ps1)
- 术语一致性脚本：[scripts/check-terminology.ps1](scripts/check-terminology.ps1)
- 外部链接检查脚本：[scripts/check-external-links.ps1](scripts/check-external-links.ps1)
- 电子书导出脚本：[scripts/export-ebook.ps1](scripts/export-ebook.ps1)

## 当前状态

初版书稿已扩展到 0.7 草案。案例已按角色拆分，教学版本材料包、团队 AI 落地完整路线图、AI 安全与模型选型工作坊、行业化工作坊案例集、30 天团队试点跟踪表、课堂练习工作纸、教学示范作业集、试读与试跑反馈包、章节练习与验收映射表、学习进度清单、案例索引表、主题索引、术语回链索引、RAG/skill/agent/memory 连续案例、教学资料库连续案例、代码库问答连续案例、Agent Trace 生产事故复盘长案例、连续案例练习与复盘评分表、连续案例课堂试跑版、连续案例课堂投影短版、连续案例团队试点版、连续案例样例库（含客户反馈、教学资料库、代码库三组质量层级对照）、Style Engineering 与 AI Native 创作、Context Engineering、Blackboard Architecture、Event Sourcing、CQRS、Read Model 与 Projection、Transactional Outbox 与幂等消费、Saga：补偿事务与流程编排、Durable Execution：持久化执行与 agent 长任务、Observability / Tracing：智能体可观测性、Agent Trace 可观测性样例、OpenTelemetry 最小接入样例、OpenTelemetry 生产化加固样例、跨 Agent Trace Context 传播样例、AI 发展历史与社区生态、七层 AI 文明架构、OpenClaw 多 agent 联动教程、OpenClaw/Node.js/超级大脑架构、前沿资料季度复核执行手册、前沿资料季度复核记录表及示例、常见误区纠偏材料、Prompt 调试指南、任务选择指南、安全案例更新指南、安全事故复盘案例集、中外模型特色概览、模型选型实战案例集、前沿与过时技术案例库、自动化维护与扩写方案、团队 AI 落地手册、团队落地案例集和 1.0 发布前总检查清单已补齐。在线阅读版已统一为 MkDocs Material，已启用全书左侧导航树、站内搜索、章节导读、章节收尾、章节上一章/下一章导航、代码复制和页面编辑入口；Markdown lint、术语一致性、MkDocs Pages、外部链接定期检查和内容健康报告已纳入自动化。
