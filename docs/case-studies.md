# 真实应用案例

本页是案例入口。案例已经拆分到 `docs/cases/`，便于后续按角色继续扩写。案例不以短为目标，关键是有效、有特点、能复盘；如果一个案例需要较长过程才能讲清失败原因和改进方式，可以保留完整过程。

如果你想按角色、主题或风险找案例，先看 [案例索引表](cases/index.md)。那里有角色索引、主题索引、风险索引和章节对应关系。

如果你更喜欢按主题标签找入口，可以直接看 [主题索引](topic-index.md)。

每个案例都使用同一结构：

1. 场景：说明任务背景和读者要解决的问题。
2. 失败 prompt：展示常见但不稳定的提问方式。
3. 改进 prompt：给出可以直接复制、可约束输出的版本。
4. 验收标准：说明怎样判断 AI 输出能不能进入下一步。
5. 复盘：帮助读者把一次经验沉淀成模板、skill 或 agent 流程。

## 分角色案例

- [案例索引表](cases/index.md)
- [RAG、Skill、Agent 与 Memory 连续案例](cases/rag-skill-agent-memory.md)
- [教学资料库连续案例](cases/teaching-rag-skill-agent-memory.md)
- [代码库问答连续案例](cases/codebase-rag-skill-agent-memory.md)
- [Agent Trace 生产事故复盘长案例](cases/agent-trace-incident-retrospective.md)
- [连续案例练习与复盘评分表](cases/continuous-case-exercises.md)
- [连续案例课堂试跑版](cases/continuous-case-classroom-run.md)
- [连续案例团队试点版](cases/continuous-case-team-pilot.md)
- [连续案例样例库](cases/continuous-case-samples.md)
- [连续案例课堂投影短版](cases/continuous-case-slide-brief.md)
- [学生：学习计划、论文阅读](cases/student.md)
- [教师：备课、作业反馈](cases/teacher.md)
- [运营：会议纪要、内容排期](cases/operations.md)
- [产品：竞品分析、需求评审](cases/product.md)
- [工程：修 Bug、补测试](cases/engineering.md)
- [管理者：AI 使用规范、项目复盘](cases/management.md)
- [团队 AI 落地案例集](team-adoption-cases.md)
- [前沿与过时技术案例库](technology-evolution-cases.md)

## OpenClaw 与前沿架构

- [七层 AI 文明架构](seven-layer-ai-civilization.md)
- [OpenClaw 多 agent 联动教程](openclaw-multi-agent-linkage.md)
- [OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md)
- [Agent Trace 生产事故复盘长案例](cases/agent-trace-incident-retrospective.md)

## 使用建议

第一次阅读时，可以先挑和自己角色最接近的一页。真正使用时，不要直接照抄案例里的背景信息，而要替换成自己的目标、资料、限制、验收标准和禁止事项。

如果一个案例反复使用，可以继续把它改写成：

- prompt 模板：适合单次任务。
- skill：适合固定领域经验。
- agent 工作流：适合多步骤、需要工具、需要审计的任务。

三条 RAG/skill/agent/memory 连续案例读完后，建议继续使用 [连续案例练习与复盘评分表](cases/continuous-case-exercises.md)、[连续案例课堂试跑版](cases/continuous-case-classroom-run.md)、[连续案例课堂投影短版](cases/continuous-case-slide-brief.md)、[连续案例团队试点版](cases/continuous-case-team-pilot.md) 和 [连续案例样例库](cases/continuous-case-samples.md)，把案例转成可提交作业、课堂讨论、团队试点和复盘证据，也顺便对照低质量、刚及格、可试点和可示范的差异。
