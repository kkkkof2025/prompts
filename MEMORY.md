# MEMORY

最后更新：2026-05-20

## 当前目标

创建一本可发布到 GitHub/GitHub Pages 的中文 AI 学习方法开源书，从基础对话讲到 prompt、skills、agents、OpenClaw、Hermes、HiMeS、MCP/A2A 和前沿发展全景。当前定位为 0.7 草案。

## 已完成

- 确认当前目录 `X:\c\ai\prompts` 初始为空，且不是 git 仓库。
- 选择 Markdown 作为主格式，原因是 GitHub 原生支持，维护成本低，适合开源协作。
- 将 GitHub Pages 推荐发布方式调整为 GitHub Actions + MkDocs Material，原因是书稿在 `docs/`，实践模板在 `examples/`，根目录也有维护文档，使用 MkDocs 根目录 `docs_dir: .` 可以保证它们进入同一阅读体系。
- 建立根目录说明、进度记忆、GitHub Pages 入口和章节目录。
- 建立根目录 `index.md` 和 MkDocs 配置入口，便于 GitHub Pages 以书籍站点方式构建。
- 完成 `docs/chapters/00-14` 主体章节初稿。
- 完成 `docs/appendix-resources.md` 资源与引用附录。
- 完成 `docs/appendix-glossary.md` AI 术语表。
- 完成 `docs/appendix-exercise-answers.md` 练习参考答案。
- 完成 `docs/appendix-checklists.md` 常用检查清单。
- 完成 `docs/case-studies.md` 真实应用案例入口。
- 完成 `docs/cases/` 分角色案例拆分，覆盖学生、教师、运营、产品、工程、管理者，每类 2 个案例。
- 完成 `CONTRIBUTING.md`、Issue 模板和 PR 模板。
- 完成 `LICENSE.md`，采用 CC BY-SA 4.0。
- 完成 `CHANGELOG.md` 版本记录。
- 完成 `.gitignore`。
- 完成 `docs/publishing-guide.md` GitHub 发布指南。
- 完成 `docs/maintenance-guide.md` 项目维护指南。
- 完成 `docs/learning-paths.md` 分角色学习路径。
- 完成 `docs/facilitation-guide.md` 读书会与教学方案。
- 完成 `docs/diagrams.md` Mermaid 图解页。
- 完成 `scripts/check-markdown-links.ps1` 本地 Markdown 链接和占位词检查脚本。
- 完成 `.github/workflows/markdown-check.yml` GitHub Actions 自动检查。
- 完成 `docs/chapter-review-questions.md` 章节复盘题与小测。
- 完成 `docs/quick-reference.md` AI 学习与使用速查讲义。
- 完成 `docs/workflow-recipes.md` AI 工作流配方库。
- 完成 `docs/assessment-rubric.md` AI 能力评估量表。
- 完成 `ROADMAP.md` 项目路线图。
- 完成 `scripts/export-ebook.ps1` Pandoc 电子书导出脚本。
- 完成 `docs/ebook-cover.md` 电子书封面页。
- 完成 `docs/copyright.md` 版权与许可页。
- 完成 `docs/ebook-guide.md` 电子书与离线阅读指南。
- 完成 `docs/ebook-style.css` Pandoc HTML/EPUB 基础样式。
- 完成 `docs/term-style-guide.md` 术语写法规范。
- 完成 `scripts/check-terminology.ps1` 术语一致性检查脚本。
- 完成 `scripts/check-external-links.ps1` 外部链接检查脚本。
- 完成 `.markdownlint.json` Markdown lint 配置。
- 完成 `.github/workflows/external-links.yml` 定期外部链接检查 workflow。
- 完成 `.github/workflows/mkdocs-pages.yml` MkDocs Pages 构建与发布 workflow。
- 更新 `.github/workflows/markdown-check.yml`，加入 Markdown lint 和术语一致性检查。
- 完成 `docs/teaching-kit.md` 教学版本材料包，覆盖 4 周课件大纲、讲师提示词、课堂练习、作业和结业项目模板。
- 完成 `docs/team-ai-adoption-roadmap.md` 团队 AI 落地完整路线图，把学习课、专题工作坊、30 天试点和复盘迭代串成四阶段路线，含阶段目标、材料映射、进入下一阶段条件、决策分支和主持人检查清单。
- 完成 `docs/workshop-safety-model-selection.md` AI 安全与模型选型工作坊，覆盖 90-120 分钟专题培训流程、风险地图、模型路线选择、小型评测集、团队边界和 30 天复盘。
- 完成 `docs/workshop-industry-cases.md` 行业化工作坊案例集，覆盖教育、医疗、法律、金融、电商、研发六个行业的场景描述、风险地图、模型路线选择和小型评测样例（每行业 5 条）。
- 完成 `docs/pilot-tracking-30days.md` 30 天团队 AI 试点跟踪表，覆盖 Day 1-3 准备启动、Day 4-7 第一周试跑、Day 8-14 第二周迭代、Day 15-21 第三周扩展、Day 22-30 第四周评估全流程，含每日日志模板、周度汇总、prompt 迭代模板、评估问卷、总结报告模板和复盘会讲稿。
- 完成 `docs/release-checklist-1.0.md` 1.0 发布前总检查清单，覆盖内容完整性、学习与落地路线、链接与自动化、外部资料复核、版权许可证、GitHub Pages、人工通读和发布决策，并提供 v1.0.0 发布说明模板。
- 完成 `docs/classroom-worksheets.md` 课堂练习工作纸，提供 10 张可发给学员填写的表单。
- 完成 `docs/teaching-examples.md` 教学示范作业集，覆盖匿名化 prompt、工作流、skill、agent、安全规范和结业项目样例。
- 完成 `docs/feedback-validation-kit.md` 试读与试跑反馈包，覆盖个人试读、课堂试跑、团队试点、观察记录、评分量表和匿名化反馈记录。
- 完成 `docs/chapter-validation-map.md` 章节练习与验收映射表，逐章对应核心能力、练习任务、复盘证据和配套材料。
- 完成 `docs/frontier-review-log.md` 前沿资料季度复核记录表，覆盖复核批次、核心资料复核表、单条资料记录、正文更新判断标准、影响范围和发布影响记录。
- 完成 `docs/frontier-review-playbook.md` 前沿资料季度复核执行手册，把 0.8 复核拆成层级选择、范围确认、证据记录、影响判断、修改顺序、发布判断和收尾检查。
- 为 `docs/frontier-review-log.md` 增加示例记录，演示怎样填写季度复核批次和单条资料记录。
- 完成 `docs/common-pitfalls.md` 常见误区与纠偏指南，覆盖 12 类高频错误和可复制改写方式。
- 完成 `docs/task-decision-guide.md` AI 任务选择决策指南，帮助读者在普通对话、prompt、工作流、模板、skill、RAG、工具调用、agent、多 agent 和人工主导之间选择。
- 完成 `docs/prompt-debugging-guide.md` Prompt 调试指南，覆盖输出失败诊断、调试流程、失败类型和调试记录模板。
- 完成 `docs/safety-case-updates.md` AI 安全案例更新指南，覆盖间接 prompt 注入、数据泄露、RAG、agent 权限、多模态、长期记忆、评估和权限层防护等新版安全案例。
- 完成 `docs/safety-incident-retrospectives.md` AI 安全事故复盘案例集，覆盖知识库错误引用、会议纪要泄露、agent 误发邮件、代码依赖风险、多模态隐私和模型升级格式失效等复盘样例。
- 完成 `docs/model-landscape-china-global.md` 中外 AI 模型特色概览，按模型路线、生态、中文场景、企业云、开放权重、长上下文、多模态和选型模板介绍中国及国际模型。
- 完成 `docs/model-selection-cases.md` AI 模型选型实战案例集，覆盖个人中文写作、团队知识库、代码助手、客服反馈分类、长合同阅读、本地部署和多模态文档处理。
- 完成 `docs/team-adoption-playbook.md` 团队 AI 落地手册，覆盖试点选择、数据分级、模板库、知识库、评估机制、角色分工和治理节奏。
- 完成 `docs/team-adoption-cases.md` 团队 AI 落地案例集，覆盖会议纪要、用户反馈、内部知识库、工程测试建议和发布前审查试点。
- 更新 `scripts/export-ebook.ps1`，把安全案例、模型选型、团队落地、反馈验证、章节验收、前沿复核执行手册、前沿复核记录和 1.0 发布检查材料纳入电子书导出。
- 更新 `docs/teaching-kit.md`、`docs/teaching-examples.md`、`docs/facilitation-guide.md`、`docs/classroom-worksheets.md`、`docs/workflow-recipes.md`、`docs/team-adoption-playbook.md`、`docs/case-studies.md`、`docs/SUMMARY.md`、`docs/index.md`、`index.md`、`README.md`、`docs/quick-reference.md`、`docs/common-pitfalls.md`、`docs/task-decision-guide.md`、`docs/assessment-rubric.md`、`docs/chapters/05-evaluation.md`、`docs/chapters/11-hermes-himes-open-models.md`、`docs/chapters/13-safety-governance.md`、`docs/appendix-resources.md`、`CHANGELOG.md` 和 `ROADMAP.md`，纳入教学版本材料包、AI 安全与模型选型工作坊、课堂练习工作纸、教学示范作业集、常见误区纠偏材料、Prompt 调试指南、任务选择指南、安全案例更新指南、安全事故复盘案例集、中外模型特色概览、模型选型实战案例集、团队 AI 落地手册和团队落地案例集。
- 更新 `README.md`、`index.md`、`docs/index.md`、`docs/SUMMARY.md`、`docs/appendix-resources.md`、`docs/frontier-review-log.md`、`docs/frontier-review-playbook.md`、`docs/maintenance-guide.md`、`docs/ebook-guide.md`、`docs/release-checklist-1.0.md`、`ROADMAP.md`、`CHANGELOG.md` 和 `scripts/export-ebook.ps1`，纳入前沿资料季度复核执行手册及示例记录。
- 更新 `docs/feedback-validation-kit.md`，把“从反馈到改稿”扩展成修订闭环，新增修订任务卡、反馈到修改动作对照、进入改稿判断和改稿后复核模板。
- 更新 `docs/maintenance-guide.md`，新增 AI 协作交接约定：后续每轮继续完善前，先说明已确认状态、本轮方向、修改范围、不会触碰的边界和验证方式；收尾时说明本轮完成内容、检查结果和下次建议方向。
- 完成 `docs/technology-evolution-cases.md` 前沿与过时技术案例库，覆盖插件式工具接入、早期自主 agent、RAG、长上下文、skills、MCP、A2A、个人助手工作台、开放模型、本地部署、长期记忆和 computer use 等技术演进案例。
- 更新 `README.md`、`index.md`、`docs/index.md`、`docs/SUMMARY.md`、`docs/appendix-resources.md`、`docs/ebook-guide.md`、`agents/index.md`、`scripts/export-ebook.ps1`、`ROADMAP.md` 和 `CHANGELOG.md`，纳入前沿与过时技术案例库。
- 更新 `docs/maintenance-guide.md`，新增案例和技术收录原则：案例不以短为目标，重在有效、有特点、可复盘；前沿技术只要概念、来源和边界不写错即可纳入；过时技术也可作为技术演进或历史复盘案例保留。
- 优化 GitHub Pages 排版：切换为 MkDocs Material，使用 `docs/stylesheets/extra.css` 做首页和阅读样式补充，并将根目录 `index.md` 和 `docs/index.md` 改为分组入口页，减少线上首页的长链接堆叠。
- 完成 `docs/automation-content-workflow.md` 自动化维护与扩写方案，说明 GitHub Actions 适合做扫描、提醒、候选稿和 draft PR，不适合无审查地直接替代人工定稿。
- 移除旧版 Pages 主题配置，改用 `mkdocs.yml` 控制站点语言、目录、搜索、主题、样式和 GitHub Pages 发布输出。
- 更新 `docs/SUMMARY.md`、`README.md`、`docs/maintenance-guide.md`、`docs/publishing-guide.md`、`docs/ebook-guide.md`、`docs/release-checklist-1.0.md`、`ROADMAP.md`、`CHANGELOG.md` 和 `scripts/export-ebook.ps1`，纳入自动化维护与扩写方案和新的 Pages 排版说明。
- 完成 MkDocs-only 阅读版基础配置：新增 `mkdocs.yml`、`requirements-docs.txt` 和 `docs/stylesheets/extra.css`，使用项目根目录作为 MkDocs 内容目录，适合左侧目录、搜索、章节型阅读和分组入口展示。
- 新增 `.github/workflows/mkdocs-pages.yml`，作为唯一 GitHub Pages 发布 workflow，在 push、pull request 和手动触发时构建 MkDocs 站点，并在非 PR 场景部署 Pages。
- 为 `docs/chapters/00-14` 已完成章节增加“章节导航”，每章底部提供上一章和下一章链接，便于像读书一样连续阅读。
- 增强 MkDocs Material 阅读体验：启用顶部导航标签、搜索分享、即时加载、代码复制、页面编辑入口和源码查看入口；根目录首页和书稿首页新增“全书内容地图”。
- 更新 `ROADMAP.md`，补充阅读站功能池：学习目标、预计阅读时间、章节练习入口、标签体系、案例索引、术语回链、图解增强、离线包、章节进度清单和自动候选扩写 PR。
- 为 `docs/chapters/00-14` 统一补充“本章导读”，每章开头包含预计阅读时间、学习目标、练习入口和相关材料入口，方便读者判断本章怎么学、读完做什么。
- 为 `docs/chapters/00-14` 统一补充“本章收尾”，每章底部在章节导航前提供本章练习、相关案例和下一步入口，把连续阅读和实践动作连接起来。
- 为 `docs/cases/index.md` 补充案例索引表，新增按角色、主题、风险和章节对应关系的快速定位入口，并在首页与案例入口页显式链接。
- 更新 `README.md`、`docs/index.md`、`docs/case-studies.md` 和 `docs/SUMMARY.md`，把案例索引表显式放到首页、案例入口和目录里。
- 新增 `docs/topic-index.md` 主题索引，按 prompt、工作流、评估、RAG、skill、agent、记忆、开放模型、前沿、安全、教学、团队落地、维护和案例复盘等主题串联章节、案例和材料；同步加入 MkDocs 导航、README、书稿首页、案例入口、案例索引、SUMMARY、ROADMAP 和 CHANGELOG。
- 新增 `docs/glossary-links.md` 术语回链索引，把核心术语连接到定义、章节、案例、配套材料和常见误解；同步加入 MkDocs 导航、README、书稿首页、根目录首页、SUMMARY、ROADMAP 和 CHANGELOG。
- 新增 `docs/learning-progress.md` 学习进度清单，提供总进度、章节进度表、30 天推进节奏、卡住时跳转规则和复盘记录模板；同步加入 MkDocs 导航、README、书稿首页、根目录首页、SUMMARY、ROADMAP 和 CHANGELOG。
- 更新 `docs/appendix-glossary.md`，补充 Hermes、HiMeS、Open Model、OpenClaw 和 Prompt Injection，并增加术语回链入口。
- 更新 `scripts/export-ebook.ps1`，纳入此前新增的主题索引，并加入术语回链索引和学习进度清单，避免电子书导出遗漏关键阅读工具。
- 增强 `docs/diagrams.md`，新增 RAG 从一次问答升级到可复用能力、RAG/skill/agent/memory 分工、agent 权限分层和记忆写入决策图。
- 新增 `scripts/content-health-report.ps1` 内容健康报告脚本，扫描短页面、长页面、缺一级标题页面、章节结构缺口和动态事实复核候选。
- 新增 `.github/workflows/content-health.yml`，每周或手动生成内容健康报告 artifact；同步更新 `docs/automation-content-workflow.md`、`docs/maintenance-guide.md`、`README.md`、`ROADMAP.md` 和 `CHANGELOG.md`。
- 新增 `docs/cases/rag-skill-agent-memory.md` 长案例，以客户反馈知识库为主线，把普通 prompt 逐步演进为 RAG、反馈分析 skill、受控 agent 和 memory 边界；同步接入第 6-9 章、MkDocs 导航、案例入口、案例索引、主题索引、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/teaching-rag-skill-agent-memory.md` 长案例，以教学资料库为主线，把普通 prompt 逐步演进为教学 RAG、feedback skill、受控助教 agent 和 memory 边界；同步接入第 6-9 章、教学版本材料包、分角色学习路径、MkDocs 导航、案例入口、案例索引、主题索引、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/codebase-rag-skill-agent-memory.md` 长案例，以工程代码库为主线，把普通 prompt 逐步演进为代码库 RAG、bug triage skill、受控修复 agent 和 repo memory 边界；同步接入第 6-9 章、工程案例、分角色学习路径、MkDocs 导航、案例入口、案例索引、主题索引、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/continuous-case-exercises.md` 连续案例练习与复盘评分表，把三条长案例转成课前阅读、分组讨论、实操改写、rubric 评分和团队试点复盘材料；同步接入案例入口、案例索引、主题索引、学习路径、教学版本材料包、首页、书稿首页、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/continuous-case-classroom-run.md` 连续案例课堂试跑版，把三条长案例转成 90/120 分钟课堂脚本、分组方式、课堂材料包、示范样例、评分方式和讲师观察记录；同步接入 MkDocs 导航、案例入口、案例索引、主题索引、学习路径、教学材料、反馈验证包、首页、书稿首页、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/continuous-case-team-pilot.md` 连续案例团队试点版，把三条长案例转成 7 天最小试点、30 天试点衔接、试点任务卡、三类试点方案、日志模板、复盘脚本、决策表和写回规则；同步接入 MkDocs 导航、案例入口、案例索引、主题索引、团队路线图、团队落地手册、30 天试点跟踪表、反馈验证包、首页、书稿首页、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/continuous-case-samples.md` 连续案例样例库，提供匿名化作业、课堂观察记录和 7 天团队试点复盘样例；后续又为客户反馈、教学资料库和代码库三条主线补充低质量、刚及格、可试点、可示范等质量层级对照，帮助读者比较不同成熟度；同步接入 MkDocs 导航、案例入口、案例索引、主题索引、学习路径、教学材料、团队路线图、反馈验证包、首页、书稿首页、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/cases/continuous-case-slide-brief.md` 连续案例课堂投影短版，把连续案例压缩成 12 个可投屏页面、讲师提示、互动问题、开场词、收尾词和时间压缩版本；同步接入 MkDocs 导航、案例入口、案例索引、主题索引、学习路径、教学材料、反馈验证包、首页、书稿首页、SUMMARY、README、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/seven-layer-ai-civilization.md` 七层 AI 文明架构，把执行、记忆、意图、认知经济、世界模型、身份和文明展开成前沿系统框架，并补充七层之外的技术发展推演；同步接入 MkDocs 导航、书稿首页、SUMMARY、README、主题索引、第 12 章、案例入口、技术演进案例库、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/openclaw-multi-agent-linkage.md` OpenClaw 多 agent 联动教程，覆盖飞书、Telegram、云文档、任务状态、统一 skill 安装、回写和人工审批；同步接入 MkDocs 导航、书稿首页、SUMMARY、README、主题索引、第 10 章、案例入口、技术演进案例库、ROADMAP、CHANGELOG 和电子书导出脚本。
- 新增 `docs/openclaw-superbrain-architecture.md` OpenClaw、Node.js 与超级大脑架构分析，比较 Node.js、Python、Go、Rust、Markdown、流式中间层和更强认知系统设计；同步接入 MkDocs 导航、书稿首页、SUMMARY、README、主题索引、第 10 章、案例入口、技术演进案例库、ROADMAP、CHANGELOG 和电子书导出脚本。
- 更新 `mkdocs.yml`，新增 `OpenClaw 与前沿架构` 导航分组，移除顶部 tabs 模式，左侧目录显示全书导航树，并保留可展开/收起的分组行为；MkDocs search 插件继续启用中文和英文索引。
- 修复 `.github/workflows/mkdocs-pages.yml` 和 `.github/workflows/markdown-check.yml` 触发分支，让 workflow 同时监听 `master` 和 `main`。此前线上 `https://kkkkof2025.github.io/prompts/` 仍显示旧版页面，是因为仓库实际分支为 `master`，而 Pages workflow 只监听 `main`，推送后没有触发 MkDocs 部署。
- 修正 GitHub Pages 发布源：仓库 Pages 已切换为 `GitHub Actions` 构建类型，并重新触发 `MkDocs Pages` workflow，线上首页已从旧 Jekyll 输出切换为 MkDocs Material 输出，搜索索引和左侧栏均可访问。
- 修复线上 CSS/JS 404：`exclude_docs` 不能排除 `assets/`，否则 MkDocs Material 生成的 `assets/stylesheets/` 和 `assets/javascripts/` 会从发布产物中消失；本地 strict build 已确认 `../prompts-site/assets` 正常生成。
- 继续扩充三篇前沿架构内容：`docs/seven-layer-ai-civilization.md` 新增个人/团队/组织落地视角、十条七层之外能力轴和判断公式；`docs/openclaw-multi-agent-linkage.md` 新增三种部署层级、飞书 + Telegram + 云文档 + OpenClaw 完整案例、状态机和优先级建议；`docs/openclaw-superbrain-architecture.md` 新增全 Markdown 性能瓶颈、v0.1 模块清单、事件格式和自我优化阶段。
- 2026-05-18 记录新维护要求：后续每次更新默认同时完成“已有内容扩充完善”和“新技术概念添加/评估”两条线；新增概念需要复查是否符合实际，区分事实、来源解释、本书判断和待复核内容，必要时在页面底部列出参考与复核说明。
- 修复 MkDocs 展示问题：新增 `robots.txt`；`mkdocs.yml` 启用 `md_in_html`，让首页和书稿首页卡片内的链接、加粗正常渲染；`edit_uri` 从 `edit/main/` 改为 `edit/master/`，修复查看源码和编辑链接 404。
- 新增 `docs/style-engineering-ai-native.md`，吸收 2026-05-16 “AI 的风格设定进化”笔记，把 Prompt Engineering、Style Engineering、Personality Engineering 和 Cognitive System Design 串成 AI Native 创作专题。
- 新增 `docs/ai-history-community-ecosystem.md`，介绍 AI 发展历史、公益站、注册自动化/注册机概念边界、模型聚合、Prompt 市场和社区生态，明确不提供绕过授权、批量注册或破解类操作方法。
- 扩充 `docs/style-engineering-ai-native.md`，新增 STYLE.md、BRAND.md、WRITER.md 和 AGENTS.md 四类可复用风格文件模板，帮助读者把风格要求从一次性 prompt 固化成项目资产。
- 扩充 `docs/ai-history-community-ecosystem.md`，新增公益站隐私黑箱、模型聚合声明不透明、本地部署包长期不更新、注册自动化越过授权边界四个风险复盘案例。
- 新增 `docs/context-engineering.md` Context Engineering 上下文工程专题，把上下文选择、排序、压缩、隔离和来源追踪作为连接 prompt、RAG、memory、skill、agent、工具结果、风格和安全边界的中间层概念，并补充客户反馈上下文包案例。
- 将 Context Engineering 接入 `mkdocs.yml`、`docs/SUMMARY.md`、根目录首页、书稿首页、README、主题索引、术语表、术语回链、术语写法规范、资源附录、第 6/9/12 章、路线图、变更记录和电子书导出脚本。
- 2026-05-18 联网复核 Context Engineering 关键来源：IBM “What is context engineering?”、arXiv `2507.13334` 上下文工程综述、OpenAI Prompting Guide 和 Anthropic Agent Skills Overview；正文已标注本书分层框架和六个动作属于综合判断，不等同于单一来源定义。
- 扩充 `docs/openclaw-multi-agent-linkage.md`，新增共享黑板层，把云文档、状态表、上下文包、证据区、复核区和决策区组织成多 agent 共享工作台，并补充任务黑板 YAML 示例。
- 新增 `docs/blackboard-architecture-multi-agent.md` Blackboard Architecture 黑板架构专题，解释传统黑板系统与现代多 agent 协作的关系，包含最小黑板结构、AI 书稿维护案例、五种落地方式、Context Engineering 和 OpenClaw 的关系。
- 扩充 `docs/blackboard-architecture-multi-agent.md`，新增 Markdown 黑板、飞书多维表格黑板、GitHub Issue 黑板和 SQLite 黑板四类原型模板，帮助读者从概念进入可落地结构。
- 将 Blackboard Architecture 接入 `mkdocs.yml`、`docs/SUMMARY.md`、根目录首页、书稿首页、README、主题索引、术语表、术语回链、术语写法规范、资源附录、第 10/12 章、路线图、变更记录和电子书导出脚本。
- 2026-05-19 联网复核 Blackboard Architecture 关键来源：H. Penny Nii 的 AI Magazine 黑板架构经典文章，以及 arXiv `2507.01701` 关于 LLM 多 agent 黑板架构的预印本；正文已标注“黑板架构映射到 OpenClaw、云文档、Git 和上下文工程”属于本书工程化推演。
- 新增 `docs/event-sourcing.md` Event Sourcing 事件溯源专题，解释如何把多 agent 任务状态变化记录成可回放事件流，用于审计、复盘、恢复和黑板状态重建。
- 扩充 `docs/event-sourcing.md`，新增任务事件 schema、事件回放伪代码、快照模板和失败任务回放案例，把“事件流用于审计”推进到可照着实现的任务模型。
- 新增 `docs/cqrs.md` CQRS 读写分离专题，解释 command 写入和 query 查询视图的职责分离，以及它和 Event Sourcing、黑板架构、OpenClaw 多 agent 系统的关系。
- 新增 `docs/read-model-projections.md` Read Model 与 Projection 读模型专题，解释如何用 SQLite、看板查询、投影刷新、最终一致和重建策略把事件流变成可查询视图。
- 新增 `docs/transactional-outbox-idempotency.md` Transactional Outbox 与幂等消费专题，解释怎样用可靠消息发放和消费端去重避免双写与重复处理。
- 新增 `docs/saga-process-manager.md` Saga / Process Manager 专题，解释怎样用补偿事务和长流程编排把多步骤、多 agent、多系统任务收尾。
- 新增 `docs/durable-execution-agent-workflows.md` Durable Execution 持久化执行专题，解释 agent 长任务怎样跨崩溃、重启、人工等待和外部回调继续执行。
- 新增 `docs/observability-tracing-agent-workflows.md` Observability / Tracing 智能体可观测性专题，解释 trace、span、logs、metrics、成本、证据链接和人工审批怎样帮助 agent 任务排障和复盘。
- 新增 `examples/trace-observability/` Agent Trace 可观测性样例，提供 `trace-spans.jsonl`、`trace-dashboard-schema.sql`、`scripts/replay-agent-traces.ps1` 和 `scripts/load-agent-traces-sqlite.py`，把 span 回放成 JSON 看板，也可以导入 SQLite 后从 `trace_summary`、`actor_cost`、`failure_queue` 和 `longest_spans` 视图读回看板。
- 新增 `examples/trace-observability/otel-minimal-instrumentation.md` 和 `examples/trace-observability/otel_agent_trace_minimal.py`，把 Agent Trace 样例继续延伸到 OpenTelemetry Python SDK、Console exporter、OTLP exporter 和 Collector 调试路径。
- 新增 `examples/trace-observability/otel-production-hardening.md` 和 `examples/trace-observability/otel-collector-agent-traces.yaml`，把 Agent Trace 的 OpenTelemetry 接入继续延伸到采样、脱敏、Collector 管道、tail sampling、redaction 和事故复盘模板。
- 新增 `examples/trace-observability/trace-backend-selection.md`，把 JSONL/SQLite、Jaeger、Grafana Tempo 和托管平台之间的 trace backend 选型、查询字段、留存和隐私边界写成实践指南。
- 新增 `examples/trace-observability/trace-context-propagation.md` 和 `examples/trace-observability/trace_context_bridge.py`，把多 agent handoff 的 W3C `traceparent` 传播、carrier 设计、常见失败和 SDK 注入/提取关系写成可运行样例。
- 新增 `docs/cases/agent-trace-incident-retrospective.md` 长案例，把 trace 断裂、安全复核失败、事件日志、补偿动作和人工审批串成一次可复盘事故。
- 更新 `examples/event-log/index.md`，把任务事件日志样例和 Agent Trace 可观测性样例互相链接，帮助读者区分“业务事实事件”和“运行追踪 span”。
- 扩充 `docs/openclaw-multi-agent-linkage.md`、`docs/blackboard-architecture-multi-agent.md` 和 `docs/openclaw-superbrain-architecture.md`，补充事件流回放、黑板当前状态与事件历史的分工，以及 `task_created`、`evidence_added`、`approved`、`published`、`rolled_back` 等事件类型。
- 扩充 `docs/openclaw-multi-agent-linkage.md`、`docs/openclaw-superbrain-architecture.md`、`docs/chapters/10-openclaw.md` 和 `docs/chapters/12-frontier-landscape.md`，把 Observability / Tracing 接入 OpenClaw、多 agent、CLI、超级大脑和前沿趋势说明。
- 将 Event Sourcing 接入 `mkdocs.yml`、`docs/SUMMARY.md`、根目录首页、书稿首页、README、主题索引、术语表、术语回链、术语写法规范、资源附录、第 10/12 章、路线图、变更记录和电子书导出脚本。
- 2026-05-19 联网复核 Event Sourcing 关键来源：Martin Fowler 的 Event Sourcing 文章和 Microsoft Learn 的 Event Sourcing pattern；正文已标注“事件溯源映射到 AI 协作、黑板架构和 OpenClaw”属于本书工程化推演，不是所有 AI 项目的默认数据层。
- 将 CQRS 接入 `mkdocs.yml`、`docs/SUMMARY.md`、根目录首页、书稿首页、README、主题索引、术语表、术语回链、术语写法规范、资源附录、第 10/12 章、路线图、变更记录和电子书导出脚本。
- 2026-05-19 联网复核 CQRS 关键来源：Martin Fowler 的 CQRS 文章和 Microsoft Learn 的 CQRS pattern；正文已标注“CQRS 映射到 OpenClaw、多 agent、黑板架构和事件溯源”属于本书工程化推演，CQRS 本身不是 AI 专属概念。
- 扩充 `docs/cqrs.md`，新增 SQLite 读模型、Projection 刷新节奏、最终一致和看板查询样例；将 Read Model / Projection 接入 `mkdocs.yml`、目录、首页、书稿首页、README、主题索引、术语表、术语回链、术语写法规范、资源附录、第 10/12 章、OpenClaw 前沿架构页、路线图、变更记录和电子书导出脚本。
- 2026-05-19 复核 Read Model / Projection 关键来源：Microsoft Learn CQRS/Event Sourcing 文档、Martin Fowler CQRS、SQLite UPSERT、SQLite CREATE VIEW 和 PostgreSQL Materialized Views；正文已标注“读模型与 OpenClaw 多 agent 任务系统结合”属于本书工程化推演。
- 2026-05-19 新增 `docs/transactional-outbox-idempotency.md` 后，把多 agent 事件同步的“可靠发放 + 幂等消费”也纳入本书前沿专题；参考来源增加 AWS Prescriptive Guidance Transactional Outbox 和 Microsoft Learn Transactional Outbox。
- 2026-05-19 新增 `docs/saga-process-manager.md` 后，把多 agent 长流程的“补偿事务 + 流程编排”也纳入本书前沿专题；参考来源增加 Microsoft Learn Saga pattern、Cloud-native data patterns 和 microservices.io Saga。
- 2026-05-20 新增 `docs/durable-execution-agent-workflows.md` 后，把 agent 长任务的“持久化执行 + workflow history + durable timer + signal”纳入本书前沿专题；参考来源增加 Temporal Docs、Microsoft Learn Durable Functions、Restate Docs 和 DBOS Docs。
- 2026-05-20 新增 `docs/observability-tracing-agent-workflows.md` 后，把 agent 任务的“可观测性 + trace + span + logs + metrics + 成本 + 证据链”纳入本书前沿专题；参考来源增加 OpenTelemetry Docs、OpenTelemetry Sampling、OpenTelemetry Collector Processors、OpenTelemetry Python Exporters、OpenTelemetry Collector security best practices、OpenTelemetry sensitive data guidance、OpenTelemetry GenAI semantic conventions、OpenAI Agents SDK Tracing 和 W3C Trace Context。
- 2026-05-20 新增 `examples/trace-observability/trace-backend-selection.md` 后，把 trace backend 选型、查询字段、留存和隐私边界纳入可观测性实践；参考来源增加 OpenTelemetry Collector Exporters、Jaeger Architecture、Grafana Tempo Docs、Grafana Tempo Architecture 和 Grafana Tempo TraceQL。
- 本地执行 `python -m mkdocs build --config-file mkdocs.yml` 和 `python -m mkdocs build --strict --config-file mkdocs.yml` 成功；MkDocs 已覆盖 `docs/`、`examples/` 和根目录维护文件，输出目录在项目外部，避免生成站点被重复纳入内容目录。
- 完成本地只读检查：所有本地 Markdown 链接均可解析。
- 最新检查命令：`./scripts/check-markdown-links.ps1 -Root . -CheckPlaceholders`、`./scripts/check-terminology.ps1 -Root .`、`npx --yes markdownlint-cli2 "**/*.md" "#_site" "#node_modules" "#vendor" "#dist" "#site"`、`python -m mkdocs build --strict --config-file mkdocs.yml`、`python -c "... compile(...) ..."`、`./scripts/replay-task-events.ps1 -InputPath examples/event-log/task-events.jsonl`、`./scripts/replay-agent-traces.ps1 -InputPath examples/trace-observability/trace-spans.jsonl`、`python scripts/load-agent-traces-sqlite.py --input examples/trace-observability/trace-spans.jsonl --database tmp/trace-dashboard.sqlite --reset`、`python examples/trace-observability/trace_context_bridge.py`、`git diff --check`。
- 最新检查结果：本地链接、占位标记、术语一致性、Markdown lint、Python 示例语法检查、事件回放脚本控制台输出、Agent trace 回放脚本控制台输出、SQLite trace 导入、trace context 桥接脚本 stdout、`git diff --check` 和 MkDocs strict build 均通过（2026-05-20 复查，115 个 Markdown 文件）。MkDocs strict build 仅输出 Material for MkDocs 关于未来 MkDocs 2.0 的官方提示，不影响本次构建；本轮未启动本地预览，也未启动本地 Collector。
- 当前 Markdown 规模约 30176 行、65305 个词、572569 个字符（含团队 AI 落地完整路线图、行业化工作坊案例集、30 天试点跟踪表、试读与试跑反馈包、反馈到改稿闭环、前沿与过时技术案例库、自动化维护与扩写方案、阅读站功能池、章节导读、章节收尾、章节练习与验收映射表、案例索引表、主题索引、术语回链索引、学习进度清单、内容健康报告、图解增强、客户反馈连续案例、教学资料库连续案例、代码库问答连续案例、连续案例练习与复盘评分表、连续案例课堂试跑版、连续案例团队试点版、连续案例样例库（含三条主线质量层级对照）、七层 AI 文明架构、OpenClaw 多 agent 联动教程、OpenClaw/Node.js/超级大脑架构、Read Model / Projection、Transactional Outbox、Saga、Durable Execution、Observability / Tracing、Agent Trace 可观测性样例、OpenTelemetry 最小接入样例、OpenTelemetry 生产化加固样例、Trace Backend 选型与查询策略、跨 Agent Trace Context 传播样例、Agent Trace 生产事故复盘长案例、前沿资料季度复核执行手册、前沿资料季度复核示例记录和 1.0 发布前总检查清单）。
- 联网核验关键动态来源，核验日期为 2026-05-07：
  - Stanford HAI 2026 AI Index
  - OpenAI Agents SDK 文档
  - OpenAI Models 文档
  - Anthropic Agent Skills 文档
  - Anthropic Claude model overview
  - Google Gemini API models
  - DeepSeek API 文档
  - Alibaba Cloud Model Studio/Qwen 模型文档
  - Moonshot AI/Kimi 开放平台文档
  - 百度智能云千帆文档
  - 智谱 GLM 模型概览
  - 腾讯云混元大模型文档
  - Meta Llama 官方入口
  - Mistral AI model overview
  - Cohere models 文档
  - xAI model documentation
  - Model Context Protocol 文档
  - Google A2A/Agent2Agent 相关官方博客
  - OpenClaw 官方 GitHub 仓库
  - Nous Research Hermes 4.3 发布页
  - HiMeS 论文摘要
  - NIST AI Risk Management Framework
  - NIST AI 600-1: Generative AI Profile
  - OWASP Top 10 for LLM Applications
  - MITRE ATLAS
  - NCSC/CISA Guidelines for secure AI system development
  - OpenAI Safety Best Practices

