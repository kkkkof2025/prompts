# 术语写法规范

本页记录本书常用术语的推荐写法。维护者新增内容时，应优先使用这里的写法，避免同一概念在不同章节中出现多种拼写。

## 厂商、项目和协议

| 推荐写法 | 说明 |
| --- | --- |
| AI | 通用人工智能能力或系统的泛称 |
| ChatGPT | OpenAI 的聊天式产品名称 |
| Claude | Anthropic 的模型或产品名称 |
| Gemini | Google 的模型或产品名称 |
| DeepSeek | DeepSeek 的模型或产品名称 |
| Kimi | 月之暗面相关产品名称 |
| OpenAI | 公司和平台名称 |
| GitHub | 代码托管平台名称 |
| GitHub Pages | GitHub 静态站点发布能力 |
| OpenClaw | 个人 AI 助手和多通道 agent 工作台案例 |
| Hermes | Nous Research 的开源模型路线 |
| HiMeS | 个性化 AI 助手记忆系统研究 |
| MCP | Model Context Protocol |
| A2A | Agent2Agent 协议简称 |
| Agent2Agent | Google 推动的 agent 互操作协议名称 |
| Style Engineering | 风格工程；本书用于描述长期风格、审美、人格和输出约束的系统化实践 |
| Context Engineering | 上下文工程；本书用于描述模型行动前的上下文选择、排序、压缩、隔离和来源追踪 |
| Blackboard Architecture | 黑板架构；本书用于描述多 agent 围绕共享任务状态、证据、假设和决策协作的架构模型 |
| Event Sourcing | 事件溯源；本书用于描述把任务状态变化记录成可回放事件流的架构模式 |
| CQRS | 命令查询职责分离；本书用于描述多 agent 系统中写入事件和查询视图的职责分离 |
| Read Model | 读模型；为查询优化的状态视图，不作为事实源 |
| Projection | 投影；把事件流、写入模型或黑板状态转换成读模型的过程 |
| Materialized View | 物化视图；数据库预先计算并持久化的查询结果 |
| Transactional Outbox | 事务外箱；把业务写入和待发事件放进同一个事务的模式 |
| Idempotent Consumer | 幂等消费者；重复消息不会重复改变结果的消费端设计 |
| Inbox | 消费端去重表；记录已处理消息编号的表 |
| Saga | 补偿事务；把长流程拆成可补偿步骤的模式 |
| Process Manager | 流程协调器；负责 Saga 下一步命令和补偿的组件 |
| Compensation | 补偿动作；失败后用来恢复可接受状态的逆向操作 |
| Durable Execution | 持久化执行；长流程跨崩溃、重启、等待和回调继续运行的能力 |
| Durable Timer | 可持久化定时器；重启后仍能继续等待的定时机制 |
| AI Native | 原生围绕 AI 能力、上下文、工具和反馈回路设计的产品或创作方式 |

## 书内概念

| 推荐写法 | 说明 |
| --- | --- |
| prompt | 用户给 AI 的任务说明或指令 |
| skill | 可复用的领域能力包 |
| agent | 能规划、调用工具并推进任务的 AI 系统 |
| RAG | 检索增强生成 |
| 工具调用 | AI 调用外部函数、API、搜索、文件或代码执行能力 |
| 记忆系统 | 用于保存偏好、事实、历史和工作状态的机制 |
| 验收标准 | 判断输出是否能进入下一步的标准 |
| 人工复核 | 人对高风险或不确定输出进行检查和确认 |

## 维护规则

- 英文缩写保持稳定，不随句首句中改变大小写。
- 同一章内第一次出现复杂术语时，优先补一句白话解释。
- 涉及快速变化的模型能力、工具能力和接口名称时，在 [资源与引用](appendix-resources.md) 中保留核验来源。
- 如果读者反馈某个术语不易懂，优先补例子，而不是只增加定义。
