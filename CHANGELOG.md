# Changelog

所有重要变更记录在这里。日期使用 `YYYY-MM-DD`。

## Unreleased

- 增加 `docs/teaching-kit.md` 教学版本材料包，包含周课件大纲、讲师提示词、课堂练习、作业和结业项目模板。
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
- 将 GitHub Pages 在线阅读版统一为 MkDocs Material，增加 `mkdocs.yml`、阅读样式、依赖文件和 `mkdocs-pages.yml` 发布 workflow。
- 将章节页补齐上一章/下一章导航，并把 `agents/README.md` 改为 `agents/index.md`，避免与站点首页冲突。
- 将 MkDocs 构建输出改到仓库外目录，清理了站点构建警告。
- 增强 MkDocs Material 阅读体验，启用顶部导航标签、搜索分享、即时加载、代码复制、页面编辑入口和源码查看入口。
- 为根目录首页和书稿首页增加“全书内容地图”，并在路线图中补充阅读站后续功能池。
- 为第 0-14 章统一补充“本章导读”，包含预计阅读时间、学习目标、练习入口和相关材料入口。
- 为第 0-14 章统一补充“本章收尾”，在章节导航前提供本章练习、相关案例和下一步入口。
- 为案例页补充“案例索引表”，按角色、主题、风险和章节对应关系快速定位案例。
- 增加 `docs/topic-index.md` 主题索引，按 prompt、RAG、agent、安全、教学、团队落地等主题串联章节、案例和材料。
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
- 更新 `scripts/export-ebook.ps1`，把已新增的安全、模型选型、团队落地、反馈验证、章节验收和前沿复核材料纳入电子书导出。
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