## 内容决策

- 文件名使用英文，正文使用简体中文，便于跨平台和 GitHub Pages 链接稳定。
- 书稿入口放在 `docs/index.md`，完整目录放在 `docs/SUMMARY.md`。
- 前沿信息不写成不可变结论，而写成“截至某日期的观察”，并要求后续维护者定期复核。
- 对用户可能混写 Hermes 和 HiMeS 的处理：本书同时覆盖 Hermes 开源模型路线和 HiMeS 个性化记忆系统。
- OpenClaw 被放在 agent 实践章节中，定位为“个人 AI 助手和多通道 agent 工作台的案例”，不要求读者必须安装。
- 许可证选择：采用 CC BY-SA 4.0，适合开源书传播、改编和相同方式共享。若后续要改为更宽松的 CC BY 4.0，需要同步修改 `LICENSE.md`、`README.md` 和 `CONTRIBUTING.md`。
- 真实应用案例采用分角色拆分：`docs/case-studies.md` 只保留入口，具体案例放入 `docs/cases/`。
- 当前优先保障 GitHub Pages 在线阅读；Pandoc 导出资料保留，但后续完善书籍内容时不把导出验证作为必需步骤。
- 自动化检查分为本地链接、术语一致性、Markdown lint、外部链接和 Pages 构建检查；外部链接检查默认定期运行，不放入每次提交的强制路径。
- 后续 AI 协作维护时，开工前应先告知用户当前已确认状态、本轮将做内容和方向、预计修改范围及验证方式；收尾时再给出已完成内容和下次建议方向。
- 案例长度不是主要限制。只要案例有效、有特点、能帮助读者复盘，可以写长，也可以围绕同一技术拆成多个有差异的案例。
- 前沿技术可以纳入正文、案例库或资源附录，但不能写成永久不变的判断；涉及动态事实时应优先核验官方来源并标注日期。
- 过时技术不是自动删除对象。只要能解释技术演进、失败经验、治理边界或今天工具的设计原因，就可以作为学习案例保留，并标注为技术演进案例或历史复盘案例。
- MkDocs 站点首页不应承担完整目录职责。首页只保留分组入口和少量核心路径，完整索引交给 `docs/SUMMARY.md`；站点目录由 `mkdocs.yml` 的 `nav` 显式控制，避免线上首页变成长列表。
- GitHub Actions 可以辅助维护内容，但定位应是扫描、候选稿、draft PR 和检查，不应无审查地自动改写主分支正文。
- MkDocs Material 作为唯一在线阅读和 GitHub Pages 发布版。后续不再维护多套站点版式，新增内容需要同步进入 `mkdocs.yml` 导航或可从已有目录页稳定到达。
- 2026-05-16 读取用户本地笔记 `D:\Document\Documents\ob\Note\000 System\030 Temp\2026\05\20260516 七层 AI 文明架构.md`。该笔记提出执行、记忆、意图、认知经济、世界模型、身份、文明七层结构；后续适合延展为第 12 章和前沿技术案例库中的“从 AI 工具到数字生态”专题，重点强调复杂系统、治理边界、资源预算、记忆压缩、agent 社会和知识演化。
- 2026-05-16 将新增待办写入 `ROADMAP.md`：连续案例课堂投影短版 30/60/90/120 分钟讲法、行业化匿名试点复盘、OpenClaw 多 agent 联动教程、统一 skill 安装与共享任务同步、七层 AI 文明架构专题。
- 2026-05-16 为 GitHub 推送授权改用本仓库专用 SSH host alias：`github.com-kkkkof2025-prompts`，生成本地 key `~/.ssh/id_ed25519_github_kkkkof2025_prompts`，remote 已切换为 `git@github.com-kkkkof2025-prompts:kkkkof2025/prompts.git`。用户添加 public key 后已验证通过：`ssh -T github.com-kkkkof2025-prompts` 返回成功认证，`git push --dry-run origin HEAD` 显示可将 `master` 从 `23c5f94` 推到 `84d7ae6`；2026-05-17 已执行真实 `git push origin master`，远端 `HEAD` 更新到 `84d7ae6`。
- 后续每次完成后默认执行：本地静态检查、提交 commit、真实 `git push origin master`，除非用户明确要求不要提交或不要推送。

