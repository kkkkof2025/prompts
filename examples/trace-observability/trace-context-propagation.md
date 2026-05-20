# 跨 Agent Trace Context 传播样例

最后核验：2026-05-20

这个样例接在 [OpenTelemetry 最小接入样例](otel-minimal-instrumentation.md) 和 [OpenTelemetry 生产化加固样例](otel-production-hardening.md) 后面。前面两页说明怎样产生 span、怎样进入 Collector；本页说明另一个常见断点：

```text
多个 agent 分别运行时，怎样保证它们仍然属于同一条 trace？
```

如果每个 agent 都自己生成新的 trace，排障时就会看到五条孤立记录，而不是一条完整链路。

## 核心概念

W3C Trace Context 定义了 `traceparent` 和 `tracestate` 两类传播字段。最常见的是 `traceparent`：

```text
00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01
```

它可以拆成四段：

| 字段 | 例子 | 含义 |
| --- | --- | --- |
| version | `00` | 当前格式版本 |
| trace-id | `4bf92f3577b34da6a3ce929d0e0e4736` | 同一条 trace 的全局 ID |
| parent-id | `00f067aa0ba902b7` | 上游 span ID |
| trace-flags | `01` | 采样等标记 |

跨 agent 传播的关键不是“复制整个 trace”，而是让下游 agent 收到上游 carrier，创建自己的 span，再把新的 carrier 交给下一个 agent。

## 文件

- `trace_context_bridge.py`：无外部依赖的 traceparent 传播演示脚本。
- `trace-spans.jsonl`：已经落地的 trace span 样例。
- `otel_agent_trace_minimal.py`：OpenTelemetry Python SDK 最小 span 示例。

## 运行

在仓库根目录运行：

```powershell
python examples/trace-observability/trace_context_bridge.py
```

输出会包含五个 agent 步骤：

```text
orchestrator-agent -> research-agent -> writer-agent -> review-agent -> publish-agent
```

它们的 `trace_id` 相同，但每一步都有自己的 `span_id`。每一步的 `outgoing_carrier.traceparent` 会成为下一步的 `incoming_carrier.traceparent`。

也可以传入已有 `traceparent`：

```powershell
python examples/trace-observability/trace_context_bridge.py --input-traceparent "00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01"
```

生成文件：

```powershell
python examples/trace-observability/trace_context_bridge.py -OutputPath tmp/trace-context-chain.json
```

上面这条命令是故意写错的：Python 脚本使用 `--output`，不是 PowerShell 参数风格。正确写法：

```powershell
python examples/trace-observability/trace_context_bridge.py --output tmp/trace-context-chain.json
```

这个小错误适合提醒读者：CLI 之间参数风格不同，agent 调用工具时要记录工具名和参数摘要，不能只写“执行失败”。

## 传播路径

一个 OpenClaw 多 agent 任务可以这样传播：

```text
任务卡
  traceparent: root
  -> research-agent
       读取任务卡 carrier
       创建 check_sources span
       写出新的 traceparent
  -> writer-agent
       读取 research-agent carrier
       创建 write_draft span
       写出新的 traceparent
  -> review-agent
       读取 writer-agent carrier
       创建 safety_review span
       写出新的 traceparent
  -> publish-agent
       读取 review-agent carrier
       创建 publish_after_approval span
```

如果这些 agent 通过飞书任务、Telegram 消息、GitHub Issue、SQLite 队列或云文档交接，carrier 可以放在受控元数据里：

```json
{
  "task_id": "task-book-trace-context-001",
  "trace": {
    "traceparent": "00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01",
    "tracestate": ""
  },
  "artifact_ref": "artifact://context-pack/task-book-trace-context-001.md"
}
```

不要把完整 prompt、模型输出、密钥、cookie、手机号、邮箱或原始客户资料塞进 carrier。Carrier 只负责传播上下文 ID；证据正文应该放到受控 artifact，再用引用链接连接。

## 和 OpenTelemetry SDK 的关系

真实项目里，不建议手写 `traceparent`。OpenTelemetry SDK 通常会提供 inject / extract 机制，把当前上下文注入到 HTTP headers、消息属性或自定义 carrier，再从下游提取。

这个样例手写 `traceparent`，是为了让读者看懂：

- 为什么多个 agent 要共享同一个 `trace_id`。
- 为什么每个 agent 又要生成自己的 `span_id`。
- 为什么 `tracestate` 和 baggage 不适合存业务正文。
- 为什么 trace context 传播和业务事件日志不是一回事。

学会这个结构后，再回到 SDK 的 inject / extract，会更容易理解。

如果你要把 Python agent、Node.js adapter 和 CLI 工具串在同一条链路里，继续看 [多语言 Trace Context 传播样例](trace-context-multilang.md)。那一页会用 PowerShell 把 Python 输出的 `outgoing_carrier.traceparent` 传给 Node.js，并验证父子 span 关系。

## 常见失败

| 失败方式 | 表现 | 修复 |
| --- | --- | --- |
| 每个 agent 都新建 trace | 看板上出现多条孤立 trace | 任务交接时传递 carrier |
| 只传 `task_id` 不传 trace context | 能按任务查，但看不到父子 span | 同时传 `task_id` 和 `traceparent` |
| 把 prompt 放进 `tracestate` | 泄露资料，header 过长 | 只传 ID，正文进 artifact |
| 下游覆盖上游 `trace_id` | trace 断裂 | 下游提取上游上下文后再创建子 span |
| 异步队列丢掉 headers | 工具调用前后无法关联 | 把 carrier 写入消息属性或任务元数据 |

## 事实、判断和推演边界

事实和来源：

- W3C Trace Context 定义了 `traceparent` 和 `tracestate` 的传播格式，用于跨系统关联分布式 trace。
- OpenTelemetry 文档把 context propagation 作为跨服务追踪的基础能力，并提供语言 SDK 的传播机制。
- `traceparent` 负责携带 trace 标识和上游 span 位置；`tracestate` 用于厂商或实现相关的扩展状态。

本书判断：

- 多 agent 系统里，trace context 应该跟任务卡、消息、队列或云文档元数据一起传递。
- `task_id` 解决“这是哪个业务任务”，`trace_id` 解决“这次运行链路怎么走”。两者都需要。
- Carrier 不应保存敏感正文，只保存必要 ID 和受控引用。

推演：

- 更成熟的 OpenClaw 类系统会把 trace context 传播内置到 agent runtime：每次 handoff、tool call、approval、memory write 都自动继承上下文，而不是让作者手工复制 ID。

## 参考与复核说明

- [W3C Trace Context](https://www.w3.org/TR/trace-context/)：用于核验 `traceparent`、`tracestate` 和跨系统传播格式。
- [OpenTelemetry Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)：用于核验 OpenTelemetry 对 context propagation 的基本解释。
- [OpenTelemetry Python Propagation](https://opentelemetry.io/docs/languages/python/propagation/)：用于核验 Python SDK 中传播上下文的入口。
