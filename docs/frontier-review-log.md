# 前沿资料季度复核记录表

最后维护：2026-05-12

这份记录表用于执行 0.8“前沿资料季度复核”。它不是资料清单本身，资料清单在 [资源与引用](appendix-resources.md)；也不是执行说明，执行流程在 [前沿资料季度复核执行手册](frontier-review-playbook.md)。它的作用是让维护者在每次复核时记录证据、判断影响范围，并决定是否更新正文、附录、路线图或发布说明。

本页不声称已经完成最新联网核验。真正复核模型、协议、工具和安全资料时，应打开官方文档、论文或标准组织资料，记录复核日期和处理动作。

## 使用原则

只记录可追溯证据。

不要写“听说某模型更强了”。应记录官方文档、模型卡、论文、标准页、发布说明或仓库 release 的链接和日期。

区分事实更新和写法更新。

事实更新包括模型名称、上下文长度、价格、许可证、接口、协议版本、项目状态和安全建议变化。写法更新包括把旧表述改成“截至某日期的观察”、补充限制条件、把过时内容移到历史说明。

先判断影响范围。

同一个变化可能只影响资源附录，也可能影响第 5 章模型评估、第 8 章 agent、第 11 章开源模型、第 12 章前沿全景、第 13 章治理，或模型选型案例集。

不追求每次都改很多。

季度复核的价值在于持续、可追溯和低成本。没有重大变化时，也应该记录“已复核，无需修改”。

## 复核批次记录

```text
复核批次：
复核日期：
复核负责人：
复核范围：
资料来源：
是否联网核验：
□ 是
□ 否，仅准备复核计划

总体结论：
□ 无需修改
□ 仅更新资源附录
□ 需要更新正文
□ 需要更新案例或教学材料
□ 需要暂缓发布

影响版本：
□ 0.8
□ 0.9
□ 1.0
□ 后续版本
```

## 核心资料复核表

| 类别 | 复核对象 | 优先来源 | 关注点 | 影响页面 | 状态 | 处理动作 |
| --- | --- | --- | --- | --- | --- | --- |
| 趋势报告 | Stanford HAI AI Index | 官方报告页 | 年度趋势、采用率、治理数据 | 第 12 章、资源附录 | 未复核 | 记录是否需要更新趋势判断 |
| OpenAI | Models、Tools、Agents SDK、安全指南 | 官方开发者文档 | 模型名称、工具能力、agent、MCP、安全建议 | 第 5、8、12、13 章 | 未复核 | 更新模型和工具表述 |
| Anthropic | Claude 模型、Agent Skills | 官方文档 | 模型定位、skills 机制、安全边界 | 第 5、7、12 章 | 未复核 | 更新 skills 和模型选型说明 |
| Google | Gemini、A2A | 官方开发者文档、协议页、官方博客 | 多模态、上下文、A2A 规范和生态 | 第 5、12 章、协议相关材料 | 未复核 | 更新协议和模型概览 |
| 中国模型 | DeepSeek、Qwen、Kimi、文心、GLM、混元 | 官方文档和云平台文档 | 模型名称、API、中文场景、企业云能力 | 模型概览、模型选型案例 | 未复核 | 更新中国模型生态说明 |
| 开放权重模型 | Llama、Mistral、Hermes | 官方页面、模型卡、release | 许可证、基础模型、工具调用、部署方式 | 第 11 章、模型选型案例 | 未复核 | 更新开源模型评估项 |
| 检索与企业模型 | Cohere、相关 RAG 文档 | 官方文档 | 检索、rerank、企业知识库能力 | 第 6 章、模型概览 | 未复核 | 更新 RAG 和企业场景说明 |
| xAI | Grok / xAI 文档 | 官方开发者文档 | 模型名称、API、上下文和工具能力 | 模型概览 | 未复核 | 更新模型列表 |
| MCP | Model Context Protocol | 官方文档和规范 | 协议定位、工具和数据源接入 | 第 6、8、12 章 | 未复核 | 更新协议说明 |
| A2A | Agent2Agent | 官方规范和官方博客 | Agent Card、消息、artifact、互操作 | 第 8、12 章 | 未复核 | 更新 agent 协作说明 |
| OpenClaw | GitHub 仓库、官网 | 官方仓库和 release | 项目状态、安装方式、权限风险 | 第 10 章 | 未复核 | 更新个人助手案例 |
| HiMeS | 论文和项目资料 | arXiv、论文页 | 记忆系统定位、实验边界 | 第 9、11 章 | 未复核 | 更新研究定位 |
| 安全标准 | NIST、OWASP、MITRE、NCSC/CISA | 标准组织和政府安全机构 | 风险分类、安全开发、攻击技术、治理建议 | 第 13 章、安全案例材料 | 未复核 | 更新安全和治理建议 |

