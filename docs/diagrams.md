# 图解：AI 工作系统

这些图用 Mermaid 描述。GitHub 仓库页面通常可以直接渲染 Mermaid；如果在 GitHub Pages 上没有渲染，也可以把代码复制到 Mermaid Live Editor 或支持 Mermaid 的 Markdown 工具中查看。

## 从对话到 Agent

```mermaid
flowchart LR
    A[基础对话] --> B[Prompt 模板]
    B --> C[结构化工作流]
    C --> D[Skill]
    D --> E[Agent]
    E --> F[带工具和记忆的 AI 工作系统]
```

理解方式：

- 基础对话解决“说清楚”。
- Prompt 模板解决“重复问得稳定”。
- 工作流解决“复杂任务分步骤”。
- Skill 解决“把经验固化”。
- Agent 解决“在边界内行动”。

## 好 Prompt 的结构

```mermaid
flowchart TD
    P[好 Prompt] --> G[目标]
    P --> C[背景]
    P --> R[约束]
    P --> O[输出格式]
    P --> E[验收标准]
    P --> Q[信息不足时先提问]
```

## RAG 基本流程

```mermaid
flowchart LR
    U[用户问题] --> Q[查询改写]
    Q --> R[检索知识库]
    R --> S[排序和筛选]
    S --> C[注入上下文]
    C --> M[模型生成回答]
    M --> A[带引用的答案]
    A --> V[人工或自动核验]
```

关键检查点：

- 检索是否找到正确资料。
- 上下文是否足够完整。
- 回答是否标注来源。
- 知识库资料是否过时。

## Agent 基本循环

```mermaid
flowchart TD
    Goal[目标] --> Plan[计划]
    Plan --> Act[行动]
    Act --> Obs[观察结果]
    Obs --> Check{是否满足验收标准}
    Check -- 否 --> Reflect[反思和修正]
    Reflect --> Plan
    Check -- 是 --> Done[完成并总结]
```

Agent 的关键不是“自动做更多事”，而是每一步都能被观察、限制和验证。

## Skill 的组成

```mermaid
flowchart TD
    S[Skill] --> N[名称和用途]
    S --> T[触发场景]
    S --> I[输入要求]
    S --> W[工作流程]
    S --> O[输出格式]
    S --> B[边界]
    S --> E[验收标准]
    S --> X[示例和失败案例]
```

## 记忆系统

```mermaid
flowchart LR
    Input[当前对话] --> Extract[提取候选记忆]
    Extract --> Filter{是否长期有用且非敏感}
    Filter -- 否 --> Drop[不保存]
    Filter -- 是 --> Store[写入记忆库]
    Store --> Retrieve[按任务检索]
    Retrieve --> Context[注入当前上下文]
    Context --> Answer[生成回答]
    Store --> Review[定期审查和删除]
```

记忆不是越多越好。好的记忆系统必须能写入、检索、更新和遗忘。

## 权限与治理

```mermaid
flowchart TD
    Task[AI 任务] --> Risk{风险等级}
    Risk -- 低 --> Auto[允许自动执行]
    Risk -- 中 --> Log[执行并记录日志]
    Risk -- 高 --> Human[人工确认]
    Risk -- 禁止 --> Block[阻止]

    Human --> Action[执行动作]
    Action --> Audit[审计记录]
    Log --> Audit
    Auto --> Audit
```

高风险动作包括删除文件、发送邮件、付款、发布内容、改变权限、处理敏感数据。

## 个人 AI 学习系统

```mermaid
flowchart LR
    Learn[学习章节] --> Practice[完成练习]
    Practice --> Template[保存模板]
    Template --> Skill[形成 Skill]
    Skill --> Workflow[纳入工作流]
    Workflow --> Evaluate[评估效果]
    Evaluate --> Memory[记录经验]
    Memory --> Learn
```

这本书的目标不是让你读完所有概念，而是让你建立一个会持续改进的个人 AI 使用系统。
