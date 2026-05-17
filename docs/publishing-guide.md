# GitHub 发布指南

这份指南帮助你把本项目发布到 GitHub Pages。当前项目只使用 MkDocs Material 作为在线阅读版式，不再保留其他静态站点方案。

## 发布前检查

发布前先确认：

- 根目录有 `README.md`、`LICENSE.md` 和 `CONTRIBUTING.md`。
- 根目录有 `mkdocs.yml` 和 `requirements-docs.txt`。
- `docs/SUMMARY.md` 已包含主要页面。
- `mkdocs.yml` 的 `nav` 已包含所有核心章节、案例、附录、模板和维护页面。
- 本地链接检查、术语一致性检查、Markdown lint 和 MkDocs 构建通过。
- 发布 1.0 前按 [1.0 发布前总检查清单](release-checklist-1.0.md) 完成最终验收。
- 没有 `.env`、密钥、私人路径、账号信息或未公开资料。

## 初始化 Git 仓库

如果当前目录还不是 Git 仓库，可以在项目根目录运行：

```powershell
git init
git add .
git commit -m "Initial AI learning book"
```

然后在 GitHub 创建新仓库，并按 GitHub 页面提示添加远程地址。新仓库可以使用 `main`，本项目当前实际发布分支是 `master`：

```powershell
git remote add origin https://github.com/你的用户名/你的仓库名.git
git branch -M main
git push -u origin main
```

## GitHub Pages 设置

推荐设置：

```text
Source: GitHub Actions
```

项目使用 `.github/workflows/mkdocs-pages.yml` 构建和部署 Pages。workflow 同时监听 `master` 和 `main`；本仓库当前推送到 `master` 后会执行：

1. 安装 Python。
2. 安装 `requirements-docs.txt` 中的 MkDocs 依赖。
3. 运行 `python -m mkdocs build --config-file mkdocs.yml --site-dir "$RUNNER_TEMP/mkdocs-site"`。
4. 上传 runner 临时目录中的 MkDocs 输出作为 GitHub Pages artifact。
5. 部署到 GitHub Pages。

## 发布后的入口

GitHub Pages 构建完成后，访问：

```text
https://你的用户名.github.io/你的仓库名/
```

主要入口：

- `/`：MkDocs 首页。
- `/docs/`：书稿首页。
- `/docs/SUMMARY/`：完整目录。
- `examples/` 下的模板页：实践模板。

## 本地预览

安装依赖：

```powershell
python -m pip install -r requirements-docs.txt
```

本地构建：

```powershell
python -m mkdocs build --config-file mkdocs.yml
```

由于 `mkdocs.yml` 使用项目根目录作为 `docs_dir`，构建输出不要放在项目内部。当前配置会把输出写到仓库外侧的目录，所以本地构建时通常直接使用配置默认值即可。

本地预览：

```powershell
python -m mkdocs serve --config-file mkdocs.yml
```

## 更新流程

建议每次更新按这个流程：

```text
修改内容 -> 本地链接检查 -> MkDocs 构建 -> 更新 MEMORY.md -> 更新 CHANGELOG.md -> commit -> push
```

本地检查命令：

```powershell
./scripts/check-markdown-links.ps1 -Root . -CheckPlaceholders
./scripts/check-terminology.ps1 -Root .
npx --yes markdownlint-cli2 "**/*.md" "#_site" "#node_modules" "#vendor" "#dist" "#site"
python -m mkdocs build --config-file mkdocs.yml
```

如果更新涉及前沿事实，还要同步更新：

- `docs/appendix-resources.md`
- 相关章节中的“截至日期”
- `docs/frontier-review-log.md`
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

这个脚本是辅助分发工具，不影响 MkDocs 在线站点发布。

## 自动化检查

当前包含四类自动化：

- `Markdown Check`：运行 Markdown lint、本地链接检查和术语一致性检查。
- `MkDocs Pages`：构建并部署 MkDocs 站点。
- `External Link Check`：每月和手动运行外部链接检查。
- 本地脚本：`scripts/check-markdown-links.ps1`、`scripts/check-terminology.ps1`、`scripts/check-external-links.ps1`。

## 常见问题

### Pages 没有立刻更新

GitHub Pages 构建可能需要几分钟。可以在仓库的 Actions 或 Pages 设置中查看状态。

### Mermaid 图不显示

MkDocs Material 支持 Mermaid 代码块的展示方式取决于配置和扩展。即使暂时不渲染成图，`docs/diagrams.md` 中的 Mermaid 代码块仍可阅读和复制。

### 链接在 GitHub 仓库里能打开，Pages 上打不开

优先检查：

- 文件是否在 `mkdocs.yml` 的 `docs_dir` 范围内。
- `mkdocs.yml` 的 `nav` 是否包含主要入口。
- 相对链接是否按文件所在目录书写。
- 文件名大小写是否一致。

### 新页面没有出现在侧边栏

新增页面后，需要把它加入 `mkdocs.yml` 的 `nav`。如果只是作为隐藏辅助材料，也应该在相关页面中提供链接。

### 线上没有搜索或左侧导航

如果本地 `mkdocs.yml` 已启用 search 和 nav，但线上仍然像普通 GitHub Pages 主题，通常是 Pages 没有使用 MkDocs workflow 发布。检查：

- 仓库 Settings -> Pages 的 Source 是否为 `GitHub Actions`。
- `MkDocs Pages` workflow 是否在 `master` 或 `main` 推送后运行。
- Actions 里最新一次 `MkDocs Pages` 是否成功。

当前配置会生成 MkDocs Material 站点：顶部保留搜索，左侧栏显示 `mkdocs.yml` 中的全书导航树，并默认展开目录层级。

## 发布前最终清单

完整 1.0 发布验收见 [1.0 发布前总检查清单](release-checklist-1.0.md)。日常发布可使用下方简版清单。

- [ ] 确认许可证仍然使用 CC BY-SA 4.0，或已经同步修改 README、LICENSE 和 CONTRIBUTING。
- [ ] 检查所有本地 Markdown 链接。
- [ ] 检查术语写法一致性。
- [ ] 运行 Markdown lint。
- [ ] 运行 MkDocs 构建。
- [ ] 检查外部链接是否仍有效，或确认本次不涉及外部事实更新。
- [ ] 确认没有敏感信息。
- [ ] 更新 `MEMORY.md`。
- [ ] 更新 `CHANGELOG.md`。
- [ ] 确认 GitHub Pages Source 设置为 `GitHub Actions`。
