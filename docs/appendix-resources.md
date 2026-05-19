# 附录 A：资源与引用

最后核验：核心资料 2026-05-07；Context Engineering 补充资料 2026-05-18；Blackboard Architecture / Event Sourcing 补充资料 2026-05-19

本附录记录本书初版写作时核验过的关键资料。AI 领域变化很快，模型名称、接口、价格、许可证、可用地区、工具安全状况都可能变化。发布前和后续维护时，请优先复核官方文档、论文和标准组织资料。

## 学习和趋势报告

- [Stanford HAI 2026 AI Index Report](https://hai.stanford.edu/ai-index/2026-ai-index-report)：用于核验 2026 年 AI 能力、产业、教育、采用率和治理趋势。本书第 12 章的前沿全景主要参考其趋势框架。
- [Stanford HAI AI Index](https://hai.stanford.edu/ai-index)：AI Index 总入口，适合后续查年度更新。

维护建议：每年 AI Index 发布后，更新第 12 章和本附录。

## 模型与厂商官方文档

- [OpenAI Models](https://platform.openai.com/docs/models)：用于核验 OpenAI 当前模型、能力定位和 API 模型名称。
- [Anthropic Claude model overview](https://docs.anthropic.com/en/docs/about-claude/models/overview)：用于核验 Claude 模型家族、上下文、能力和适用场景。
- [Google Gemini API models](https://ai.google.dev/gemini-api/docs/models)：用于核验 Gemini 模型家族、多模态、上下文和开发者 API 信息。
- [DeepSeek API 文档](https://api-docs.deepseek.com/)：用于核验 DeepSeek 模型、API、价格和上下文等动态信息。
- [Alibaba Cloud Model Studio model list](https://www.alibabacloud.com/help/en/model-studio/user-guide/model/)：用于核验 Qwen/通义模型家族、模型名称和平台入口。
- [Moonshot AI 开放平台文档](https://platform.moonshot.cn/docs/intro)：用于核验 Kimi/Moonshot API、模型和开发者接入信息。
- [百度智能云千帆文档](https://cloud.baidu.com/doc/qianfan/index.html)：用于核验百度文心、千帆平台、模型和企业云能力。
- [智谱 GLM 模型概览](https://docs.bigmodel.cn/cn/guide/start/model-overview)：用于核验 GLM 模型家族、API 和平台能力。
- [腾讯云混元大模型文档](https://cloud.tencent.com/document/product/1729)：用于核验腾讯混元模型、API 和腾讯云生态能力。
- [Meta Llama](https://ai.meta.com/llama/)：用于核验 Llama 开放权重模型路线和官方入口。
- [Mistral AI model overview](https://docs.mistral.ai/getting-started/models/models_overview/)：用于核验 Mistral 模型、开放策略和企业 API 信息。
- [Cohere models](https://docs.cohere.com/docs/models)：用于核验 Cohere 模型、RAG、检索和企业应用能力。
- [xAI model documentation](https://docs.x.ai/developers/models)：用于核验 Grok/xAI 模型名称、上下文和 API 信息。

维护建议：模型概览页只写“截至 2026-05-07 的观察”。每次正式发布前，应重新核验模型名称、上下文长度、价格、工具能力、许可和可用地区，不要把旧模型名称写成长期有效事实。

## Prompt、工具调用和 Agent

- [OpenAI Prompting Guide](https://developers.openai.com/api/docs/guides/prompting)：用于核验提示词、复用 prompt、版本管理和评估等官方实践入口。
- [OpenAI Prompt engineering best practices for ChatGPT](https://help.openai.com/en/articles/10032626-prompt-engineering-best-practices-for-chatgpt)：用于核验清晰上下文、迭代、示例和语气控制等基础建议。
- [Anthropic Help Center: Configuring and Using Styles](https://support.anthropic.com/en/articles/10181068-configuring-and-using-styles)：用于核验 Claude 中“style”作为沟通方式定制能力的官方说明。
- [Claude Code Output Styles](https://docs.claude.com/en/docs/claude-code/output-styles)：用于核验输出样式可以改变 Claude Code 的系统提示词和项目级行为。
- [OpenAI Agents SDK](https://openai.github.io/openai-agents-python/)：用于核验 agent loop、tools、handoffs、guardrails、sessions、tracing、MCP 等概念。
- [OpenAI API Tools Guide](https://developers.openai.com/api/docs/guides/tools)：用于核验工具调用、Web search、file search、computer use、code interpreter、MCP/connectors、skills 等能力入口。
- [Anthropic Agent Skills Overview](https://docs.claude.com/en/docs/agents-and-tools/agent-skills)：用于核验 skills 的组成方式、按需加载、资源和脚本打包等概念。
- [The Prompt Report: A Systematic Survey of Prompting Techniques](https://arxiv.org/abs/2406.06608)：用于了解 prompt engineering 技术谱系、术语变化和相关研究分类。
- [IBM: What is context engineering?](https://www.ibm.com/think/topics/context-engineering)：用于核验 context engineering 作为设计、结构化和优化 LLM 上下文的工程实践描述。
- [A Survey of Context Engineering for Large Language Models](https://arxiv.org/abs/2507.13334)：用于了解上下文工程作为研究方向的系统化整理。该资料属于较新的研究综述，正文引用时应标注核验日期。
- [H. Penny Nii: The Blackboard Model of Problem Solving and the Evolution of Blackboard Architectures](https://doi.org/10.1609/aimag.v7i2.537)：用于核验黑板架构作为早期 AI 问题求解架构的经典来源。
- [Exploring Advanced LLM Multi-Agent Systems Based on Blackboard Architecture](https://arxiv.org/abs/2507.01701)：用于了解黑板架构在 LLM 多 agent 系统中的近期研究尝试。该资料为 2025 年预印本，应作为研究线索，不应写成行业标准。
- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)：用于核验事件溯源作为架构模式的经典解释。
- [Microsoft Learn: Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)：用于核验事件溯源的优势、权衡、快照和读模型等工程注意事项。

维护建议：涉及 OpenAI、Claude、Gemini、DeepSeek、Kimi 等具体产品能力时，不要只依赖书稿内容，应该重新打开官方文档核验。涉及 Style Engineering、Context Engineering、Blackboard Architecture、Event Sourcing、Personality Engineering、Cognitive Interface Design 等概念时，要明确区分“已有产品能力”“研究来源”“社区用法”“历史架构”“软件架构模式”和“本书推演”。

## AI 历史与基础论文

- [Attention Is All You Need](https://arxiv.org/abs/1706.03762)：用于核验 Transformer 架构在现代生成式 AI 历史中的基础地位。
- [Language Models are Few-Shot Learners](https://arxiv.org/abs/2005.14165)：用于理解大语言模型、少样本提示和通用语言能力的发展背景。

维护建议：历史章节可以保留长期稳定事实，但涉及“当前主流”“最新趋势”“正在兴起”等表述时仍要标注核验日期。

## 协议和互操作

- [Model Context Protocol 官方文档](https://modelcontextprotocol.io/docs/getting-started/intro)：用于核验 MCP 是连接 AI 应用与外部系统的开放标准，以及数据源、工具、工作流接入的定位。
- [Agent2Agent Protocol Specification](https://google-a2a.github.io/A2A/specification/)：用于核验 A2A 的 agent 互操作定位、Agent Card、消息和 artifact 等基本概念。
- [Google Open Source Blog: A2A anniversary](https://opensource.googleblog.com/2026/04/a-year-of-open-collaboration-celebrating-the-anniversary-of-a2a.html)：用于了解 A2A 生态发展动态。

维护建议：协议章节要特别注意版本号和兼容性。协议名称稳定，不代表实现细节稳定。

## OpenClaw、个人助手和安全

- [OpenClaw GitHub 仓库](https://github.com/openclaw/openclaw)：用于核验 OpenClaw 的官方项目入口和个人 AI 助手定位。
- [OpenClaw 官网](https://openclaw.my/)：用于核验项目官网和入口。
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)：用于核验 AI 风险管理框架、生成式 AI profile 和治理方向。

维护建议：OpenClaw 类 agent 项目权限很强，发布教程时不要只写安装和功能，也要写隔离、权限、凭据、日志、回滚和供应链风险。

## Hermes、HiMeS 和开源模型

- [Nous Research: Introducing Hermes 4.3](https://nousresearch.com/introducing-hermes-4-3)：用于核验 Hermes 4.3 的官方发布信息。
- [Nous Research Releases](https://nousresearch.com/releases/)：用于核验 Hermes 系列和 Nous 其他模型、agent 相关发布。
- [Hermes 4.3 36B on Hugging Face](https://huggingface.co/NousResearch/Hermes-4.3-36B)：用于核验模型卡、许可证、基础模型、工具调用和结构化输出标签。
- [HiMeS: Hippocampus-inspired Memory System for Personalized AI Assistants](https://arxiv.org/abs/2601.06152)：用于核验 HiMeS 作为个性化 AI 助手记忆系统研究的定位。

维护建议：开源模型要同时核验模型卡、许可证、技术报告、推理框架支持和社区反馈。不要只看榜单分数。

## 治理、安全和伦理

- [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework)：用于治理章节中的风险管理框架。
- [NIST AI 600-1: Generative AI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf)：用于生成式 AI 风险分类和组织治理参考。
- [OWASP Top 10 for LLM Applications](https://genai.owasp.org/llm-top-10/)：用于核验 LLM 应用中的 prompt injection、敏感信息泄露、供应链、权限和输出处理等风险类别。
- [MITRE ATLAS](https://atlas.mitre.org/)：用于核验 AI 系统对抗技术、战术和攻击知识库。
- [NCSC/CISA Guidelines for secure AI system development](https://www.ncsc.gov.uk/collection/guidelines-secure-ai-system-development)：用于核验安全 AI 系统开发、部署和运维的官方安全建议。
- [OpenAI Safety Best Practices](https://developers.openai.com/api/docs/guides/safety-best-practices)：用于核验应用安全检查思路。

维护建议：医疗、法律、金融、招聘、教育和公共服务等高风险场景，应单独查当地法规和行业规范。本书只提供学习和治理框架，不替代专业意见。涉及 agent、RAG、连接器、MCP、浏览器自动化和企业权限时，应同时核验应用层、数据层、工具层和流程层风险。

## 本书内部实践模板

- [Prompt 模式实践模板](../examples/prompt-patterns.md)
- [AI Skill/Card 可复用模板](../examples/skill-card-template.md)
- [Agent 工作流安全检查清单](../examples/agent-workflow-checklist.md)

## 本书内部延伸材料

- [AI 安全案例更新指南](safety-case-updates.md)
- [AI 安全事故复盘案例集](safety-incident-retrospectives.md)
- [中外 AI 模型特色概览](model-landscape-china-global.md)
- [AI 模型选型实战案例集](model-selection-cases.md)
- [前沿与过时技术案例库](technology-evolution-cases.md)
- [AI 安全与模型选型工作坊](workshop-safety-model-selection.md)

## 季度维护清单

执行流程请使用 [前沿资料季度复核执行手册](frontier-review-playbook.md)，详细复核记录请使用 [前沿资料季度复核记录表](frontier-review-log.md)。本清单只记录资料入口和维护提醒，复核证据、影响范围和处理动作应另行记录，方便发布前追溯。

- 检查上述链接是否仍然可访问。
- 更新第 12 章中的“截至日期”。
- 检查 OpenAI、Anthropic、Google、Nous、OpenClaw、MCP、A2A 的官方文档是否有重大变化。
- 检查 DeepSeek、Qwen、Kimi、百度千帆、智谱 GLM、腾讯混元、Meta Llama、Mistral、Cohere 和 xAI 的模型文档是否有重大变化。
- 检查 OWASP、NIST、MITRE 和 CISA 的 AI 安全建议是否有更新。
- 检查所有模型名称、许可证、工具能力和安全建议是否过时。
- 把新增变化记录到根目录 `MEMORY.md`。
