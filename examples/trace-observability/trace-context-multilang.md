# 多语言 Trace Context 传播样例

最后核验：2026-05-20

这个样例接在 [跨 Agent Trace Context 传播样例](trace-context-propagation.md) 后面。前一页用 Python 解释 `traceparent` 的结构；这一页把问题推进一步：

```text
如果一个任务先经过 Python agent，再交给 Node.js / CLI adapter，怎样保证仍然是同一条 trace？
```

OpenClaw、Codex CLI、Claude CLI、飞书机器人、Telegram bot 和 GitHub Actions 往往不是同一种语言写的。真正的多 agent 系统通常会混用 Python、Node.js、Shell、Go、Rust 或远程 HTTP 服务。此时 trace context 不能留在某个语言的内存里，必须放进任务元数据、消息属性、HTTP headers 或受控 artifact 引用。

## 文件

- `trace_context_bridge.py`：Python 版无依赖 `traceparent` 传播演示。
- `trace_context_bridge_node.js`：Node.js 版无依赖 `traceparent` 传播演示。
- `trace_runtime_log_bridge.py`：把 Python 和 Node.js 输出合并成 runtime log 的演示。
- `trace-context-propagation.md`：解释 `traceparent` 字段、carrier 和常见失败。
- `trace-backend-selection.md`：解释后端接入和查询策略。

## 运行前提

Python 和 Node.js 都只用标准库，不需要安装 OpenTelemetry SDK。这样做是为了让读者先看懂传播结构。真实项目里，应该优先使用 OpenTelemetry SDK 的 inject / extract 机制。

检查 Node.js：

```powershell
node --version
```

## 串联运行

第一步，用 Python 模拟上游 agent。这里给一个固定的 root `traceparent`，方便观察：

```powershell
$root = "00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01"
$py = python examples/trace-observability/trace_context_bridge.py --input-traceparent $root --task-id task-multilang-001 | ConvertFrom-Json
```

第二步，把 Python 最后一个 span 的 `outgoing_carrier.traceparent` 交给 Node.js：

```powershell
$carrier = $py.events[-1].outgoing_carrier.traceparent
$node = node examples/trace-observability/trace_context_bridge_node.js --input-traceparent $carrier --task-id task-multilang-001 | ConvertFrom-Json
```

第三步，验证它们仍然属于同一条 trace，并且 Node.js 第一个 span 的父 span 等于 Python 最后一个 span：

```powershell
$py.trace_id -eq $node.trace_id
$py.events[-1].span_id -eq $node.events[0].parent_span_id
```

两行都应该输出：

```text
True
True
```

这就是跨语言 trace context 的核心：不是把 Python 对象传给 Node.js，而是把标准化 carrier 传给下游运行时。

## 一段运行日志应该长什么样

真实系统里，不一定把完整 JSON 打到日志。更常见的是保存精简运行日志：

```text
2026-05-20T14:40:01+08:00 task=task-multilang-001 runtime=python actor=orchestrator-agent span=load_task_card trace=4bf92f3577b34da6a3ce929d0e0e4736 parent=00f067aa0ba902b7 status=ok
2026-05-20T14:40:06+08:00 task=task-multilang-001 runtime=python actor=publish-agent span=publish_after_approval trace=4bf92f3577b34da6a3ce929d0e0e4736 status=ok outgoing=00-4bf92f3577b34da6a3ce929d0e0e4736-<python-last-span>-01
2026-05-20T14:40:08+08:00 task=task-multilang-001 runtime=nodejs actor=node-router-agent span=receive_handoff trace=4bf92f3577b34da6a3ce929d0e0e4736 parent=<python-last-span> status=ok
2026-05-20T14:40:13+08:00 task=task-multilang-001 runtime=nodejs actor=codex-cli-adapter span=invoke_codex_cli trace=4bf92f3577b34da6a3ce929d0e0e4736 status=ok artifact=artifact://cli-run/task-multilang-001.json
```

日志里保留的是 ID、运行时、actor、span、状态和 artifact 引用。不要把完整 prompt、模型输出、密钥、cookie、客户资料或私有笔记写进运行日志。

