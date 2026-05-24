# Changelog

所有重要变更记录在这里。日期使用 `YYYY-MM-DD`。

## Unreleased

- 新增 **AI 短剧制作全流程实战**（`docs/cases/ai-short-drama-production.md`）：从创意提案→剧本分镜→资产生产→视频生成→后期发布的完整单人工作室流水线，含五大环节工具链、时间成本演进和 AI 思维模型映射。
- 新增 **原生多角色模拟**（`docs/native-multi-role-simulation.md`）：不依赖任何平台的纯 Prompt 多 Agent 协作方法，三层递进（单次多角色→对话模拟→带工具分工），含防串台技巧和质量控制。
- 新增 **第 15 章：AI 职业发展全景** (`docs/chapters/15-career-development.md`)，覆盖热门职位地图、技能对照表、薪资参考、作品集指南、面试准备和职业转型路径。
- 新增 **端到端实战项目指南** (`docs/capstone-projects.md`)，包含个人学习助手、自动化工作报告生成器、智能客服Bot三个完整项目。
- 增强 **第 1 章**：新增"手把手实战演练"节，展示完整的"失败→分析→修正→验收"循环。
- 新增 **AI 模型成本计算与选型实战** (`docs/model-cost-calculator.md`)，包含价格对比、成本计算工具、分层路由策略和硬件成本参考。
- 新增 **社区参与与持续学习** (`docs/community-continuous-learning.md`)，包含信息获取系统、开源贡献路径、个人品牌建设和月度/季度学习节奏。
- 新增 **附录 E：AI 求职资源大全** (`docs/appendix-career-resources.md`)，包含招聘渠道、简历优化、推荐项目、关注列表和常见问题。
- 新增 **Prompt Injection 防护实战** (`docs/prompt-injection-defense.md`)，包含5种攻击类型、6层防护体系、测试集和企业级安全清单。
- 新增 **职业转型案例：四种 AI 转型路径** (`docs/cases/career-transition-cases.md`)，包含运营→AI产品、电工→AI培训师、开发→AI工程师、全职妈妈→Freelancer四种真实转型路径。
- 新增 **章节分级练习（0-15章）** (`docs/chapter-graded-exercises.md`)，覆盖全书16章，每章⭐/⭐⭐/⭐⭐⭐三级难度，自学和教学两用。
- 新增 **分角色快速上手指南** (`docs/role-based-quickstart.md`)，为学生、职场、开发者、PM、安全、Freelancer、管理者提供定制化学习路线。
- 新增 **Prompt 优化与成本节约** (`docs/prompt-optimization-savings.md`)，包含瘦身技巧、System Prompt管理、对话历史管理、缓存策略和路由省钱方案。
- 新增 **AI 第一天：零基础上手指南** (`docs/first-day-with-ai.md`)，5分钟读完即可开始跟AI对话的打印级上手指南。
- 新增 **Prompt 模板库** (`examples/prompt-templates.md`)，包含工作、写作、学习、代码、分析5大类可直接复制使用的模板。
- 新增 **AI API 集成模式实战** (`docs/api-integration-patterns.md`)，覆盖同步/异步/流式调用、Token预算控制、结果验证、Fallback链、缓存层和安全过滤。
- 新增 **AI 数据准备实战指南** (`docs/data-preparation-guide.md`)，覆盖格式清洗、结构化输入、RAG文档准备、常见失败模式和AI互助清洗。
- 新增 **何时不用 AI** (`docs/when-not-to-use-ai.md`)，覆盖AI边界、决策树、隐性成本和替代方案对照表。
- 新增 **30 天 AI 实践跟踪表** (`docs/30day-tracking-sheet.md`)，可打印的每日记录和周复盘模板。
- 增强 **第 13 章**：新增Agent权限分级(L0-L3)、企业三阶段落地、安全事故响应流程和季度安全审计自检。
- 增强 **第 5 章**：新增评测集建立五步实战、双模型横向对比评分表、评测集维护节奏。
- 增强 **第 14 章**：新增每日期望产出表（30天×用时）、分角色跳过建议、卡住对策表。
- 增强 **第 2 章**：新增模型通俗类比（"读过几十亿页书的人"）、中英文Token对比表、幻觉具体案例。
- 增强 **第 3 章**：新增同一Prompt结构跨角色对比表（产品/开发/运营/管理者）。
- 增强 **第 6 章**：新增RAG前后对比实例、从零建RAG五步实战。
- 增强 **第 8 章**：新增Agent完整执行Trace（成功+失败对比）、Agent权限分级(L0-L3)。
- 增强 **第 4 章**：新增周报工作流三阶段演变（混乱→固定→完整）、跨角色工作流对比表。
- 增强 **第 7 章**：新增Skill测试四步法、填空式Skill模板。
- 增强 **第 9 章**：新增"记忆腐烂"实例、记忆维护节奏表。
- 增强 **第 10 章**：新增"AI助手的一天"时序实战、搭建助手四步决策。
- 增强 **第 11 章**：新增5分钟本地部署指南(Ollama)、开源vs云端决策矩阵。
- 增强 **第 12 章**：新增九大趋势行动映射表、2026年AI炒作vs实质评估表。
- 新增 **本书阅读指南**（`docs/how-to-read-this-book.md`）：按开发者/产品经理/写作者/管理者/学生五种角色提供阅读路径、三种阅读策略（极速/系统/深度）。
- 更新 **ROADMAP.md**：版本号从 0.7 → 0.9 内测，标注 1.0 收尾阶段。
- 新增 **AI Prompt 即用库**（`docs/prompt-templates-library.md`）：30个即抄即用的prompt模板，覆盖写作/编程/分析/学习/工作/创作6大类。
- 增强 **速查讲义**（`docs/quick-reference.md`）：新增模型选型速查+常见AI失败修复。
- 增强 **附录D 检查清单**（`docs/appendix-checklists.md`）：新增模型选型检查清单+AI项目启动检查清单。
- 所有新页面已接入 `mkdocs.yml` 导航、`docs/SUMMARY.md` 完整目录和 `scripts/export-ebook.ps1` 电子书导出清单。
- 更新 `README.md` 读者路线，覆盖新增章节。

