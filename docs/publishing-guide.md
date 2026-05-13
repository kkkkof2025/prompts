# GitHub 发布指南

这份指南帮助你把本项目发布到 GitHub，并开启 GitHub Pages。

## 发布前检查

发布前先确认：

- 根目录有 `README.md`。
- 根目录有 `LICENSE.md`，当前采用 CC BY-SA 4.0。
- 根目录有 `index.md` 和 `_config.yml`。
- `docs/SUMMARY.md` 已包含主要页面。
- 本地链接检查通过。
- GitHub Actions Markdown Check 通过，或本地检查命令通过。
- 发布 1.0 前按 [1.0 发布前总检查清单](release-checklist-1.0.md) 完成最终验收。
- 没有 `.env`、密钥、私人路径、账号信息或未公开资料。

## 初始化 Git 仓库

如果当前目录还不是 Git 仓库，可以在项目根目录运行：

```powershell
git init
git add .
git commit -m "Initial AI learning book"
```

然后在 GitHub 创建新仓库，并按 GitHub 页面提示添加远程地址：

```powershell
git remote add origin https://github.com/你的用户名/你的仓库名.git
git branch -M main
git push -u origin main
```

## GitHub Pages 设置

推荐设置：

```text
Source: Deploy from a branch
Branch: main
Folder: / (root)
```

选择根目录的原因：

- 书稿入口在 `docs/`。
- 实践模板在 `examples/`。
- 项目说明、许可证、贡献指南在根目录。
- 从根目录发布可以保证相对链接更稳定。

站点使用根目录 `_config.yml` 控制标题、语言、主题和顶部导航。为了避免 GitHub Pages 默认主题把所有页面都塞进导航栏，`header_pages` 只保留少量核心入口；完整页面仍通过 [SUMMARY.md](SUMMARY.md) 访问。

## 发布后的入口

GitHub Pages 构建完成后，访问：

```text
https://你的用户名.github.io/你的仓库名/
```

主要入口：

- `/`：根目录首页。
- `/docs/`：书稿首页。
- `/docs/SUMMARY.html`：完整目录。
- `/examples/`：实践模板。

## 更新流程

建议每次更新按这个流程：

```text
修改内容 -> 本地链接检查 -> 更新 MEMORY.md -> 更新 CHANGELOG.md -> commit -> push
```

本地检查命令：

```powershell
./scripts/check-markdown-links.ps1 -Root . -CheckPlaceholders
./scripts/check-terminology.ps1 -Root .
```

如果更新涉及前沿事实，还要同步更新：

- `docs/appendix-resources.md`
- 相关章节中的“截至日期”
- `MEMORY.md` 中的核验记录

## 导出电子书

本项目提供一个 Pandoc 导出脚本：

```powershell
./scripts/export-ebook.ps1 -Format html
./scripts/export-ebook.ps1 -Format epub
./scripts/export-ebook.ps1 -Format docx
```

要求：

- 本地已安装 Pandoc。
- 命令在项目根目录执行。
- 输出默认写入 `dist/`。
- 电子书封面、版权页和样式说明见 [电子书与离线阅读指南](ebook-guide.md)。

这个脚本是辅助分发工具，不影响 GitHub Pages 发布。

## 自动化检查

当前包含四类自动化：

- `Markdown Check`：运行 Markdown lint、本地链接检查和术语一致性检查。
- `Pages Build Check`：检查 GitHub Pages/Jekyll 能否从根目录构建。
- `External Link Check`：每月和手动运行外部链接检查。
- 本地脚本：`scripts/check-markdown-links.ps1`、`scripts/check-terminology.ps1`、`scripts/check-external-links.ps1`。

## 常见问题

### Pages 没有立刻更新

GitHub Pages 构建可能需要几分钟。可以在仓库的 Actions 或 Pages 设置中查看状态。

### Mermaid 图不显示

GitHub 仓库 Markdown 页面通常支持 Mermaid。GitHub Pages 的 Jekyll 主题是否渲染 Mermaid，取决于主题和插件。即使不渲染，`docs/diagrams.md` 中的代码块仍可阅读和复制。

### 链接在 GitHub 仓库里能打开，Pages 上打不开

优先检查：

- 是否使用了相对链接。
- GitHub Pages 是否从根目录发布。
- 文件名大小写是否一致。

## 发布前最终清单

完整 1.0 发布验收见 [1.0 发布前总检查清单](release-checklist-1.0.md)。日常发布可使用下方简版清单。

- [ ] 确认许可证仍然使用 CC BY-SA 4.0，或已经同步修改 README、LICENSE 和 CONTRIBUTING。
- [ ] 检查所有本地 Markdown 链接。
- [ ] 检查术语写法一致性。
- [ ] 运行 Markdown Check。
- [ ] 检查外部链接是否仍有效，或确认本次不涉及外部事实更新。
- [ ] 确认没有敏感信息。
- [ ] 更新 `MEMORY.md`。
- [ ] 更新 `CHANGELOG.md`。
- [ ] 创建首个 Git commit。
- [ ] 在 GitHub Pages 选择 `/ (root)`。