如果你想直接生成这类合并后的运行日志，继续看 [多语言运行日志回放样例](trace-runtime-log-replay.md)。

## 在 OpenClaw 里的落点

一个更接近 OpenClaw 的链路可以这样设计：

```text
飞书任务表
  traceparent
  task_id
  risk_level
  context_pack_ref
  -> Python research-agent
       读取任务卡和 carrier
       写 research artifact
       写新的 traceparent
  -> Node.js OpenClaw adapter
       读取新的 carrier
       调用 Codex CLI 或 Claude CLI
       写 stdout/stderr 摘要和 artifact 引用
       写新的 traceparent
  -> publish-agent
       读取新的 carrier
       运行检查
       等人工批准
       提交和推送
```

其中 carrier 可以放在：

- HTTP headers。
- 队列消息属性。
- 飞书多维表格字段。
- GitHub Issue front matter。
- SQLite `task_runs` 表。
- Markdown 任务卡的受控元数据区。

不要放在聊天正文里让模型自由改写。`traceparent` 是运行时元数据，应该由系统读写，不应该由模型凭空生成。

## CLI adapter 的注意点

很多 CLI 不认识 OpenTelemetry，也不会自动传播 headers。此时可以用 adapter 包一层：

```text
adapter 读取 traceparent
adapter 记录 call_cli span
adapter 调用 codex/claude/其他 CLI
adapter 保存 stdout/stderr 摘要到 artifact
adapter 写出新的 traceparent
```

这并不要求 CLI 本身马上接入 OpenTelemetry。只要 adapter 能记录调用前后的 span，多 agent 链路就不会完全断掉。等 CLI 原生支持 tracing 后，再把内部 span 接到同一条 trace 里。

## 常见失败

| 失败方式 | 表现 | 修复 |
| --- | --- | --- |
| 只在 Python 内存里保存 context | Node.js 接手后新建 trace | 把 carrier 写入任务元数据 |
| CLI adapter 不记录 parent span | 后端只看到孤立 CLI 调用 | adapter 读取上游 `traceparent` |
| 模型改写任务卡里的 trace 字段 | trace 断裂或伪造 | trace 元数据由系统层维护 |
| stdout 直接进 trace | 大量敏感内容进入后端 | stdout 进 artifact，trace 只保存引用 |
| 不验证 parent/span 关系 | 看似同一个任务，实际父子关系断 | 增加运行后校验脚本或看板检查 |

## 事实、判断和推演边界

事实和来源：

- W3C Trace Context 定义 `traceparent` 和 `tracestate`，用于跨系统传播 trace 上下文。
- OpenTelemetry 的 context propagation 文档说明，传播机制用于让不同服务和进程中的 signals 能被关联。
- OpenTelemetry JavaScript propagation 文档说明，JavaScript SDK 可以自动传播，也可以在自定义协议中手动 inject / extract。
- OpenTelemetry Python propagation 文档提供 Python SDK 的上下文传播入口。

本书判断：

- 多语言 agent 系统不应该依赖某一种语言的内存上下文。跨运行时交接必须使用 carrier。
- 对 CLI adapter 来说，先记录外层 span 和 artifact 引用，比强行要求所有 CLI 立刻原生支持 OpenTelemetry 更现实。
- `trace_id` 解决运行链路，`task_id` 解决业务任务。两者都要保留。

推演：

- 更成熟的 OpenClaw runtime 会把 carrier 传播做成内置能力：Python、Node.js、Shell、浏览器插件和远程 agent 都不需要手工复制 `traceparent`，系统会在任务交接、工具调用和审批回调时自动继承上下文。

## 参考与复核说明

- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于核验 `traceparent`、`tracestate` 和跨系统传播格式。
- [OpenTelemetry Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)：用于核验 context propagation 在分布式追踪中的定位。
- [OpenTelemetry JavaScript Propagation](https://opentelemetry.io/docs/languages/js/propagation/)：用于核验 JavaScript SDK 自动传播和手动 inject / extract 的官方入口。
- [OpenTelemetry Python Propagation](https://opentelemetry.io/docs/languages/python/propagation/)：用于核验 Python SDK 中传播上下文的入口。