状态建议使用：

```text
未复核 / 已复核无变化 / 有变化待处理 / 已处理 / 暂不处理
```

## 单条资料记录模板

```text
资料名称：
链接：
来源类型：
官方文档 / 论文 / 标准组织 / 政府机构 / 官方仓库 / 模型卡 / 发布说明

复核日期：
复核人：
资料日期或版本：

原书相关位置：

发现变化：

影响判断：
□ 不影响正文
□ 影响资源附录
□ 影响章节正文
□ 影响案例或练习
□ 影响安全边界
□ 影响 1.0 发布判断

处理动作：
□ 不修改
□ 更新附录
□ 更新正文
□ 增加限制条件
□ 移到历史说明
□ 标注需要人工复核

修改文件：

证据摘录：
只写短摘录或自己的概括，避免复制长篇原文。

备注：
```

## 示例记录

下面是一个虚构示例，只演示写法，不代表真实核验结果。

```text
资料名称：OpenAI Models
链接：https://platform.openai.com/docs/models
来源类型：官方文档

复核日期：2026-07-01
复核人：维护者 A
资料日期或版本：页面当日版本

原书相关位置：第 5 章、docs/model-landscape-china-global.md、docs/model-selection-cases.md

发现变化：
官方模型列表的展示顺序和部分说明文本有调整，强调了不同模型路线在工具调用和成本上的差异。

影响判断：
□ 不影响正文
□ 影响资源附录
□ 影响章节正文
□ 影响案例或练习
□ 影响安全边界
□ 影响 1.0 发布判断

处理动作：
□ 不修改
□ 更新附录
□ 更新正文
□ 增加限制条件
□ 移到历史说明
□ 标注需要人工复核

修改文件：
docs/appendix-resources.md
docs/model-landscape-china-global.md

证据摘录：
官方页面重新强调了模型路线差异，因此正文需要保留“以官方页面为准”的表述，并补充当前核验日期。

备注：
这是一个示范条目，真实复核时应补充实际日期和更具体的页面变化。
```

## 2026-05-20 OpenTelemetry 复核记录

```text
资料名称：OpenTelemetry Traces / Python Exporters / GenAI semantic conventions
链接：
https://opentelemetry.io/docs/concepts/signals/traces/
https://opentelemetry.io/docs/languages/python/exporters/
https://opentelemetry.io/docs/specs/semconv/gen-ai/
https://www.w3.org/TR/trace-context/
来源类型：官方文档 / 标准组织

复核日期：2026-05-20
复核人：AI 协作维护
资料日期或版本：页面当日版本

原书相关位置：
docs/observability-tracing-agent-workflows.md
examples/trace-observability/index.md
examples/trace-observability/otel-minimal-instrumentation.md
docs/appendix-resources.md

发现变化：
本次不是发现破坏性变化，而是补充核验 OpenTelemetry traces、Python exporter、OTLP/Collector 调试路径、W3C Trace Context 和 GenAI semantic conventions 的当前官方入口。

影响判断：
□ 不影响正文
□ 影响资源附录
□ 影响章节正文
□ 影响案例或练习
□ 影响安全边界
□ 影响 1.0 发布判断

处理动作：
□ 不修改
□ 更新附录
□ 更新正文
□ 增加限制条件
□ 移到历史说明
□ 标注需要人工复核

修改文件：
docs/observability-tracing-agent-workflows.md
examples/trace-observability/index.md
examples/trace-observability/otel-minimal-instrumentation.md
examples/trace-observability/otel_agent_trace_minimal.py
docs/appendix-resources.md

证据摘录：
OpenTelemetry 文档把 trace、span、context propagation、exporter 和 Collector 作为可观测性链路中的核心概念；GenAI semantic conventions 正在演进，正文需提醒读者以当前官方字段为准。

备注：
正文采用“官方字段方向 + 自定义 agent.* 字段”的双层写法，避免把仍在演进的 GenAI 字段写成永远不变的业务事实。
```

