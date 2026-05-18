# Style Engineering 与 AI Native 创作

最后核验：2026-05-18

这篇来自一条很重要的观察：AI 的下一阶段不只是“会写更好的 prompt”，而是“能不能把风格、人格、约束、审美和工作流做成可复用系统”。这里把它称为 **Style Engineering**，中文可以叫“风格工程”。

需要先说明边界：Style Engineering 不是一个已经有统一标准的行业术语。它更像本书对一组正在形成的实践的整理：系统提示词、项目规则文件、品牌规范、输出样式、写作风格、视觉语法、角色设定、世界观设定、agent 行为约束和长期记忆正在合流。

如果只记一句话，可以记成：

```text
Prompt 解决一次生成，Style Engineering 解决长期一致。
```

## 从 Prompt 到 Style

Prompt Engineering 的核心是“怎样让模型完成这次任务”。Style Engineering 的核心是“怎样让模型持续像同一个系统一样创作、表达和行动”。

| 阶段 | 关注点 | 典型文件或形态 | 主要问题 |
| --- | --- | --- | --- |
| Prompt Engineering | 单次指令 | prompt、few-shot 示例 | 这次怎么写对 |
| Workflow Engineering | 多步任务 | SOP、工作流配方、检查清单 | 过程怎么稳定 |
| Context Engineering | 上下文组织 | RAG、记忆、项目规则、上下文包 | 相关信息怎么进来 |
| Style Engineering | 风格和审美约束 | STYLE.md、DESIGN.md、BRAND.md、WRITER.md | 输出怎么长期一致 |
| Personality Engineering | 人格和行为约束 | CHARACTER.md、AGENTS.md、角色卡、行为协议 | 助手怎么稳定像自己 |
| Cognitive System Design | 认知系统设计 | 任务内核、记忆层、权限层、反馈层 | 多个能力怎么组成系统 |

这条路线不是说 prompt 会消失，而是 prompt 会从“全部能力入口”退回到“系统中的一个接口”。真正关键的会变成：约束文件、评估样例、记忆策略、工具权限和反馈回路。

## 本质：用语言控制生成系统

Style Engineering 的底层能力是“用结构化语言约束模型的输出空间”。它不只适用于 AI 绘图，也适用于：

- 写作：语气、句法、节奏、意象和论证密度。
- UI：颜色、间距、组件气质、交互模式和文案风格。
- 视频：镜头语言、节奏、转场、色调和叙事结构。
- 音乐：情绪、速度、乐器、段落和混音气质。
- 游戏：世界观、角色关系、物品逻辑和任务风格。
- Agent：人格、风险偏好、工具使用方式、复核习惯和输出格式。
- 品牌：价值主张、禁用表达、视觉符号、内容边界和用户体验。

也就是说，它不是“让模型更听话”的技巧，而是“把模糊审美结构化”的方法。

## 一个 Style System 应该包含什么

| 模块 | 解决的问题 | 示例 |
| --- | --- | --- |
| Voice | 它说话像谁 | 冷静、克制、专业、幽默、温柔 |
| Rhythm | 它的节奏是什么 | 短句密集、长句舒展、先结论后解释 |
| Visual Grammar | 它的视觉语法是什么 | 色彩、构图、材质、光线、镜头 |
| Symbol System | 它反复使用哪些符号 | 雨、霓虹、混凝土、档案、地图 |
| Output Shape | 它输出什么结构 | 摘要、表格、清单、决策树、报告 |
| Avoid List | 它不该做什么 | 不鸡汤、不夸张、不套话、不编来源 |
| Memory Bias | 它优先记住什么 | 项目原则、术语、风格样例、失败模式 |
| Evaluation | 怎样判断它是否符合风格 | 样例对照、rubric、人工评分 |

没有 Evaluation 的 Style Engineering 很容易变成“感觉不错”。真正能复用的风格系统必须有样例和验收标准。

## 示例：Writer.md

下面不是固定格式，而是一种可复制的写作风格配置：

```yaml
WRITING_STYLE:
  tone:
    - restrained
    - analytical
    - slightly melancholic
  sentence_structure:
    - clear topic sentence
    - medium length explanations
    - occasional short emphasis sentence
  avoid:
    - motivational slogan
    - exaggerated positivity
    - generic AI transition
    - unsourced factual claim
  imagery:
    - urban loneliness
    - industrial order
    - modern alienation
  argument_style:
    - define boundary first
    - separate fact, inference, and recommendation
    - end with actionable checklist
  density: high
```

如果把这段放进一次 prompt，它只是提示词。如果把它放进项目规则、评估样例和长期工作流，它就开始变成 Style Engineering。

## 示例：DESIGN.md

```yaml
DESIGN_SYSTEM:
  visual_identity:
    - quiet operational interface
    - clear hierarchy
    - dense but readable layout
  color:
    primary: deep blue
    accent: green
    avoid:
      - one-note purple gradient
      - decorative bokeh
      - low-contrast gray text
  layout:
    - use grids for repeated items
    - keep cards for repeated records only
    - avoid cards inside cards
  interaction:
    - icon buttons for tools
    - tabs for views
    - toggles for binary settings
    - search always visible for large content
  evaluation:
    - text must not overflow on mobile
    - primary workflow visible in first screen
    - no feature explanation text inside the app
```

这类文件对 AI 前端生成特别有价值，因为它把“好看一点”变成了可执行的视觉约束。

## 四类可复用风格文件

Style Engineering 不能只停留在概念。下面四类文件可以直接放进一个 AI Native 项目里，分别约束写作、品牌、界面和 agent 行为。

### STYLE.md：项目统一风格

