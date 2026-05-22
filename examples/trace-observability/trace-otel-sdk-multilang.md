# 多语言 OpenTelemetry SDK 接入路线

最后核验：2026-05-22

前面几页用手写 `traceparent` 解释了跨 agent、跨 Python/Node.js/CLI adapter 的传播结构：

- [跨 Agent Trace Context 传播样例](trace-context-propagation.md)
- [多语言 Trace Context 传播样例](trace-context-multilang.md)
- [多语言运行日志回放样例](trace-runtime-log-replay.md)
- [多语言运行日志投影与失败回放样例](trace-runtime-log-projection.md)

这一页回答下一步：

```text
等项目准备好依赖之后，怎么从手写 traceparent 过渡到 OpenTelemetry SDK？
```

核心结论很简单：

```text
手写 traceparent = 教学和最小验证
OpenTelemetry SDK inject / extract = 长期工程接入
Collector / backend = 团队和生产查询
```

## 官方能力边界

OpenTelemetry 官方文档把 context propagation 描述为让 traces、metrics、logs 等信号跨服务、跨进程关联的机制。它通常由 instrumentation libraries 自动处理；当使用自定义协议、队列、云文档、CLI adapter 或任务卡时，才需要手动传播。

OpenTelemetry Propagators API 的核心动作是：

- `inject`：把当前 context 写入 carrier。
- `extract`：从 carrier 读出 context。

这里的 carrier 可以是 HTTP headers，也可以是消息属性、任务元数据、SQLite 行、飞书多维表格字段或 Markdown 任务卡的受控元数据区。

## Python 侧迁移草图

手写版里，我们自己生成：

```text
00-<trace_id>-<span_id>-01
```

SDK 版里，Python 侧更接近这样：

```python
from opentelemetry import context, trace
from opentelemetry.propagate import inject, extract

tracer = trace.get_tracer("openclaw-python-agent")

incoming_carrier = {"traceparent": task_card["traceparent"]}
parent_context = extract(incoming_carrier)

with tracer.start_as_current_span(
    "research_agent.check_sources",
    context=parent_context,
) as span:
    span.set_attribute("task.id", task_card["task_id"])
    span.set_attribute("agent.actor", "research-agent")
    span.set_attribute("artifact.ref", "artifact://research-brief/task-001.json")

    outgoing_carrier = {}
    inject(outgoing_carrier)
```

注意三件事：

- `task.id` 是业务任务 ID。
- `trace_id` 和 `span_id` 由 SDK 负责。
- `artifact.ref` 只放引用，不放完整 prompt、私有资料或 stdout。

## Node.js 侧迁移草图

Node.js 侧在自定义协议里也可以显式 `extract` 和 `inject`：

```javascript
const { context, propagation, trace } = require("@opentelemetry/api");

const tracer = trace.getTracer("openclaw-node-adapter");

const incomingCarrier = {
  traceparent: taskCard.traceparent,
  tracestate: taskCard.tracestate || "",
};

const parentContext = propagation.extract(context.active(), incomingCarrier);

const span = tracer.startSpan(
  "codex_cli_adapter.invoke",
  {
    attributes: {
      "task.id": taskCard.task_id,
      "agent.actor": "codex-cli-adapter",
      "artifact.ref": `artifact://cli-run/${taskCard.task_id}.json`,
    },
  },
  parentContext,
);

