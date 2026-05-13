# 章节练习与验收映射表

最后维护：2026-05-12

这份映射表用于发布前通读、读书会备课和团队培训设计。它把第 0-14 章分别对应到练习任务、复盘问题、案例材料和验收证据，帮助维护者判断每章是否真的能被读者使用，而不是只完成了正文写作。

建议配合 [章节复盘题与小测](chapter-review-questions.md)、[课堂练习工作纸](classroom-worksheets.md)、[教学示范作业集](teaching-examples.md)、[试读与试跑反馈包](feedback-validation-kit.md)、[AI 能力评估量表](assessment-rubric.md) 和 [1.0 发布前总检查清单](release-checklist-1.0.md) 使用。

## 使用方式

发布前通读时，每章至少记录三类证据：

```text
1. 读者能否说清本章核心概念。
2. 读者能否完成一个真实任务练习。
3. 读者能否判断 AI 输出是否可以进入下一步。
```

如果某章读完只能“理解概念”，但不能完成练习或做出判断，就应该补例子、补反例或补验收标准。

## 总体验收标准

| 范围 | 最低要求 | 证据来源 |
| --- | --- | --- |
| 第 0-4 章 | 读者能写出结构化 prompt，并能根据失败反馈改写 | prompt 前后对照、课堂工作纸、复盘题 |
| 第 5-7 章 | 读者能建立评测样例、知识库边界和 skill 草稿 | 评测表、知识库清单、skill 卡片 |
| 第 8-10 章 | 读者能说明 agent 行动边界、记忆边界和个人助手风险 | agent 工作说明、记忆文件、权限清单 |
| 第 11-13 章 | 读者能解释开源模型、前沿协议和安全治理的适用边界 | 选型表、安全底线、治理清单 |
| 第 14 章 | 读者能形成 30 天实践交付物和下月改进计划 | 30 天产出清单、复盘记录 |

## 逐章映射

| 章节 | 核心能力 | 练习任务 | 复盘证据 | 可配合材料 |
| --- | --- | --- | --- | --- |
| [第 0 章：学习路线图](chapters/00-learning-map.md) | 判断自己该先练哪层能力 | 写出 1 个本周真实 AI 使用目标，并放入最小实践循环 | 能说明自己优先练表达、拆解、复用还是判断 | [分角色学习路径](learning-paths.md)、[章节复盘题与小测](chapter-review-questions.md) |
| [第 1 章：基础对话](chapters/01-dialogue-basics.md) | 用目标、背景、约束、标准和输出格式提问 | 把一个含糊问题改写成五要素 prompt | 原始 prompt 与改写 prompt 对照清楚 | [Prompt 模式实践模板](../examples/prompt-patterns.md)、[课堂练习工作纸](classroom-worksheets.md) |
| [第 2 章：AI 基本概念](chapters/02-ai-basics.md) | 理解模型、token、上下文、幻觉和多模态 | 标出一个 AI 回答中需要核验的事实点 | 能说明哪些内容必须查来源 | [AI 术语表](appendix-glossary.md)、[常见误区与纠偏指南](common-pitfalls.md) |
| [第 3 章：Prompt 入门](chapters/03-prompt-basics.md) | 使用示例、反例、分阶段输出和自检 | 写一个含示例和反例的任务 prompt | AI 输出能按指定格式完成，且有自检结果 | [Prompt 调试指南](prompt-debugging-guide.md)、[教学示范作业集](teaching-examples.md) |
| [第 4 章：Prompt 工作流](chapters/04-prompt-workflows.md) | 把复杂任务拆成可复用流程 | 把一个每周重复任务写成 5 步工作流 | 每一步都有输入、输出和检查点 | [AI 工作流配方库](workflow-recipes.md)、[常用检查清单](appendix-checklists.md) |
| [第 5 章：模型选择、验证与评估](chapters/05-evaluation.md) | 按任务建立小型评测，而不是只看排行榜 | 为一个常用 prompt 设计 5-10 条测试样例 | 能用评分表比较两个模型或两个 prompt | [中外 AI 模型特色概览](model-landscape-china-global.md)、[AI 模型选型实战案例集](model-selection-cases.md)、[AI 能力评估量表](assessment-rubric.md) |
| [第 6 章：工具调用、RAG 与知识库](chapters/06-tools-rag.md) | 设计工具权限和知识库边界 | 列出 3 个可进入知识库的文件和 3 类禁止进入的资料 | 能说明 RAG 可能错在哪里 | [安全案例更新指南](safety-case-updates.md)、[团队 AI 落地手册](team-adoption-playbook.md) |
| [第 7 章：Skills](chapters/07-skills.md) | 把重复经验固化为 skill | 写一个 skill 草稿，包含输入、输出、边界和失败样例 | 能解释 skill 与普通 prompt 的区别 | [AI Skill/Card 可复用模板](../examples/skill-card-template.md)、[教学示范作业集](teaching-examples.md) |
| [第 8 章：Agent](chapters/08-agents.md) | 设计 agent 目标、工具、观察和人工确认点 | 为低风险任务写 agent 工作说明 | 能列出允许动作、禁止动作和回滚要求 | [Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md)、[AI 任务选择决策指南](task-decision-guide.md) |
| [第 9 章：记忆系统](chapters/09-memory.md) | 区分短期记忆、长期记忆和禁止保存内容 | 写一份个人 `profile.md` 记忆文件 | 包含可保存偏好和禁止保存信息 | [安全事故复盘案例集](safety-incident-retrospectives.md)、[常用检查清单](appendix-checklists.md) |
| [第 10 章：OpenClaw 与个人助手工作台](chapters/10-openclaw.md) | 把个人助手看成能力组合，而不是单一工具 | 设计个人助手最小需求和权限清单 | 能说明哪些动作必须人工确认 | [图解：AI 工作系统](diagrams.md)、[Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md) |
| [第 11 章：Hermes、HiMeS 与开源模型路线](chapters/11-hermes-himes-open-models.md) | 区分开放权重模型、许可证和记忆系统研究方向 | 写一个开源模型最小评估表 | 包含能力、成本、部署、许可证和安全边界 | [资源与引用](appendix-resources.md)、[AI 模型选型实战案例集](model-selection-cases.md) |
| [第 12 章：AI 前沿发展全景](chapters/12-frontier-landscape.md) | 用任务系统视角理解多模态、agent 和协议化趋势 | 写下所在行业未来一年 3 个 AI 场景 | 能区分聊天、工作流、RAG、工具调用和 agent | [AI 任务选择决策指南](task-decision-guide.md)、[行业化工作坊案例集](workshop-industry-cases.md) |
| [第 13 章：安全、伦理与治理](chapters/13-safety-governance.md) | 建立个人和团队 AI 使用底线 | 写 5 条禁止事项和 3 个必须人工确认点 | 能说明数据、版权、偏见和 agent 权限风险 | [团队 AI 落地手册](team-adoption-playbook.md)、[安全案例更新指南](safety-case-updates.md)、[安全事故复盘案例集](safety-incident-retrospectives.md) |
| [第 14 章：30 天实践计划](chapters/14-practice-plan.md) | 把全书方法转成持续实践系统 | 从 30 天计划中选择本周 3 天任务并执行 | 有 prompt、工作流、评测集、skill、记忆文件或安全规范产出 | [30 天团队试点跟踪表](pilot-tracking-30days.md)、[试读与试跑反馈包](feedback-validation-kit.md) |