```yaml
STYLE:
  purpose: 让所有输出保持同一套表达和审美边界
  audience:
    - 普通学习者
    - 产品经理
    - 工程师
  voice:
    - 清楚
    - 克制
    - 具体
  must_do:
    - 先解释问题，再给方法
    - 区分事实、判断和建议
    - 给出可执行例子
  must_avoid:
    - 夸张营销词
    - 空泛鼓励
    - 未核验来源
  evaluation:
    - 初学者能否复述核心观点
    - 专业读者能否看到边界和风险
```

### BRAND.md：品牌与产品表达

```yaml
BRAND:
  position: 安静、可靠、可长期维护的 AI 学习系统
  promise:
    - 帮读者建立方法
    - 不制造万能幻觉
    - 给出边界和复核路径
  forbidden_claims:
    - 最强
    - 一键替代所有工作
    - 永不过时
  visual_keywords:
    - 清晰
    - 稳定
    - 有结构
  content_keywords:
    - 任务
    - 证据
    - 复核
    - 权限
    - 迭代
```

### WRITER.md：写作人格

```yaml
WRITER:
  default_structure:
    - 先给一句结论
    - 再解释原因
    - 再给表格或清单
    - 最后给练习或检查项
  tone:
    - senior engineer
    - teacher
    - editor
  sentence_rules:
    - 不堆术语
    - 不连续使用抽象名词
    - 每个新概念至少给一个例子
  citation_rules:
    - 动态事实必须标注来源
    - 推演必须标注为本书判断
```

### AGENTS.md：行动风格

```yaml
AGENTS:
  action_style:
    - 小步执行
    - 先读上下文
    - 修改前说明计划
    - 修改后跑检查
  risk_policy:
    low_risk: 可以自动执行并记录日志
    medium_risk: 先给计划，再执行
    high_risk: 必须人工批准
  memory_policy:
    remember:
      - 用户明确偏好
      - 项目长期规则
      - 失败复盘
    do_not_remember:
      - 临时情绪
      - 未确认事实
      - 敏感凭据
```

这四个文件可以组合使用：`STYLE.md` 管表达，`BRAND.md` 管价值和禁区，`WRITER.md` 管文本结构，`AGENTS.md` 管行动边界。它们共同构成一个最小风格运行时。

## Style Engineering 和 Agent 的关系

当 agent 能调用工具、改文件、发消息、连接云文档时，风格不再只是表达问题，而是行为问题。

| 层面 | 风格约束的作用 |
| --- | --- |
| 表达风格 | 输出是否稳定、可读、符合品牌 |
| 行动风格 | agent 是保守、激进、探索式还是审计式 |
| 复核风格 | 是否先找证据、是否标注不确定性 |
| 协作风格 | 是否主动同步状态、是否尊重任务锁 |
| 记忆风格 | 记住原则还是记住碎片，保留偏好还是保留证据 |

所以未来的 `STYLE.md` 很可能会和 `AGENTS.md`、`MEMORY.md`、`POLICY.md` 组合在一起。前者规定“怎么表达”，后者规定“怎么行动”。

## 风格工程的失败模式

| 失败模式 | 表现 | 修复 |
| --- | --- | --- |
| 只有形容词 | “高级、克制、有质感”但没有样例 | 补正例、反例和评分表 |
| 约束过多 | 模型每次都僵硬重复 | 区分硬规则和软偏好 |
| 风格压过事实 | 文章漂亮但内容不准 | 强制来源、核验日期和不确定性标注 |
| 审美孤岛 | 视觉、文案、agent 行为互相冲突 | 做统一 Style System |
| 不能迁移 | 只适合某一个 prompt | 抽象成模块和文件 |

## 和本书其他概念的连接

- 第 3 章讲 prompt，解决“单次输入”。
- 第 4 章讲工作流，解决“多步过程”。
- 第 7 章讲 skill，解决“能力打包”。
- 第 8-9 章讲 agent 和 memory，解决“行动和延续”。
- 本篇讲 Style Engineering，解决“长期一致的表达、审美和行为约束”。
- [OpenClaw、Node.js 与超级大脑架构](openclaw-superbrain-architecture.md) 讲系统层，解决“多个能力如何进入统一认知系统”。

## 练习

为你自己的项目写一个最小 `STYLE.md`：

```yaml
PROJECT_STYLE:
  target_reader:
  voice:
  must_have:
  must_avoid:
  examples_good:
  examples_bad:
  evaluation:
```

然后用同一个任务测试三次：没有 `STYLE.md`、使用 `STYLE.md`、使用 `STYLE.md + 反例`。如果第三次明显更稳定，说明你已经从 prompt 进入了风格工程。

## 参考与复核说明

以下资料用于核验“prompt、风格、输出样式和长期约束文件正在变成产品能力”这件事。Style Engineering 这个组合概念是本书的综合判断，不代表这些资料已经使用同一个术语。

- [OpenAI Prompting Guide](https://platform.openai.com/docs/guides/prompting)：用于核验提示词、复用 prompt、版本和评估的官方实践入口。
- [OpenAI Prompt engineering best practices for ChatGPT](https://help.openai.com/en/articles/10032626-prompt-engineering-best-practices-for-chatgpt)：用于核验清晰上下文、迭代和语气控制等基础建议。
- [Anthropic Help Center: Configuring and Using Styles](https://support.anthropic.com/en/articles/10181068-configuring-and-using-styles)：用于核验 Claude 中“style”作为交流方式定制能力的官方说明。
- [Claude Code Output Styles](https://docs.claude.com/en/docs/claude-code/output-styles)：用于核验输出样式可以改变 Claude Code 的系统提示词和项目级行为。
- [The Prompt Report: A Systematic Survey of Prompting Techniques](https://arxiv.org/abs/2406.06608)：用于了解 prompt engineering 技术谱系和术语仍在演化的研究背景。
