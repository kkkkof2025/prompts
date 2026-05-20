# 多语言运行日志回放样例

最后核验：2026-05-20

这页接在 [多语言 Trace Context 传播样例](trace-context-multilang.md) 后面。前一页回答“Python 和 Node.js 如何保持同一条 trace”；这一页回答另一个更接地气的问题：

```text
如果我想把跨语言 handoff 记录成一条人能读的运行日志，应该长什么样？
```

这里的“运行日志”不是业务事实事件，也不是 trace backend 的完整索引，而是把 Python 和 Node.js 两个 runtime 的 span、handoff 和校验结果整理成一条可回放的日志流。它适合排障、课堂演示和复盘截图。

如果你想把它理解得更清楚，可以把它当成：

```text
trace = 机器用来串联链路
runtime log = 人用来扫读和复盘
event log = 系统用来重建事实
```

## 文件

- `trace_context_bridge.py`：Python 版 `traceparent` 传播演示。
- `trace_context_bridge_node.js`：Node.js 版 `traceparent` 传播演示。
- `trace_runtime_log_bridge.py`：把两个 bridge 的输出合并成一条运行日志。

## 建议字段

一个更稳的 runtime log，除了 `runtime` 和 `span_name`，还建议保留：

| 字段 | 用途 |
| --- | --- |
| `timestamp` | 看出顺序和耗时 |
| `runtime` | 区分 python、nodejs、bridge |
| `actor` | 区分 orchestrator、adapter、reviewer |
| `event_type` | 区分 span、handoff、check |
| `task_id` | 回到业务任务 |
| `trace_id` | 回到整条 trace |
| `span_id` | 回到具体步骤 |
| `parent_span_id` | 看父子关系 |
| `status` | 看这一步是否成功 |
| `artifact_ref` | 回到受控证据 |

## 运行

在仓库根目录运行：

```powershell
python examples/trace-observability/trace_runtime_log_bridge.py
```

如果你想保存成文件：

```powershell
python examples/trace-observability/trace_runtime_log_bridge.py --output tmp/trace-runtime-log.json
```

合并后的输出会包含三类记录：

1. Python runtime 的 span 记录。
2. Python 到 Node.js 的 handoff 记录。
3. Node.js runtime 的 span 记录和最终校验记录。

## 输出长什么样

输出是一个 JSON 对象，其中最重要的部分是 `runtime_log`：

```json
{
  "task_id": "task-book-runtime-log-001",
  "artifact_ref": "artifact://runtime-log/task-book-runtime-log-001",
  "python_trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
  "node_trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
  "same_trace": true,
  "parent_linked": true,
  "runtime_log": [
    {
      "runtime": "python",
      "actor": "orchestrator-agent",
      "event_type": "span",
      "span_name": "load_task_card",
      "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
      "status": "ok"
    },
    {
      "runtime": "bridge",
      "event_type": "handoff",
      "message": "python -> nodejs via traceparent",
      "status": "ok",
      "artifact_ref": "artifact://runtime-log/task-book-runtime-log-001"
    },
    {
      "runtime": "nodejs",
      "actor": "codex-cli-adapter",
      "event_type": "span",
      "span_name": "invoke_codex_cli",
      "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
      "status": "ok"
    }
  ]
}
```

你真正要看的是这几件事：

- `same_trace` 是否为 `true`。
- `parent_linked` 是否为 `true`。
- `runtime` 是否跨了多个运行时。
- `artifact_ref` 是否足够，能让你回到受控证据，而不是把完整输出塞进日志。
- `event_type` 是否足够区分 span、handoff 和 check。

## 过滤视图

PowerShell 里可以这样看 Node.js 侧记录：

```powershell
$result = python examples/trace-observability/trace_runtime_log_bridge.py | ConvertFrom-Json
$result.runtime_log | Where-Object runtime -eq 'nodejs' | Format-Table timestamp, actor, span_name, trace_id, span_id
```

如果你更关心交接点，可以只看 `bridge` 记录：

```powershell
$result.runtime_log | Where-Object runtime -eq 'bridge' | Format-List
```

如果你更关心异常，可以先筛状态：

```powershell
$result.runtime_log | Where-Object status -ne 'ok' | Format-List
```

## 这和 trace 的区别

| 视图 | 关心什么 | 适合什么 |
| --- | --- | --- |
| Trace | 父子 span、采样、后端查询、时间线 | 跨系统排障和聚合查询 |
| Runtime log | 一次运行的文本化过程、handoff 和检查结果 | 教学、复盘、截图、轻量排障 |
| Event log | 业务状态怎么变 | 审计、回放和状态重建 |

运行日志最有价值的地方，是让读者一眼看出“Python 做了什么、Node.js 接手后做了什么、trace 有没有断”。它不应该吞掉业务事实，也不应该替代 trace backend。

## 多语言链路里的判断标准

如果运行日志里出现这些症状，说明链路还没稳定：

| 症状 | 含义 | 修正 |
| --- | --- | --- |
| `same_trace=false` | Python 和 Node.js 不属于同一条 trace | 检查 `traceparent` 是否写入任务元数据 |
| `parent_linked=false` | Node.js 没接到 Python 最后一个 span | 检查 handoff carrier 和 adapter 读取逻辑 |
| 只有 Python 记录，没有 Node 记录 | Node.js adapter 没执行或没记录 | 检查 CLI 调用、错误处理和 stdout/stderr |
| 只有 Node 记录，没有 Python 记录 | 上游上下文没有传下来 | 检查消息属性、队列字段或 HTTP headers |

## 和 OpenTelemetry 的关系

这个样例暂时不要求安装 OpenTelemetry SDK。它先证明两件事：

1. 运行时之间可以共享同一个标准化 carrier。
2. 运行日志可以把跨语言 handoff 变成可读、可回放的证据。

等你把依赖准备好后，可以把同样的 `traceparent` 逻辑换成 OpenTelemetry SDK 的 inject / extract。

如果你想把 runtime log 放进更标准的日志生态，可以继续看 OpenTelemetry Logs 的官方文档，再决定是否把这里的 runtime log 作为日志平台的一层受控投影。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry 的 context propagation 文档说明，context 可以跨服务和进程传播，默认与 W3C Trace Context 兼容。
- OpenTelemetry JavaScript propagation 文档说明，JS SDK 提供自动传播和手动 inject / extract 的入口。
- OpenTelemetry Python propagation 文档说明，Python SDK 也有对应的传播入口。

本书判断：

- 多语言 agent 系统不应该只看 trace backend 的 UI，也要保留一份人类能直接读的运行日志视图。
- 运行日志最适合做课堂和团队试点的第一次复盘，trace backend 更适合做深度查询和聚合分析。
- `trace_id`、`task_id` 和 `artifact_ref` 三者一起保留，排障会更稳。

推演：

- 更成熟的 OpenClaw 类系统会把运行日志、trace 和事件流分成三层投影：人看运行日志，分析器看 trace backend，流程恢复看事件日志和读模型。

## 参考与复核说明

- [OpenTelemetry Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)：用于核验跨进程传播 context 的概念。
- [OpenTelemetry Logs](https://opentelemetry.io/docs/concepts/signals/logs/)：用于核验 logs 作为可观测性信号的官方说明。
- [OpenTelemetry JavaScript Propagation](https://opentelemetry.io/docs/languages/js/propagation/)：用于核验 JavaScript SDK 的传播入口。
- [OpenTelemetry Python Propagation](https://opentelemetry.io/docs/languages/python/propagation/)：用于核验 Python SDK 的传播入口。
