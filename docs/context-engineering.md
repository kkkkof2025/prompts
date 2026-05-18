# Context Engineering：上下文工程

最后核验：2026-05-18

Context Engineering 可以译成“上下文工程”。它回答的问题不是“这一句话 prompt 怎么写”，而是“模型在下一步行动前，应该看到哪些信息、按什么顺序看到、哪些信息不能看到、哪些信息应该被压缩、哪些信息必须附来源”。

需要先说明边界：Context Engineering 正在从社区实践走向研究和工程化讨论，但不同资料的定义仍不完全一致。本书把它作为连接 prompt、RAG、memory、agent、skills 和 Style Engineering 的中间层概念。

如果只记一句话，可以记成：

```text
Prompt 是指令，context 是工作现场。
```

## 为什么它重要

很多 AI 失败不是因为模型不够聪明，而是因为它看到的上下文不对：

- 看到太少：缺背景、缺规则、缺用户目标。
- 看到太多：长上下文里混进噪音和过时资料。
- 顺序不对：关键规则被放在后面，任务材料压过安全边界。
- 来源不清：模型不知道哪些是事实、哪些是猜测、哪些是用户偏好。
- 权限不清：agent 看到不该看的文档，或使用不该使用的工具。
- 记忆不稳：上一轮经验没有进入下一轮，或错误记忆被反复放大。

所以，当系统从聊天走向 RAG、agent 和多工具协作时，真正的难点会变成“上下文选择、组织、压缩、更新和审计”。

## 和 Prompt Engineering 的区别

| 维度 | Prompt Engineering | Context Engineering |
| --- | --- | --- |
| 核心问题 | 这次怎么说清任务 | 下一步应该让模型看到什么 |
| 主要对象 | 指令、示例、输出格式 | 文档、记忆、工具结果、状态、权限、历史 |
| 时间尺度 | 单次或少数几轮对话 | 长期项目、持续任务、多 agent 协作 |
| 失败模式 | 任务不清、格式不稳 | 信息过载、资料过时、上下文污染、权限泄露 |
| 典型技术 | 模板、few-shot、反例、自检 | RAG、memory、rerank、摘要、状态机、上下文包 |
| 验收标准 | 输出是否符合要求 | 相关信息是否完整、可信、最小、可追溯 |

Prompt Engineering 仍然重要，但它只解决“指令层”。Context Engineering 解决的是“信息环境层”。

## 一个上下文包应该包含什么

一个高质量上下文包不只是把资料塞进模型窗口，而是把信息分层：

| 层级 | 内容 | 例子 |
| --- | --- | --- |
| 任务层 | 当前要做什么 | 本轮目标、输出格式、验收标准 |
| 规则层 | 必须遵守什么 | 安全边界、术语规范、项目约定 |
| 事实层 | 已核验资料 | 官方文档、论文、数据库记录、引用片段 |
| 状态层 | 当前进展 | owner、任务状态、版本号、失败记录 |
| 记忆层 | 长期经验 | 用户偏好、历史决策、失败模式 |
| 工具层 | 可用能力 | 搜索、文件、浏览器、代码、云文档 API |
| 风格层 | 输出气质 | STYLE.md、WRITER.md、BRAND.md |
| 复核层 | 如何检查 | rubric、测试、人工确认点、引用要求 |

越复杂的 agent 系统，越不能把这些层混在一段长 prompt 里。混在一起会让模型难以判断优先级。

## 上下文工程的六个动作

| 动作 | 目的 | 常见做法 |
| --- | --- | --- |
| Select | 选择相关资料 | 检索、过滤、任务标签、权限过滤 |
| Rank | 排序重要性 | rerank、规则优先级、时间衰减 |
| Compress | 压缩上下文 | 摘要、去重、提取决策和证据 |
| Structure | 组织结构 | YAML、表格、章节、上下文包 |
| Isolate | 隔离风险 | 权限分层、敏感信息脱敏、只读沙箱 |
| Trace | 追踪来源 | 引用、版本号、任务日志、证据链 |

这六个动作组合起来，才像工程。只会“把更多资料放进去”，还不是上下文工程。

## 一个上下文包模板

```yaml
CONTEXT_PACKAGE:
  task:
    goal: 扩充 Style Engineering 专题
    output: Markdown section
    acceptance:
      - 有正例和反例
      - 区分事实和本书判断
      - 至少列出一个复核来源
  rules:
    terminology:
      - prompt 小写
      - agent 小写
      - Style Engineering 保持英文
    safety:
      - 不提供绕过授权或批量注册教程
      - 动态事实需要引用
  evidence:
    official_docs:
      - url: https://docs.claude.com/en/docs/claude-code/output-styles
        note: 输出样式会影响 Claude Code 系统提示和行为
    papers:
      - url: https://arxiv.org/abs/2507.13334
        note: Context Engineering survey
  memory:
    project_preferences:
      - 每次更新要同时扩充已有内容和添加新概念
      - 新概念要复查事实和引用
  style:
    voice: 克制、清晰、工程化
    avoid:
      - 夸张营销词
      - 未核验结论
  review:
    checks:
      - markdownlint
      - local links
      - MkDocs strict build
```

这个模板的重点不是格式，而是让“模型看到的东西”变得可检查。

## 案例：同一个客户反馈任务的三种上下文

