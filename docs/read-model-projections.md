# Read Model 与 Projection：读模型与投影

最后核验：2026-05-19

读模型是为查询而生的状态视图，Projection 是把事件、写入模型或黑板状态转换成读模型的过程。

如果只记一句话，可以记成：

```text
事件流记录发生了什么，Projection 负责翻译，Read Model 负责让人和 agent 快速看懂现在怎样。
```

这页是 [CQRS：读写分离与多 agent 查询视图](cqrs.md) 的实现补充。CQRS 解释为什么读写要分开；本页解释读模型和投影怎么落到 SQLite、看板、云文档或物化视图里。

## 基本术语

| 术语 | 白话解释 | 在多 agent 系统里的角色 |
| --- | --- | --- |
| Write Model | 写入模型，负责校验命令和改变事实 | 判断任务能不能被创建、认领、批准、发布 |
| Event Log | 事件日志，记录发生过的状态变化 | 保存 `task_created`、`approved`、`published` 等事实 |
| Projection | 投影，把事实翻译成查询视图的逻辑 | 从事件流更新 `tasks_current`、`agent_workload` |
| Read Model | 读模型，为查询优化的当前视图 | 给人、调度器、复核 agent 快速查询 |
| Materialized View | 物化视图，提前计算并持久化的查询结果 | 适合高频看板、统计页、审批列表 |
| Checkpoint | 投影进度点 | 记录已经处理到哪个事件，失败后继续 |

注意：读模型不是事实源。事实源通常是命令写入后的业务数据、事件流或经过治理的黑板记录。读模型可以删掉重建，事实源不能随便丢。

## 为什么不直接查事件流

事件流适合审计和回放，但不适合每次都拿来回答当前状态。

例如你要回答：

```text
现在有哪些任务等待人工审批？
哪个 agent 手里有超过 3 个活跃任务？
最近 24 小时失败最多的任务类型是什么？
哪些章节草稿已经写完但缺引用？
```

如果每次都从第一条事件开始回放，系统会越来越慢。Projection 的作用，就是把历史事件持续折叠成当前视图。

```text
Event Log -> Projection -> Read Model -> Query
```

## 一个最小 SQLite 读模型

SQLite 很适合个人工作台、OpenClaw 原型、本地 CLI 协作和小团队试点。它不需要先上复杂消息队列，也能把“事件流”和“当前视图”分开。

### 事件表

```sql
CREATE TABLE task_events (
  event_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  actor TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE INDEX idx_task_events_task_id ON task_events(task_id);
CREATE INDEX idx_task_events_created_at ON task_events(created_at);
```

这张表只追加，不直接改旧事件。它回答“发生过什么”。

### 当前任务读模型

```sql
CREATE TABLE tasks_current (
  task_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT NOT NULL,
  owner TEXT,
  priority INTEGER NOT NULL DEFAULT 3,
  risk_level TEXT NOT NULL DEFAULT 'medium',
  blocker TEXT,
  last_event_id TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE INDEX idx_tasks_current_status ON tasks_current(status);
CREATE INDEX idx_tasks_current_owner ON tasks_current(owner);
CREATE INDEX idx_tasks_current_risk ON tasks_current(risk_level);
```

这张表回答“现在怎样”。

### agent 工作量读模型

