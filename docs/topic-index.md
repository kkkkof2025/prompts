# 主题索引

这是一份手工整理的主题导航页，不依赖额外插件。它的目的很简单：当你只有一个问题时，先找到对应主题，再进入章节、案例或工具页。

## 核心标签

| 主题标签 | 适合先看 | 相关章节 | 相关案例或材料 | 风险提醒 |
| --- | --- | --- | --- | --- |
| `prompt` / `对话` / `输出格式` | [第 1 章](chapters/01-dialogue-basics.md)、[第 3 章](chapters/03-prompt-basics.md) | 第 1-4 章 | [Prompt 模式实践模板](../examples/prompt-patterns.md)、[Prompt 调试指南](prompt-debugging-guide.md) | 任务不清时不要急着写长 prompt |
| `workflow` / `模板` / `复用` | [第 4 章](chapters/04-prompt-workflows.md)、[AI 工作流配方库](workflow-recipes.md) | 第 4 章 | [AI 工作流配方库](workflow-recipes.md)、[常用检查清单](appendix-checklists.md) | 没有检查点时别把复杂任务一次交给 AI |
| `评估` / `选型` / `验证` | [第 5 章](chapters/05-evaluation.md)、[模型选型实战案例集](model-selection-cases.md) | 第 5 章 | [中外 AI 模型特色概览](model-landscape-china-global.md)、[AI 能力评估量表](assessment-rubric.md) | 不要只看榜单或宣传 |
| `工具` / `RAG` / `知识库` | [第 6 章](chapters/06-tools-rag.md) | 第 6 章 | [团队 AI 落地手册](team-adoption-playbook.md)、[安全案例更新指南](safety-case-updates.md) | 权限、引用和更新流程必须先定 |
| `skill` / `agent` / `memory` / `OpenClaw` | [第 7-10 章](chapters/07-skills.md)、[第 8 章](chapters/08-agents.md) | 第 7-10 章 | [AI Skill/Card 可复用模板](../examples/skill-card-template.md)、[Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md)、[图解：AI 工作系统](diagrams.md) | 能行动的系统必须有回滚和人工确认 |
| `开放模型` / `前沿` / `协议` | [第 11-12 章](chapters/11-hermes-himes-open-models.md)、[前沿与过时技术案例库](technology-evolution-cases.md) | 第 11-12 章 | [资源与引用](appendix-resources.md)、[前沿资料季度复核执行手册](frontier-review-playbook.md) | 动态事实要标注核验日期 |
| `安全` / `治理` / `风险` | [第 13 章](chapters/13-safety-governance.md) | 第 13 章 | [AI 安全事故复盘案例集](safety-incident-retrospectives.md)、[团队 AI 落地手册](team-adoption-playbook.md) | 高风险任务必须保留人工责任 |
| `教学` / `学习` / `课堂` | [第 0 章](chapters/00-learning-map.md)、[教学版本材料包](teaching-kit.md) | 第 0、1、3、14 章 | [分角色学习路径](learning-paths.md)、[课堂练习工作纸](classroom-worksheets.md)、[教学示范作业集](teaching-examples.md) | 学员任务要可执行，不能只讲概念 |
| `团队落地` / `试点` / `工作坊` | [团队 AI 落地完整路线图](team-ai-adoption-roadmap.md)、[30 天团队试点跟踪表](pilot-tracking-30days.md) | 第 12-14 章 | [团队 AI 落地案例集](team-adoption-cases.md)、[AI 安全与模型选型工作坊](workshop-safety-model-selection.md)、[行业化工作坊案例集](workshop-industry-cases.md) | 先做低风险试点，再扩展 |
| `维护` / `发布` / `自动化` | [项目维护指南](maintenance-guide.md)、[GitHub 发布指南](publishing-guide.md) | 第 0 章、附录和维护页 | [自动化维护与扩写方案](automation-content-workflow.md)、[1.0 发布前总检查清单](release-checklist-1.0.md) | 自动化适合检查和候选稿，不适合无审查改正文 |
| `案例` / `复盘` / `历史` | [案例索引表](cases/index.md)、[真实应用案例](case-studies.md) | 第 1-14 章 | [前沿与过时技术案例库](technology-evolution-cases.md) | 长案例可以保留，但要能复盘 |

## 按问题找

```text
我想写一个更稳定的 prompt -> 先看 第 1 章、第 3 章、Prompt 调试指南
我想知道该不该做 RAG -> 先看 第 6 章、团队 AI 落地手册、安全案例更新指南
我想把经验做成 skill -> 先看 第 7 章、AI Skill/Card 模板、教学示范作业集
我想判断要不要上 agent -> 先看 第 8 章、AI 任务选择决策指南、Agent 安全清单
我想做模型选型 -> 先看 第 5 章、模型特色概览、模型选型案例
我想做教学或培训 -> 先看 第 0 章、教学版本材料包、课堂练习工作纸
我想带团队试点 -> 先看 团队路线图、30 天试点跟踪表、团队案例集
我想检查安全边界 -> 先看 第 13 章、安全案例更新指南、事故复盘案例集
我想找案例 -> 先看 案例索引表、真实应用案例、前沿与过时技术案例库
我想做发布维护 -> 先看 维护指南、发布指南、自动化维护与扩写方案
```

## 使用建议

- 先从你现在最接近的问题开始，不要从最宏大的概念开始。
- 主题索引只是入口，不是结论。
- 进入对应页面后，再回到章节、案例和练习材料。
- 动态事实仍要回到 `docs/appendix-resources.md` 和前沿复核流程核验。