## 角色化验收路径

不同读者不需要用同一套证据。

| 读者 | 推荐章节 | 最小交付物 | 判断标准 |
| --- | --- | --- | --- |
| 初学者 | 第 0-4 章 | 3 个结构化 prompt、1 个五步工作流 | 能独立改写含糊问题 |
| 学生 | 第 0-5 章、第 14 章 | 学习计划、错题分析 prompt、5 条评测样例 | 不把 AI 答案直接当标准答案 |
| 教师或培训者 | 第 0-7 章、第 13 章 | 一节课设计、课堂工作纸、评分表 | 学员能完成练习并说出验收标准 |
| 产品和运营 | 第 3-6 章、第 12-13 章 | 用户反馈分析流程、评测样例、风险清单 | 输出能进入需求、实验或内容流程 |
| 工程师 | 第 4-8 章、第 13 章 | 代码协作工作流、测试样例、agent 边界 | 不让 AI 绕过测试、审查和权限控制 |
| 管理者 | 第 5-6 章、第 12-14 章 | 团队试点任务、数据分级、治理节奏 | 能决定继续、修改后继续或暂停试点 |

## 通读记录模板

每章通读后可复制填写：

```text
章节：
通读人：
日期：

核心概念是否清楚：
□ 清楚
□ 需要补例子
□ 需要重写

练习是否可执行：
□ 可执行
□ 需要讲师带着做
□ 不可执行

验收标准是否明确：
□ 明确
□ 需要补评分表
□ 不明确

关联材料是否足够：
□ 足够
□ 需要补案例
□ 需要补工作纸

发现的问题：

修改建议：

发布判断：
□ 通过
□ 修改后通过
□ 暂缓
```

## 常见缺口处理

| 缺口 | 处理方式 |
| --- | --- |
| 读者看懂但不会做 | 补一个最小任务和输入输出示例 |
| 读者能做但不会判断好坏 | 补验收标准或评分表 |
| 章节概念过密 | 把术语移到术语表，正文增加反例 |
| 案例过长 | 保留主线，把细节移到案例页 |
| 安全边界不清 | 增加禁止事项、人工确认点和回滚要求 |
| 与团队落地关系弱 | 链接到团队落地手册、试点跟踪表或反馈包 |

## 进入 1.0 的证据建议

在正式发布 1.0 前，建议至少保留以下证据：

```text
1. 第 0-4 章：1 份初学者 prompt 改写记录。
2. 第 5-7 章：1 份小型评测集和 1 份 skill 草稿。
3. 第 8-10 章：1 份 agent 权限边界和个人助手需求清单。
4. 第 11-13 章：1 份模型选型表和 1 份安全底线。
5. 第 14 章：1 份 30 天实践复盘或团队试点复盘。
```

如果没有真实读者反馈，可以先在发布记录中标注“材料已完成，尚未真实试跑”。这比把草案当作已验证材料更容易维护。