## 并行 agent 使用

- 已启动并完成一个写作 agent，负责 `examples/` 目录下的实践模板：
  - `examples/prompt-patterns.md`
  - `examples/skill-card-template.md`
  - `examples/agent-workflow-checklist.md`
- 主线程不修改 `examples/`，避免写入冲突。

## 下一步建议

- 下次继续完善前，先按 `docs/maintenance-guide.md` 的 AI 协作交接约定输出“当前状态、本轮方向、修改范围、边界和验证方式”，再开始改文件。
- 推送到 GitHub 后，先观察 MkDocs Pages workflow 是否通过；如果构建通过，再访问线上首页确认目录、搜索、章节上一页/下一页和移动端阅读是否正常。
- GitHub Pages 设置中应使用 `GitHub Actions` 作为 Source，由 `.github/workflows/mkdocs-pages.yml` 发布唯一的 MkDocs Material 站点。
- 下一轮建议优先继续为连续案例样例库补充行业化匿名作业样例、课堂观察记录和团队试点复盘样例；也可以继续扩展课堂投影短版的 30、60、90、120 分钟讲法。
- OpenClaw 多 agent 联动教程可作为新的高优先级扩写：用飞书、Telegram、Webhook、云文档或任务看板作为共享任务层，演示多个 agent 如何接收任务、同步状态、调用统一 skill 包、交接结果和保留人工复核。
- 七层 AI 文明架构可作为新的前沿思想专题：从执行层和记忆层讲到意图层、认知经济层、世界模型层、身份层和文明层，但正文需要明确这是分析框架，不是已稳定落地的产品形态。
- Context Engineering 已完成基础专题，下一轮可继续补多 agent、代码库、教学资料库和个人知识库四类上下文包样例，并把上下文包写入 OpenClaw 多 agent 联动教程。
- Blackboard Architecture 已完成基础专题，并补充 Markdown 黑板、飞书多维表格黑板、GitHub Issue 黑板和 SQLite 黑板四类原型模板；下一轮可继续补真实运行日志、回放脚本和团队试点样例。
- Event Sourcing 已完成基础专题，并补充任务事件 schema、事件回放伪代码、快照模板和失败任务复盘样例；下一轮可继续补真实事件日志和回放脚本。
- CQRS 与 Read Model / Projection、Transactional Outbox 与幂等消费、Saga / Process Manager、Durable Execution、Observability / Tracing 已完成基础专题，下一轮可继续补复杂统计读模型、真实任务日志、跨页面物化视图、relay worker、消费端去重表、多步骤补偿、workflow history、durable timer、trace 采样、脱敏和 Collector 部署样例。
- 按季度更新 `docs/appendix-resources.md` 中的模型、协议和工具状态；执行时先使用 `docs/frontier-review-playbook.md` 确认复核层级、范围和修改顺序，再用 `docs/frontier-review-log.md` 记录证据、影响范围和处理动作。
- 继续补充 `docs/technology-evolution-cases.md`，尤其是从真实工具迁移、失败复盘、协议演进和企业落地中抽出的长案例；不要因为案例长就删掉关键过程。
- 教学版本材料包、课堂练习工作纸、教学示范作业集、试读与试跑反馈包和章节练习与验收映射表已经有初稿；下一步应通过真实读书会或团队培训验证练习难度，并用匿名化真实课堂作业替换或扩展示范样例。
- AI 安全与模型选型工作坊、行业化工作坊案例集和 30 天试点跟踪表已完成初稿；下一步应使用 `docs/feedback-validation-kit.md` 收集团队试点反馈，重点收集教育、医疗、法律、金融、电商、研发六个行业的真实试跑数据。
- 发布前需要人工通读一次全书，重点检查案例是否过长、术语是否对初学者友好、外部事实是否需要重新核验。

## 交接提示

如果后续继续让 AI 协作维护本项目，可直接说：

```text
请阅读 README.md、MEMORY.md 和 docs/SUMMARY.md，继续扩写这本 AI 学习方法全景书。优先保持章节结构稳定，新增内容请同步更新 MEMORY.md 和 docs/appendix-resources.md。
```