## 更新正文的判断标准

| 变化类型 | 是否更新正文 | 处理方式 |
| --- | --- | --- |
| 模型名称变更 | 是 | 更新模型概览和相关案例，保留核验日期 |
| 模型价格变化 | 通常不写入正文 | 改成“需查官方价格页”，避免固定价格过时 |
| 上下文长度变化 | 视影响而定 | 若正文写了具体数值，需要更新或移除 |
| API 或工具能力变化 | 是 | 更新工具、agent、RAG 或工作流章节 |
| 协议版本变化 | 是 | 更新 MCP、A2A 或 agent 协作相关说明 |
| 许可证变化 | 是 | 更新开源模型和部署建议 |
| 安全建议变化 | 是 | 更新安全治理章节和事故复盘材料 |
| 新模型发布 | 不一定 | 只有影响选型框架或代表新路线时进入正文 |
| 社区热度变化 | 不直接更新 | 先放资源附录或路线图，不作为事实结论 |

## 影响范围速查

| 如果变化涉及 | 优先检查 |
| --- | --- |
| 模型能力和选型 | [第 5 章](chapters/05-evaluation.md)、[中外 AI 模型特色概览](model-landscape-china-global.md)、[AI 模型选型实战案例集](model-selection-cases.md) |
| 工具调用和 RAG | [第 6 章](chapters/06-tools-rag.md)、[AI 工作流配方库](workflow-recipes.md)、[团队 AI 落地手册](team-adoption-playbook.md) |
| skills | [第 7 章](chapters/07-skills.md)、[AI Skill/Card 可复用模板](../examples/skill-card-template.md) |
| agent 和协议 | [第 8 章](chapters/08-agents.md)、[第 12 章](chapters/12-frontier-landscape.md)、[Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md) |
| 记忆系统 | [第 9 章](chapters/09-memory.md)、[第 11 章](chapters/11-hermes-himes-open-models.md) |
| OpenClaw | [第 10 章](chapters/10-openclaw.md) |
| 开源模型 | [第 11 章](chapters/11-hermes-himes-open-models.md)、[AI 模型选型实战案例集](model-selection-cases.md) |
| 安全治理 | [第 13 章](chapters/13-safety-governance.md)、[AI 安全案例更新指南](safety-case-updates.md)、[AI 安全事故复盘案例集](safety-incident-retrospectives.md) |
| 教学和团队试点 | [教学版本材料包](teaching-kit.md)、[团队 AI 落地完整路线图](team-ai-adoption-roadmap.md)、[试读与试跑反馈包](feedback-validation-kit.md) |

## 季度复核流程

```text
1. 先阅读 [前沿资料季度复核执行手册](frontier-review-playbook.md)，确认本次复核层级和范围。
2. 复制“复核批次记录”。
3. 从核心资料复核表中选择本次范围。
4. 打开官方来源，记录资料日期或版本。
5. 判断是否影响正文、案例、教学材料或发布判断。
6. 修改对应文件。
7. 更新 docs/appendix-resources.md 的核验日期和维护建议。
8. 更新 CHANGELOG.md 和 MEMORY.md。
9. 运行本地链接检查、术语一致性检查和 Markdown lint。
10. 如果涉及外部链接变化，运行或触发外部链接检查。
```

## 本地检查记录

```text
执行日期：
执行人：

本地链接和占位检查：
□ 通过
□ 失败，已记录原因

术语一致性检查：
□ 通过
□ 失败，已记录原因

Markdown lint：
□ 通过
□ 失败，已记录原因

外部链接检查：
□ 已运行
□ 未运行，原因：

电子书导出：
□ 已验证
□ 未验证，原因：
```

## 发布影响记录

```text
本次复核是否影响 1.0 发布：
□ 不影响
□ 需要修改后发布
□ 建议暂缓发布

原因：

必须处理的问题：

可以后续处理的问题：

发布说明需要提到的变化：
```

## 下次复核准备

```text
下次建议复核日期：
优先复核对象：
需要人工判断的问题：
需要联网核验的问题：
可能影响的章节：
```