---

## 0.7 教学版本材料包

包含周课件大纲、讲师提示词、课堂练习、作业和结业项目模板。

- 增加 `docs/classroom-worksheets.md` 课堂练习工作纸，提供 10 张可发给学员填写的表单。
- 增加 `docs/teaching-examples.md` 教学示范作业集，覆盖匿名化 prompt、工作流、skill、agent、安全规范和结业项目样例。
- 增加 `docs/feedback-validation-kit.md` 试读与试跑反馈包，覆盖个人试读、课堂试跑、团队试点、观察记录、评分量表和匿名化反馈记录。
- 增加 `docs/chapter-validation-map.md` 章节练习与验收映射表，逐章对应核心能力、练习任务、复盘证据和配套材料。
- 增加 `docs/frontier-review-log.md` 前沿资料季度复核记录表，用于记录模型、协议、工具和安全资料的复核证据、影响范围和处理动作。
- 增加 `docs/common-pitfalls.md` 常见误区与纠偏指南，覆盖 12 类高频错误和可复制改写方式。
- 增加 `docs/prompt-debugging-guide.md` Prompt 调试指南，覆盖输出失败诊断、调试流程、失败类型和调试记录模板。
- 增加 `docs/task-decision-guide.md` AI 任务选择决策指南，帮助读者在普通对话、prompt、工作流、skill、RAG、工具调用和 agent 之间选择。
- 增加 `docs/safety-case-updates.md` AI 安全案例更新指南，用新版案例覆盖间接 prompt 注入、RAG、agent 权限、长期记忆、多模态和供应链风险。
- 增加 `docs/safety-incident-retrospectives.md` AI 安全事故复盘案例集，覆盖知识库越权、会议纪要泄露、agent 误发邮件、代码依赖、多模态隐私和模型升级事故。
- 增加 `docs/model-landscape-china-global.md` 中外 AI 模型特色概览，按路线、生态、选型维度介绍中国和国际模型。
- 增加 `docs/model-selection-cases.md` AI 模型选型实战案例集，覆盖中文写作、内部知识库、代码助手、客服分类、长合同、本地部署和多模态文档处理。
- 增加 `docs/technology-evolution-cases.md` 前沿与过时技术案例库，覆盖插件式工具接入、早期自主 agent、RAG、长上下文、skills、MCP、A2A、个人助手工作台、开放模型、长期记忆和 computer use 等演进案例。
- 增加 `docs/automation-content-workflow.md` 自动化维护与扩写方案，说明 GitHub Actions 适合做扫描、候选稿和 draft PR，不适合无审查地直接替代人工定稿。
- 增加 `docs/read-model-projections.md` Read Model 与 Projection 专题，把 CQRS 的查询侧落到 SQLite 读模型、投影刷新、最终一致和重建策略。
- 增加 `docs/transactional-outbox-idempotency.md` Transactional Outbox 与幂等消费专题，把多 agent 事件同步的可靠发放、重试和去重纳入前沿架构说明。
- 增加 `docs/saga-process-manager.md` Saga / Process Manager 专题，把多 agent 长流程的补偿事务与编排模式纳入前沿架构说明。
- 增加 `docs/durable-execution-agent-workflows.md` Durable Execution 专题，把 agent 长任务的持久化执行、恢复、定时器和人工等待纳入前沿架构说明。
- 增加 `docs/observability-tracing-agent-workflows.md` Observability / Tracing 专题，把 agent 运行追踪、trace、span、日志、指标、成本和证据链纳入前沿架构说明。
- 增加 `examples/trace-observability/` Agent Trace 可观测性样例，提供 trace JSONL、SQLite schema 和回放脚本 `scripts/replay-agent-traces.ps1`。
- 增加 `scripts/load-agent-traces-sqlite.py`，把 Agent Trace JSONL 导入 SQLite，并从 `trace_summary`、`actor_cost`、`failure_queue` 和 `longest_spans` 视图读回看板 JSON。
- 增加 `examples/trace-observability/otel-minimal-instrumentation.md` 和 `otel_agent_trace_minimal.py`，演示如何把 agent trace 接入 OpenTelemetry Python SDK、Console exporter、OTLP exporter 和 Collector 调试路径。
- 增加 `examples/trace-observability/otel-production-hardening.md` 和 `otel-collector-agent-traces.yaml`，补充 agent trace 的采样、脱敏、Collector 管道、tail sampling、redaction 和事故复盘模板。
- 增加 `examples/trace-observability/trace-backend-selection.md`，补充 JSONL/SQLite、Jaeger、Grafana Tempo 和托管平台之间的 trace backend 选型与查询策略。
- 增加 `examples/trace-observability/trace-context-propagation.md` 和 `trace_context_bridge.py`，演示跨 agent handoff 时如何传播 W3C `traceparent`。
- 增加 `examples/trace-observability/trace-context-multilang.md` 和 `trace_context_bridge_node.js`，演示 Python agent 到 Node.js / CLI adapter 的多语言 trace context 传播和父子 span 校验。
- 增加 `examples/trace-observability/trace-runtime-log-replay.md` 和 `trace_runtime_log_bridge.py`，把 Python 与 Node.js bridge 输出合并成可读 runtime log，用于教学、排障和复盘。
- 增加 `examples/trace-observability/trace-runtime-log-projection.md` 和 `trace_runtime_log_projection.py`，把 runtime log 投影成 summary、可搜索索引和失败队列，并补充 broken handoff 失败回放。
- 增加 `examples/trace-observability/trace-otel-sdk-multilang.md`，补充从手写 `traceparent` 迁移到 OpenTelemetry Python / JavaScript SDK `inject` / `extract` 的多语言路线。
- 增加 `docs/book-structure-audit.md` 书籍结构审计与内容健康治理页，记录导航、目录、导出清单、短页、重复主题和下一轮扩写优先级。
- 扩充 `examples/event-log/index.md`，补充任务事件 schema、事件类型、读模型、失败样例、业务事件与 trace/runtime log 的区别，以及 CloudEvents 参考边界。
- 更新 `scripts/content-health-report.ps1`，改用 CJK 字符 + 英文/数字词估算内容量，排除 `.github/`、`.workbuddy/`、构建输出和临时目录，并把封面、版权、许可证、贡献指南和 agent 协作记录列为刻意短页。
- 更新 `scripts/export-ebook.ps1`，补齐完整目录、发布/维护指南、结构审计页、基础实践模板、项目维护根文档和 agent 协作记录，减少离线版遗漏。
- 增加 `scripts/check-content-coverage.ps1` 内容覆盖检查脚本，并接入 `Markdown Check` workflow，用于比较 MkDocs 导航、完整目录和电子书导出清单是否遗漏书稿页面。
- 扩充 `docs/cases/engineering.md` 和 `docs/cases/product.md`，新增工程发布风险审查案例和 AI 功能最小实验案例。
- 扩充 `docs/cases/operations.md` 和 `docs/cases/management.md`，新增跨渠道活动执行检查案例和 AI 试点责任矩阵案例。
- 更新本地链接、术语和内容健康脚本，使其在 Git 仓库内默认检查已跟踪 Markdown，避免本地未跟踪草稿干扰发布检查。
- 增加 `docs/cases/agent-trace-incident-retrospective.md` Agent Trace 生产事故复盘长案例，把 trace 断裂、安全复核失败、事件日志、补偿动作和人工审批串成复盘流程。
- 将 GitHub Pages 在线阅读版统一为 MkDocs Material，增加 `mkdocs.yml`、阅读样式、依赖文件和 `mkdocs-pages.yml` 发布 workflow。
- 将章节页补齐上一章/下一章导航，并把 `agents/README.md` 改为 `agents/index.md`，避免与站点首页冲突。
- 将 MkDocs 构建输出改到仓库外目录，清理了站点构建警告。
- 增强 MkDocs Material 阅读体验，启用顶部导航标签、搜索分享、即时加载、代码复制、页面编辑入口和源码查看入口。
- 为根目录首页和书稿首页增加“全书内容地图”，并在路线图中补充阅读站后续功能池。
- 为第 0-14 章统一补充“本章导读”，包含预计阅读时间、学习目标、练习入口和相关材料入口。
- 为第 0-14 章统一补充“本章收尾”，在章节导航前提供本章练习、相关案例和下一步入口。
- 为案例页补充“案例索引表”，按角色、主题、风险和章节对应关系快速定位案例。
- 增加 `docs/topic-index.md` 主题索引，按 prompt、RAG、agent、安全、教学、团队落地等主题串联章节、案例和材料。
- 增加 `docs/glossary-links.md` 术语回链索引，把核心术语连接到定义、章节、案例、材料和常见误解。
- 增加 `docs/learning-progress.md` 学习进度清单，按章节记录阅读、练习、案例复盘和 30 天推进节奏。
- 增加 `docs/cases/rag-skill-agent-memory.md` 长案例，把客户反馈知识库从普通 prompt 演进到 RAG、skill、受控 agent 和 memory 边界。
- 增加 `docs/cases/teaching-rag-skill-agent-memory.md` 长案例，把教学资料库从普通 prompt 演进到教学 RAG、feedback skill、受控助教 agent 和 memory 边界。
- 增加 `docs/cases/codebase-rag-skill-agent-memory.md` 长案例，把工程代码库从普通 prompt 演进到代码库 RAG、bug triage skill、受控修复 agent 和 repo memory 边界。
- 增加 `docs/cases/continuous-case-exercises.md` 连续案例练习与复盘评分表，把三条长案例转成课前阅读、分组讨论、实操改写、rubric 评分和团队试点复盘材料。
- 增加 `docs/cases/continuous-case-classroom-run.md` 连续案例课堂试跑版，把长案例转成 90/120 分钟课堂脚本、示范样例、讲师追问清单和观察记录模板。
- 增加 `docs/cases/continuous-case-slide-brief.md` 连续案例课堂投影短版，提供 12 个投影页、讲师提示、互动问题、开场词和收尾词。
- 增加 `docs/cases/continuous-case-team-pilot.md` 连续案例团队试点版，把长案例转成 7 天最小试点、30 天衔接、试点任务卡、日志模板和写回规则。
- 增加 `docs/cases/continuous-case-samples.md` 连续案例样例库，提供匿名化作业、课堂观察记录、7 天团队试点复盘样例，并为客户反馈、教学资料库和代码库三条主线补充质量层级对照。
- 增加 `docs/seven-layer-ai-civilization.md` 七层 AI 文明架构，把执行、记忆、意图、认知经济、世界模型、身份和文明展开成前沿系统框架，并补充七层之外的技术推演。
- 增加 `docs/openclaw-multi-agent-linkage.md` OpenClaw 多 agent 联动教程，覆盖飞书、Telegram、云文档、任务状态、统一 skill 安装、回写和人工审批。
- 增加 `docs/openclaw-superbrain-architecture.md` OpenClaw、Node.js 与超级大脑架构分析，比较 Node.js、Python、Go、Rust、Markdown 与流式中间层，并提出更强认知系统设计。
- 增强 MkDocs 导航，新增 `OpenClaw 与前沿架构` 导航分组，移除顶部 tabs 模式，并改为左侧全书导航树；导航分组保持可展开和收起，搜索索引由 MkDocs Material 生成。
- 修复 GitHub Actions 触发分支，`MkDocs Pages` 和 `Markdown Check` 同时监听 `master` 与 `main`，避免本仓库推送到 `master` 后 Pages 不更新。
- 修正 GitHub Pages 发布源，切换为 GitHub Actions 构建的 MkDocs 产物，避免 Pages 继续用 Jekyll 从 `master` 根目录发布旧版页面。
- 修复 MkDocs Material 资源文件 404：从 `exclude_docs` 移除 `assets/`，确保主题 CSS、JS、字体和搜索 worker 正常发布。
- 扩充七层 AI 文明架构，补充个人、团队、组织三种落地视角、七层之外的十条能力轴和判断公式。
- 扩充 OpenClaw 多 agent 联动教程，新增三种部署层级、飞书 + Telegram + 云文档 + OpenClaw 完整案例、状态机和优先级建议。
- 扩充 OpenClaw 超级大脑架构，新增全 Markdown 的性能瓶颈、v0.1 模块清单、事件格式和自我优化阶段。
- 新增 `docs/style-engineering-ai-native.md`，把风格工程、AI Native 创作、人格工程和认知接口设计纳入前沿概念专题。
- 新增 `docs/context-engineering.md`，把上下文工程作为连接 prompt、RAG、memory、skill、agent、工具结果、风格和安全边界的前沿专题。
- 新增 `docs/blackboard-architecture-multi-agent.md`，用黑板架构解释多 agent 如何围绕共享任务、证据、假设、状态和决策协作。
- 新增 `docs/event-sourcing.md`，用事件溯源解释多 agent 任务如何通过事件流审计、回放和复盘。
- 新增 `docs/cqrs.md`，用读写分离解释多 agent 系统中 command 写入和 query 查询视图的分工。
- 扩充 `docs/cqrs.md`，新增 SQLite 读模型示例、投影刷新节奏、最终一致处理和看板查询样例，并接入 Read Model / Projection 专题。
- 新增 `examples/event-log/` 最小任务事件日志样例和回放脚本 `scripts/replay-task-events.ps1`，展示如何把事件流回放成读模型快照。
- 扩充 `docs/openclaw-superbrain-architecture.md`、`docs/openclaw-multi-agent-linkage.md`、`docs/chapters/10-openclaw.md` 和 `docs/chapters/12-frontier-landscape.md`，把 Saga / Process Manager 接入 OpenClaw、前沿架构和多 agent 长流程编排说明。
- 更新 `scripts/replay-task-events.ps1`，当受限环境无法写入 `-OutputPath` 时，给出更明确的控制台输出替代提示。
- 新增 `docs/ai-history-community-ecosystem.md`，介绍 AI 发展历史、公益站、注册自动化、模型聚合和社区生态的价值与风险。
- 扩充 `docs/style-engineering-ai-native.md` 的 STYLE.md、BRAND.md、WRITER.md 和 AGENTS.md 模板，并扩充 `docs/ai-history-community-ecosystem.md` 的社区生态风险复盘案例。
- 将 Context Engineering 接入 MkDocs 导航、首页、书稿首页、目录、主题索引、术语表、术语回链、资源附录、README、路线图、章节交叉链接和电子书导出脚本。
- 扩充 `docs/openclaw-multi-agent-linkage.md`，新增共享黑板层、任务黑板结构和上下文包写法，并将 Blackboard Architecture 接入导航、索引、术语、资源附录、README、路线图、第 10/12 章和电子书导出脚本。
- 扩充 `docs/openclaw-multi-agent-linkage.md` 和 `docs/blackboard-architecture-multi-agent.md`，新增事件流回放说明，并将 Event Sourcing 接入导航、索引、术语、资源附录、README、路线图、第 10/12 章和电子书导出脚本。
- 扩充 `docs/blackboard-architecture-multi-agent.md`，新增 Markdown、飞书多维表格、GitHub Issue、SQLite 四类黑板原型模板。
- 扩充 `docs/event-sourcing.md`，新增任务事件 schema、事件回放伪代码、快照模板和失败任务回放案例，并将 CQRS 接入导航、索引、术语、资源附录、README、路线图、第 10/12 章和电子书导出脚本。
- 修复 MkDocs 首页 HTML 内 Markdown 渲染，启用 `md_in_html`；修复编辑/源码链接分支，`edit_uri` 改为 `master`；新增 `robots.txt`。
- 更新维护规范：后续每次更新默认同时做已有内容扩充和新技术概念添加，并在发布前复查事实、引用和推演边界。
- 增强 `docs/diagrams.md`，补充 RAG 到 skill、agent、memory 的升级路径、分工图、agent 权限分层和记忆写入决策图。
- 增加 `scripts/content-health-report.ps1` 内容健康报告脚本，扫描短页面、长页面、缺一级标题、章节结构缺口和动态事实复核候选。
- 增加 `.github/workflows/content-health.yml`，每周或手动生成内容健康报告 artifact，作为自动候选扩写 PR 的前置扫描。
- 增加 `docs/team-adoption-playbook.md` 团队 AI 落地手册，覆盖试点选择、数据分级、模板库、知识库、评估机制和治理节奏。
- 增加 `docs/team-adoption-cases.md` 团队 AI 落地案例集，覆盖会议纪要、用户反馈、内部知识库、工程测试建议和发布前审查试点。
- 增加 `docs/frontier-review-playbook.md` 前沿资料季度复核执行手册，把 0.8 复核拆成层级选择、范围确认、证据记录、影响判断、修改顺序和发布判断。
- 为 `docs/frontier-review-log.md` 增加示例记录，帮助维护者照着填写季度复核批次和单条资料记录。
- 优化 GitHub Pages 排版，改用 MkDocs Material 的目录、搜索、页脚导航和自定义样式，并把根目录首页和书稿首页改成分组入口页。
- 更新 `docs/publishing-guide.md`，补充 MkDocs-only 的 GitHub Actions 发布方式。
- 更新 `docs/feedback-validation-kit.md`，补充反馈到改稿闭环、修订任务卡、修改动作对照和改稿后复核模板。
- 更新 `docs/maintenance-guide.md`，补充 AI 协作交接约定和案例技术收录原则，要求开工前说明当前状态、本轮方向、修改范围和验证方式，并明确案例重在有效、有特点、可复盘，过时技术也可作为学习案例保留。
- 更新 `docs/release-checklist-1.0.md`，把前沿复核示例记录纳入 1.0 前的检查项。
- 增加 `docs/team-ai-adoption-roadmap.md` 团队 AI 落地完整路线图，把学习课、专题工作坊、30 天试点和复盘迭代串成四阶段落地路径。
- 增加 `docs/workshop-safety-model-selection.md` AI 安全与模型选型工作坊，提供 90-120 分钟专题培训流程、风险地图、模型路线选择、评测集和团队边界模板。
- 增加 `docs/workshop-industry-cases.md` 行业化工作坊案例集，覆盖教育、医疗、法律、金融、电商、研发六个行业的场景描述、风险地图、模型路线选择和小型评测样例。
- 增加 `docs/pilot-tracking-30days.md` 30 天团队 AI 试点跟踪表，覆盖 Day 1-30 的准备、试跑、迭代、扩展和评估全流程，含日志模板、周度汇总、迭代记录、评估问卷和复盘框架。
- 增加 `docs/release-checklist-1.0.md` 1.0 发布前总检查清单，覆盖内容完整性、学习与落地路线、链接与自动化、外部资料复核、版权许可证、GitHub Pages、人工通读和发布决策。
- 更新 `scripts/export-ebook.ps1`，把已新增的安全、模型选型、团队落地、反馈验证、章节验收、前沿复核材料、主题索引、术语回链索引、学习进度清单、RAG/skill/agent/memory 连续案例、教学资料库连续案例、代码库问答连续案例、连续案例练习与复盘评分表、连续案例课堂试跑版、连续案例课堂投影短版、连续案例团队试点版、连续案例样例库、七层 AI 文明架构和 OpenClaw 前沿架构专题纳入电子书导出。
- 更新 README、目录、维护指南、电子书指南、路线图和 MEMORY。
- 完成本地只读检查：所有本地 Markdown 链接均可解析，占位标记、术语一致性和 Markdown lint 均通过（79 个 Markdown 文件，2026-05-12 复查）。