```sql
CREATE TABLE agent_workload (
  agent_id TEXT PRIMARY KEY,
  active_tasks INTEGER NOT NULL DEFAULT 0,
  blocked_tasks INTEGER NOT NULL DEFAULT 0,
  waiting_review_tasks INTEGER NOT NULL DEFAULT 0,
  last_event_id TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

这张表回答“谁忙、谁卡住、谁适合接下一个任务”。

### 投影进度表

```sql
CREATE TABLE projection_checkpoints (
  projection_name TEXT PRIMARY KEY,
  last_event_id TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

这张表回答“投影已经处理到哪里”。

## Projection 怎么更新读模型

Projection 可以写成一段普通代码。它读事件，按事件类型更新对应读模型。

```text
for event in task_events after checkpoint:
    if event.type == "task_created":
        upsert tasks_current
    if event.type == "task_claimed":
        update owner and status
    if event.type == "review_blocked":
        update status and blocker
    if event.type == "approved":
        update status
    update projection checkpoint
```

用 SQLite 表示时，核心动作是 upsert：

```sql
INSERT INTO tasks_current (
  task_id,
  title,
  status,
  owner,
  priority,
  risk_level,
  blocker,
  last_event_id,
  updated_at
) VALUES (
  :task_id,
  :title,
  :status,
  :owner,
  :priority,
  :risk_level,
  :blocker,
  :event_id,
  :created_at
)
ON CONFLICT(task_id) DO UPDATE SET
  title = excluded.title,
  status = excluded.status,
  owner = excluded.owner,
  priority = excluded.priority,
  risk_level = excluded.risk_level,
  blocker = excluded.blocker,
  last_event_id = excluded.last_event_id,
  updated_at = excluded.updated_at;
```

这里的重点不是 SQL 技巧，而是职责分离：写入侧只负责产生可信事件；读模型侧只负责把事件整理成好查的状态。

## 常用查询视图

有了读模型，很多查询会变得直接。

### 待人工审批任务

```sql
SELECT task_id, title, owner, priority, risk_level, updated_at
FROM tasks_current
WHERE status = 'waiting_approval'
ORDER BY risk_level DESC, priority ASC, updated_at ASC;
```

### 阻塞任务

```sql
SELECT task_id, title, owner, blocker, updated_at
FROM tasks_current
WHERE status = 'blocked'
ORDER BY updated_at ASC;
```

### agent 工作量

```sql
SELECT agent_id, active_tasks, blocked_tasks, waiting_review_tasks
FROM agent_workload
ORDER BY active_tasks DESC, blocked_tasks DESC;
```

### 可显示给人的看板视图

SQLite 原生支持普通 view，可以把常用查询固定下来：

```sql
CREATE VIEW tasks_waiting_approval AS
SELECT task_id, title, owner, priority, risk_level, updated_at
FROM tasks_current
WHERE status = 'waiting_approval';
```

普通 view 不会提前保存结果。它适合轻量筛选。真正高频、跨表、需要快速展示的看板，更适合用投影代码维护一张读模型表。

## 物化视图和读模型的区别

物化视图可以理解成“数据库层面的预计算查询结果”。PostgreSQL 这类数据库原生支持 materialized view；SQLite 没有同等的原生物化视图，一般用普通表加投影任务来模拟。

| 方式 | 适合 | 优点 | 风险 |
| --- | --- | --- | --- |
| 普通 View | 简单筛选和轻量查询 | 不存重复数据，定义清楚 | 每次查询仍要计算 |
| 读模型表 | 多 agent 任务状态、看板、审批列表 | 查询快，结构可为页面优化 | 需要投影同步和重建机制 |
| 数据库 Materialized View | 大型报表、复杂聚合 | 由数据库管理预计算结果 | 刷新策略、锁和延迟要设计 |
| 搜索索引 | 全文搜索、语义检索、日志搜索 | 搜索体验好 | 不适合作为事实源 |

在本书的 OpenClaw 原型里，最推荐的起步方式是：

```text
JSONL 事件流 + SQLite 读模型表 + Markdown/云文档展示
```

这足够简单，也保留了后续升级到消息队列、PostgreSQL、搜索索引或云表格的空间。

## Projection 刷新策略

不同任务对新鲜度要求不同。不要把所有视图都当成强一致实时系统。

| 策略 | 怎么做 | 适合场景 | 代价 |
| --- | --- | --- | --- |
| 同步更新 | command 成功后立刻更新读模型 | 小系统、关键审批、单机 CLI | 写入变慢，失败处理更麻烦 |
| 异步更新 | 事件先写入，后台 worker 更新读模型 | 多 agent、看板、统计 | 读模型会短暂落后 |
| 定时刷新 | 每分钟或每小时批量更新 | 日报、周报、低频统计 | 延迟较明显 |
| 按需重建 | 查询前发现过期再刷新 | 低频视图、维护工具 | 首次查询可能慢 |
| 全量回放 | 清空读模型，从事件流重建 | 修复投影 bug、迁移结构 | 需要停机或影子构建 |

一个实用默认值：

```text
审批和发布视图：同步或短延迟异步。
任务看板：异步，允许几秒延迟。
统计报表：定时刷新。
修复和迁移：全量回放。
```

## 最终一致怎么处理

CQRS 和 Projection 常会带来最终一致。最终一致不是错误，但必须在界面、任务流和复核规则里说清楚。

### 需要显示投影进度

每个重要读模型都应该知道自己处理到了哪个事件：

```text
tasks_current 已更新到 event_id=evt-20260519-1850
agent_workload 已更新到 event_id=evt-20260519-1843
```

如果看板落后，就显示“正在同步”或“数据可能延迟”，而不是假装实时。

### 写后读要分级

| 场景 | 处理方式 |
| --- | --- |
| 用户刚批准发布 | 等待关键读模型更新后再显示成功 |
| agent 写入草稿证据 | 可以异步更新，界面显示同步状态 |
| 统计最近 24 小时失败数 | 允许分钟级延迟 |
| 安全风险清单 | 延迟要短，并保留人工复核入口 |

### 投影必须幂等

同一个事件被重复处理时，结果不应该重复累加。常见做法是：

- 每个读模型记录 `last_event_id` 或已处理事件表。
- 事件有全局唯一 `event_id`。
- 更新语句按 `task_id`、`agent_id` 等自然键 upsert。
- 对计数类读模型要特别小心，必要时从任务当前状态重算，而不是盲目 `+1`。

## 失败和重建

Projection 一定会失败：事件格式变了、字段缺失、代码 bug、读模型结构迁移、并发写入冲突，都可能发生。

最小恢复流程：

```text
1. 停止 projection worker。
2. 记录失败事件 event_id 和错误原因。
3. 修复投影逻辑或数据迁移。
4. 清空受影响读模型。
5. 从事件流按顺序回放。
6. 对比重建前后关键统计。
7. 恢复 worker。
```

建议保留一张失败事件表：

```sql
CREATE TABLE projection_failures (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  projection_name TEXT NOT NULL,
  event_id TEXT NOT NULL,
  error_message TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

这不是为了责备某个 agent，而是为了让系统能解释自己为什么不同步。

## 和黑板架构的关系

[Blackboard Architecture：黑板架构与多 agent 协作](blackboard-architecture-multi-agent.md) 负责共享任务现场，读模型负责把现场整理成不同视角。

一个更清楚的分工是：

```text
事件流：事实历史
黑板：协作现场
读模型：查询视图
Projection：从事实到视图的翻译器
Context Engineering：从视图中挑选本轮需要给模型看的上下文
```

不要让所有 agent 同时改同一个 Markdown 看板。更稳的方式是：agent 只提交命令或事件，Projection 更新读模型，人看到的是读模型生成的看板。

## OpenClaw 任务系统样例

假设你要做一个“书稿维护超级大脑”，可以至少准备四个读模型：

| 读模型 | 查询问题 | 给谁看 |
| --- | --- | --- |
| `tasks_current` | 每个任务现在到哪一步了 | 人、调度器、OpenClaw |
| `chapter_status` | 哪些章节缺案例、引用、练习或复核 | 写作 agent、编辑 |
| `agent_workload` | 哪个 agent 正在忙，谁适合接任务 | 调度器 |
| `risk_queue` | 哪些任务涉及安全、授权、隐私和事实核验 | 复核 agent、人 |

最小任务流：

```text
human creates task
  -> event: task_created
writer-agent claims task
  -> event: task_claimed
writer-agent writes draft
  -> event: draft_written
review-agent checks sources
  -> event: review_finished
human approves
  -> event: approved
publisher writes to Git
  -> event: published
```

Projection 每处理一条事件，就更新对应读模型。于是人不用翻所有日志，也能看到“当前哪些任务该我处理”。

## 什么时候不用它

不要因为概念漂亮就把读模型和投影强行塞进所有系统。

不建议使用的情况：

- 只有一个人、一个 agent、一个任务文件。
- 只是写一次性文章，没有状态机和审计要求。
- 查询问题很简单，普通表或 Markdown 已经够用。
- 团队还没有能力处理投影失败和重建。

建议使用的情况：

- 任务会跨多个 agent、多个工具和多天执行。
- 需要审计、回放和重新生成当前状态。
- 看板、审批、统计、搜索的查询结构明显不同。
- 人和 agent 都依赖“当前状态”做下一步决策。

## 练习

把你正在维护的一个项目按下面格式拆一次：

```text
事实源是什么：
事件流记录哪些事件：
第一个读模型叫什么：
它回答哪个查询问题：
Projection 由谁触发：
可以接受多大延迟：
投影失败后怎么重建：
哪些查询不能依赖延迟视图：
```

如果你写不出“它回答哪个查询问题”，说明这个读模型暂时不该建。

## 参考与复核说明

- [Microsoft Learn: CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)：用于核验 read model、materialized view、最终一致和读写模型分离的工程说明。
- [Microsoft Learn: Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)：用于核验事件溯源与读模型、快照和回放的关系。
- [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html)：用于核验 CQRS 的基本边界和复杂度提醒。
- [SQLite UPSERT](https://sqlite.org/lang_upsert.html)：用于核验 SQLite `ON CONFLICT ... DO UPDATE` 示例语法。
- [SQLite CREATE VIEW](https://www.sqlite.org/lang_createview.html)：用于核验 SQLite 普通 view 的语法边界。
- [PostgreSQL Materialized Views](https://www.postgresql.org/docs/current/rules-materializedviews.html)：用于核验数据库原生 materialized view 的基本概念。

本页把读模型、Projection、SQLite 和 OpenClaw 多 agent 任务系统连在一起，是本书的工程化推演。Projection 和 materialized view 本身不是 AI 专属概念。