const activeContext = trace.setSpan(parentContext, span);
const outgoingCarrier = {};
propagation.inject(activeContext, outgoingCarrier);
span.end();
```

这段代码不是要求你马上安装依赖运行，而是说明迁移方向：`traceparent` 不再由业务脚本手工拼接，而是由 SDK 从当前 context 注入到 carrier。

## OpenClaw / CLI adapter 映射

在 OpenClaw 类系统里，可以把传播链路分成四段：

| 环节 | 手写样例 | SDK 迁移后 |
| --- | --- | --- |
| 任务卡读取 | 读取 `traceparent` 字段 | 从任务元数据 carrier `extract` |
| Python agent | 手工生成 span id | `start_as_current_span` |
| Node.js adapter | 读取 Python 输出 carrier | `propagation.extract` 后启动子 span |
| 写回任务状态 | 手工写新的 `traceparent` | `inject` 到任务元数据或消息属性 |

这个映射最重要的价值不是“更像标准库”，而是后续可以接 Collector、采样、脱敏、日志关联和 trace backend 查询。

## 不要这样迁移

| 错误做法 | 风险 | 更稳做法 |
| --- | --- | --- |
| SDK 和手写 `traceparent` 混着生成 | 父子 span 关系断裂 | 迁移后让 SDK 负责生成和传播 |
| 把完整 prompt 放进 baggage | 敏感信息跨边界扩散 | baggage 只放低风险小字段，正文进 artifact |
| CLI stdout 直接写进 span 属性 | 日志后端爆量和泄密 | stdout 写入受控 artifact，span 只放摘要和引用 |
| 每个 agent 独立初始化不传 carrier | 后端看到多条孤立 trace | 任务交接必须传 carrier |
| 先接平台再想字段 | 后续难查、难控成本 | 先统一 `task_id`、`actor`、`artifact_ref`、`risk_level` |

## 分阶段迁移

### 阶段 1：保留手写样例

继续用现有 `trace_context_bridge.py`、`trace_context_bridge_node.js` 和 runtime log 页教学。这个阶段的目标是让团队看懂 `trace_id`、`span_id`、`parent_span_id`、carrier 和 broken handoff。

### 阶段 2：单语言 SDK 接入

先在 Python 或 Node.js 单侧接 SDK，输出 console span 或 OTLP。不要急着同时改所有语言。

### 阶段 3：跨语言 inject / extract

让 Python 写出的 carrier 被 Node.js `extract`，再让 Node.js 写出的 carrier 被后续发布 agent 读取。此时继续保留 runtime log 投影，方便人类验证。

### 阶段 4：Collector 和后端

接入 Collector、采样、脱敏、trace backend 和日志平台。这个阶段要参考 [OpenTelemetry 生产化加固样例](otel-production-hardening.md) 和 [Trace Backend 选型与查询策略](trace-backend-selection.md)。

## 最小验收标准

迁移到 SDK 后，至少要保留这些验收项：

1. Python 和 Node.js 仍然拥有相同 `trace_id`。
2. Node.js 第一个 span 的 parent 能回到 Python 最后一个 span。
3. runtime log projection 仍能生成 summary 和 failure queue。
4. span 属性里没有完整 prompt、密钥、cookie、个人隐私和原始客户资料。
5. 任务卡里只保留 carrier 和 artifact 引用，不让模型自由改写 trace 元数据。

## 事实、判断和推演边界

事实和来源：

- OpenTelemetry Context propagation 文档说明，context propagation 让 traces、metrics、logs 等信号可以跨服务和进程关联。
- OpenTelemetry Propagators API 说明，Propagator 负责从 carrier 读写 context，TextMapPropagator 使用字符串键值对作为 carrier。
- OpenTelemetry Python propagation 文档给出 Python 手动 inject / extract 的入口。
- OpenTelemetry JavaScript propagation 文档给出 JS 自动传播和手动 `propagation.inject` / `propagation.extract` 的示例。

本书判断：

- 对 OpenClaw、Codex CLI、Claude CLI、飞书、Telegram 和 GitHub Actions 混合系统来说，先用手写样例讲清 carrier，再迁移 SDK，比直接上 Collector 更容易稳定。
- CLI adapter 不一定要等 CLI 原生支持 OpenTelemetry；外层 adapter 先记录 span 和 artifact 引用，就能先保住运行链路。

推演：

- 更成熟的 OpenClaw runtime 会把 `extract -> start span -> inject` 封装成内置中间层，让 Python、Node.js、Shell、浏览器插件和远程 agent 都自动继承同一条 trace。

## 参考与复核说明

- [OpenTelemetry Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)：用于核验 context propagation 的概念、自动传播、手动 carrier 和安全提醒。
- [OpenTelemetry Propagators API](https://opentelemetry.io/docs/specs/otel/context/api-propagators/)：用于核验 `Inject`、`Extract`、carrier 和 TextMapPropagator 的规范说明。
- [OpenTelemetry Python Propagation](https://opentelemetry.io/docs/languages/python/propagation/)：用于核验 Python SDK 中手动 inject / extract 的入口。
- [OpenTelemetry JavaScript Propagation](https://opentelemetry.io/docs/languages/js/propagation/)：用于核验 JavaScript SDK 中自动传播和手动 `propagation.inject` / `propagation.extract` 的入口。