假设任务是“分析最近一周客户反馈，给产品、工程和客服各出一版行动建议”。如果只写 prompt，模型容易把所有材料混在一起，生成一份看起来完整但难以执行的总结。

### 低质量上下文

```text
这里是最近一周所有客户反馈，请总结问题并给建议。
```

问题：

- 没有说明读者是谁。
- 没有说明哪些反馈可公开、哪些必须脱敏。
- 没有来源编号，后续无法追踪。
- 没有区分 bug、使用误解、性能问题和权限配置。
- 没有告诉模型哪些建议需要人工确认。

### 可试点上下文

```text
任务：把最近一周客户反馈整理成三版建议。
读者：产品负责人、工程负责人、客服主管。
资料范围：仅使用反馈编号 F-2026-05-01 到 F-2026-05-42。
禁止：不要输出客户姓名、手机号、合同金额和内部账号。
输出：每条结论必须带反馈编号；无法确认的写成“待核验”。
分类：bug、性能、权限配置、使用误解、功能请求。
人工确认：涉及退款、承诺交付日期、客户分级调整的建议必须标注“需要人工确认”。
```

这已经比普通 prompt 稳定，因为它开始定义资料、权限、输出和复核。

### 更成熟的上下文包

```yaml
task:
  goal: 生成产品、工程、客服三版客户反馈行动建议
  audience:
    - product
    - engineering
    - support
evidence:
  feedback_range: F-2026-05-01..F-2026-05-42
  source_fields:
    - feedback_id
    - date
    - channel
    - issue_type
    - severity
    - anonymized_excerpt
privacy:
  deny:
    - customer_name
    - phone
    - contract_amount
    - internal_account
rules:
  classification:
    - bug
    - performance
    - permission_config
    - usage_misunderstanding
    - feature_request
  cite_every_claim: true
  uncertain_label: 待核验
memory:
  allowed:
    - 上次复盘确认“导出慢”和“导出失败”不能合并
    - 管理层摘要不超过 10 条
  denied:
    - 具体客户身份
    - 未公开安全事件细节
review:
  human_gate:
    - refund
    - delivery_commitment
    - customer_tier_change
outputs:
  product: 按影响面、频次、战略价值排序
  engineering: 按可复现性、模块、测试建议排序
  support: 按话术、临时解决方案、升级条件排序
```

成熟上下文包的好处不是“更长”，而是让信息的来源、权限、读者、记忆和人工闸门都能检查。它也适合多 agent 协作：检索 agent 只负责证据层，分析 agent 只负责分类和排序，写作 agent 只负责生成面向不同读者的版本，审查 agent 只检查引用、脱敏和人工确认点。

## 与 RAG、Memory、Skill 的关系

| 概念 | 它解决什么 | 和 Context Engineering 的关系 |
| --- | --- | --- |
| RAG | 从知识库找资料 | 提供事实层上下文 |
| Memory | 保存跨会话经验 | 提供长期状态和偏好 |
| Skill | 打包可复用能力 | 提供流程、工具和边界 |
| Style Engineering | 保持风格一致 | 提供表达和人格约束 |
| Agent | 执行和推进任务 | 消费上下文，并产生新状态 |
| Context Engineering | 管理模型看到什么 | 把以上能力组织成下一步可用的信息环境 |

所以，Context Engineering 不是替代 RAG，而是把 RAG 放进更大的信息调度系统。

## 常见失败模式

| 失败模式 | 表现 | 修复 |
| --- | --- | --- |
| 全量塞入 | 把所有文档都丢进长上下文 | 检索、过滤、排序、摘要 |
| 只看最近 | 模型只跟随最后一段材料 | 提高规则层优先级，显式标注任务和证据 |
| 记忆污染 | 错误偏好或旧结论反复出现 | 记忆版本、删除机制、复核日志 |
| 证据断裂 | 输出结论找不到来源 | 引用片段、来源 URL、版本号 |
| 权限泄露 | agent 看到不该看的文件 | 权限过滤、上下文隔离、脱敏 |
| 上下文漂移 | 多轮后任务目标变了 | 任务状态卡、阶段性重述、人工确认 |

## 练习

选一个你正在做的真实任务，写一个最小上下文包：

```text
任务目标：
必须遵守的规则：
需要提供的资料：
不应该提供的资料：
需要保留的记忆：
需要使用的工具：
输出风格：
复核标准：
```

然后用同一个任务测试两次：一次只写 prompt，一次提供上下文包。比较两次输出的准确性、一致性和可复核性。

## 参考与复核说明

- [IBM: What is context engineering?](https://www.ibm.com/think/topics/context-engineering)：用于核验 context engineering 作为“设计、结构化和优化 LLM 上下文”的工程实践描述。
- [A Survey of Context Engineering for Large Language Models](https://arxiv.org/abs/2507.13334)：用于了解上下文工程作为研究方向的系统化整理。
- [OpenAI Prompting Guide](https://developers.openai.com/api/docs/guides/prompting)：用于核验 prompt、上下文、示例和评估相关官方实践。
- [Anthropic Agent Skills Overview](https://docs.claude.com/en/docs/agents-and-tools/agent-skills)：用于理解 skill 如何把能力、资源和脚本按需提供给 agent。

本页对 Context Engineering 的分层框架和六个动作是本书综合判断，不代表上述资料采用完全相同的分类。
