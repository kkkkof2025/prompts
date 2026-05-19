# 任务事件日志样例

这个目录提供一个最小任务事件流，用来配合 [Event Sourcing：事件溯源与任务回放](../../docs/event-sourcing.md)、[CQRS：读写分离与多 agent 查询视图](../../docs/cqrs.md) 和 [Read Model 与 Projection：读模型与投影](../../docs/read-model-projections.md) 阅读。

## 文件

- `task-events.jsonl`：按 JSONL 保存的任务事件，每行一条事件。
- `replay-task-events.ps1`：把事件流回放成读模型快照。

## 回放

在仓库根目录运行：

```powershell
./scripts/replay-task-events.ps1 -InputPath examples/event-log/task-events.jsonl
```

生成 JSON 快照：

```powershell
./scripts/replay-task-events.ps1 -InputPath examples/event-log/task-events.jsonl -OutputPath tmp/task-read-models.json
```

## 这个样例演示什么

- 一个任务从创建、认领、写草稿、复核、批准到推送成功。
- 一个任务停在 `waiting_review`，适合显示在待复核看板。
- 一个高风险任务停在 `blocked`，适合显示在风险队列。
- 最后一条事件故意重复了 `event_id`，用来演示消费者按事件编号幂等跳过重复投递。

这个样例不是生产级事件系统，只是把书里的概念变成可以运行和检查的最小材料。