## 0.7.0 - 2026-05-07

- 将真实应用案例拆分到 `docs/cases/`，并按学生、教师、运营、产品、工程、管理者各补充 2 个案例。
- 为案例统一增加“失败 prompt、改进 prompt、验收标准、复盘”结构。
- 增加电子书封面页、版权页、离线阅读指南和导出样式。
- 扩展 Pandoc 导出脚本，纳入案例、教学材料、图解、配方库、评估量表和电子书指南。
- 增加术语写法规范和术语一致性检查脚本。
- 增加外部链接检查脚本和定期检查 workflow。
- 增加 Markdown lint 和 GitHub Pages 构建检查 workflow。
- 更新 README、目录、发布指南、维护指南、路线图和 MEMORY。

## 0.5.0 - 2026-05-07

- 增加 AI 工作流配方库。
- 增加 AI 能力评估量表。
- 增加项目路线图。
- 增加 Pandoc 电子书导出脚本。
- 更新 README、目录、发布指南、维护指南和 MEMORY。

## 0.4.0 - 2026-05-07

- 增加 PowerShell 本地 Markdown 链接检查脚本。
- 增加 GitHub Actions `Markdown Check` workflow。
- 增加章节复盘题与小测。
- 增加 AI 学习与使用速查讲义。
- 更新 README、目录、发布指南、维护指南和 MEMORY。

## 0.3.0 - 2026-05-07

- 增加许可证说明，采用 CC BY-SA 4.0。
- 增加 GitHub Pages 发布指南。
- 增加项目维护指南。
- 增加分角色学习路径。
- 增加 4 周读书会/教学方案。
- 增加 Mermaid 图解页，覆盖 prompt、RAG、agent、skill、memory 和治理。
- 更新 README、目录和 MEMORY。

## 0.2.0 - 2026-05-07

- 增加 AI 术语表。
- 增加练习参考答案。
- 增加常用检查清单。
- 增加真实应用案例。
- 增加贡献指南、Issue 模板和 PR 模板。

## 0.1.0 - 2026-05-07

- 创建项目结构。
- 完成第 0-14 章初稿。
- 增加资源与引用附录。
- 增加 Prompt、Skill/Card 和 Agent 工作流实践模板。
- 增加 MEMORY 进度记录和 agents 协作记录。
