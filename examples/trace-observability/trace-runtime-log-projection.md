# 多语言运行日志投影与失败回放样例

最后核验：2026-05-20

这页接在 [多语言运行日志回放样例](trace-runtime-log-replay.md) 后面。前一页回答“人怎么读 runtime log”；这一页回答另一个更工程化的问题：

```text
runtime log 如果要进日志平台、看板或失败队列，应该怎么投影？
```

这里的“投影”不是把整份日志再复制一遍，而是把运行日志压成更容易检索、过滤和聚合的视图。它和 OpenTelemetry Logs 的关系也可以这样理解：

```text
OpenTelemetry Logs = 标准化日志信号
runtime log projection = 本书里的受控投影视图
```

## 文件

- `trace_runtime_log_bridge.py`：生成正常或 broken handoff 的 runtime log。
- `trace_runtime_log_projection.py`：把 runtime log 展平成可检索索引和失败队列。
- `trace-runtime-log-replay.md`：讲解 runtime log 的阅读和过滤。

## 投影目标

一个 runtime log 投影，至少应该回答三件事：

1. 这次运行是否成功。
2. 哪些步骤失败或警告。
3. 需要回头看哪条 trace、哪份 artifact。

所以投影结果通常分成三层：

- `summary`：给人先看总览。
- `runtime_log_index`：给搜索、过滤和列表页用。
- `failure_queue`：给复盘、告警和人工处理用。

## 正常投影

先生成 runtime log：

```powershell
python examples/trace-observability/trace_runtime_log_bridge.py --output tmp/trace-runtime-log.json
```

再投影成索引：

```powershell
python examples/trace-observability/trace_runtime_log_projection.py --input tmp/trace-runtime-log.json --output tmp/trace-runtime-log-projected.json
```

投影后的输出会包含：

- `summary.runtime_counts`
- `summary.event_type_counts`
- `summary.status_counts`
- `runtime_log_index`
- `failure_queue`

你可以这样看 summary：

```powershell
$projected = Get-Content tmp/trace-runtime-log-projected.json -Raw | ConvertFrom-Json
$projected.summary | Format-List
```

如果只想看 Node.js 侧记录：

```powershell
$projected.runtime_log_index | Where-Object runtime -eq 'nodejs' | Format-Table timestamp, actor, span_name, status, trace_id
```

## 失败回放

现在让 handoff 故意断掉：

```powershell
python examples/trace-observability/trace_runtime_log_bridge.py --simulate-broken-handoff --output tmp/trace-runtime-log-broken.json
python examples/trace-observability/trace_runtime_log_projection.py --input tmp/trace-runtime-log-broken.json --output tmp/trace-runtime-log-broken-projected.json
```

这时你会得到一条明确的失败队列。关键字段通常是：

- `same_trace = false`
- `parent_linked = false`
- `handoff_mode = broken`

如果你只关心失败项，可以直接只投影失败视图：

```powershell
python examples/trace-observability/trace_runtime_log_projection.py --input tmp/trace-runtime-log-broken.json --fail-only
```

## 这和日志平台的关系

如果把这套东西放进日志平台，通常会有两步：

1. 把 `runtime_log_index` 当成受控日志事件。
2. 把 `failure_queue` 当成告警和人工复盘入口。

OpenTelemetry Logs 的官方文档说明，logs 也是可观测性信号之一，并且可以和 traces、metrics 一起用。对本书来说，runtime log projection 是一层更具体的工程化投影：

- 它保留 `trace_id`、`span_id`、`task_id` 和 `artifact_ref`。
- 它避免把完整 prompt、原始 stdout、密钥和私有资料直接写进日志平台。
- 它让课堂、排障和团队试点都能先用同一套字段。

## 失败队列应该长什么样

一个失败队列记录通常至少要有：

| 字段 | 作用 |
| --- | --- |
| `task_id` | 回到任务 |
| `trace_id` | 回到链路 |
| `runtime` | 说明失败发生在哪个运行时 |
| `event_type` | 区分 span、handoff、check |
| `status` | 标示出错或警告 |
| `reason` | 说明为什么进入失败队列 |
| `artifact_ref` | 回到受控证据 |

如果失败队列里没有 `reason`，排障时就只能再读一遍整条日志。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry Logs 文档说明 logs 是可观测性信号之一，并且与 traces、metrics 并列。
- OpenTelemetry 的日志语义和上下文传播方向支持把 log record 和 trace/span 做关联。
- W3C Trace Context 仍然是跨系统传播 `traceparent` 的标准基础。

本书判断：

- runtime log projection 适合做日志平台的受控投影，而不是再造一个事实源。
- 失败队列比原始日志更适合团队复盘，因为它把需要人处理的记录单独挑出来。

推演：

- 更成熟的 OpenClaw 类系统会把 runtime log 自动投影到日志平台、失败队列和复盘看板，形成“运行-检索-复盘”一体链路。

## 参考与复核说明

- [OpenTelemetry Logs](https://opentelemetry.io/docs/concepts/signals/logs/)：用于核验 logs 作为可观测性信号的官方说明。
- [OpenTelemetry Traces](https://opentelemetry.io/docs/concepts/signals/traces/)：用于核验 trace 和 span 的基本概念。
- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于核验 `traceparent` 的跨系统传播格式。

