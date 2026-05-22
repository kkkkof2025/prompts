# 电子书与离线阅读指南

本项目提供 Pandoc 导出脚本，用于生成 HTML、EPUB 或 DOCX，方便离线阅读、课堂发放和内部培训。

## 环境准备

需要本地安装：

- [Pandoc](https://pandoc.org/installing.html)
- PowerShell 7 或 Windows PowerShell

在项目根目录运行：

```powershell
./scripts/export-ebook.ps1 -Format html
./scripts/export-ebook.ps1 -Format epub
./scripts/export-ebook.ps1 -Format docx
```

默认输出目录为 `dist/`。

## 导出内容

脚本会按固定顺序合并：

- 封面页和版权页。
- 第 0-14 章正文。
- 分角色案例。
- 学习路径、教学方案、教学版本材料包、课堂练习工作纸、教学示范作业集、试读与试跑反馈包、图解、复盘题、章节练习与验收映射表、速查讲义、工作流配方和评估量表。
- 常见误区、Prompt 调试、任务选择、安全案例、模型选型、技术演进案例、团队落地、自动化维护、结构审计和 1.0 发布检查材料。
- Prompt、Skill/Card、Agent 安全清单、任务事件日志和 Trace / OpenTelemetry 实践模板。
- 术语表、练习参考答案、检查清单、资源与引用、前沿资料季度复核执行手册、前沿资料季度复核记录表、贡献指南、路线图、变更记录、项目记忆和许可证。

HTML 和 EPUB 会使用 [ebook-style.css](ebook-style.css) 中的基础样式。DOCX 的最终版式通常需要在文字处理软件中再检查一次。

## EPUB 使用建议

- 适合发给读者离线阅读。
- 适合导入支持 EPUB 的阅读器和知识库工具。
- 如果阅读器不支持 Mermaid 图，`docs/diagrams.md` 中的 Mermaid 代码仍可作为文本阅读。

## 是否引入 mdBook

当前不建议立即迁移到 mdBook。

原因：

- 本项目已经能用 GitHub Pages 直接发布 Markdown。
- 读者和贡献者不需要额外构建工具就能阅读和修改。
- Pandoc 已覆盖离线阅读的主要需求。

可以在以下情况重新评估 mdBook：

- 需要更强的侧边栏、搜索和多版本发布。
- 需要把书稿发布成更完整的在线课程。
- 贡献者愿意维护额外构建链和主题配置。

## 发布前检查

导出电子书前建议先运行：

```powershell
./scripts/check-markdown-links.ps1 -Root . -CheckPlaceholders
./scripts/check-terminology.ps1 -Root .
```

如果导出失败，优先检查 Pandoc 是否在 `PATH` 中，以及新增页面是否已经写入 `scripts/export-ebook.ps1` 的文件列表。
