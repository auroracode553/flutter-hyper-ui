# Flutter pub.dev 发布说明

本项目要发布到 pub.dev 的包位于 `ui/`，`preview/` 只是文档站里的 Flutter Web 示例应用，不需要发布。

## 发布前检查

1. 确认包名唯一。
   - 当前 `ui/pubspec.yaml` 的包名是 `flutter_hyper_ui`。
   - 如果 pub.dev 已存在同名包，需要先改成新的包名。

2. 打开发布开关。
   - 首次公开发布前，删除或注释 `ui/pubspec.yaml` 中的 `publish_to: 'none'`。
   - 如果仍保留 `publish_to: 'none'`，pub 工具会阻止发布到 pub.dev。

3. 补齐 pub.dev 推荐文件。
   - `ui/README.md`：包介绍、安装方式、基础示例。
   - `ui/CHANGELOG.md`：每个版本的变更记录。
   - `ui/LICENSE`：开源许可证文本。
   - 可选：在 `ui/pubspec.yaml` 中补充 `homepage`、`repository`、`issue_tracker`、`topics`。

4. 检查版本号。
   - 修改 `ui/pubspec.yaml` 的 `version`，建议遵循语义化版本。
   - 同一个版本号发布到 pub.dev 后不能覆盖，后续修复必须升版本。
   - 仓库的 GitHub Actions 会在推送 `main` 后按 `ui/pubspec.yaml` 自动创建 `v版本号` 标签；如果标签已存在会跳过。

5. 检查要发布的文件。
   - pub 默认会参考 `.gitignore`。
   - 如果需要和 Git 忽略规则不同，可以在 `ui/` 下增加 `.pubignore`。
   - 发布前重点确认不要包含本地缓存、构建产物、私密配置。

## 手动发布流程

以下命令只作为手动执行参考，请在确认代码、版本、文档都准备好后再运行。

```bash
cd ui
flutter pub get
flutter analyze
flutter test
flutter pub publish --dry-run
```

`--dry-run` 通过后，认真检查终端输出的文件清单。如果还有 warning，建议先处理完再发布。

正式发布：

```bash
cd ui
flutter pub publish
```

首次发布时，pub 工具会引导你登录 Google 账号并授权。发布完成后，pub.dev 会自动生成 API 文档。

## 建议的版本发布节奏

1. 更新 `ui/pubspec.yaml` 的 `version`。
2. 更新 `ui/CHANGELOG.md`。
3. 本地执行 dry-run 并确认文件列表。
4. 提交代码并推送到 `main`。
5. 等 GitHub Actions 自动构建 Pages 并创建版本标签。
6. 在 `ui/` 下执行 `flutter pub publish`。
7. 发布后检查 pub.dev 包页面、版本页和生成的 API 文档。

## 常见问题

- `Package validation found errors`：按 dry-run 输出逐条修复，错误必须修完才能发布。
- `publish_to: none`：删除 `ui/pubspec.yaml` 中的该配置。
- 版本号已存在：pub.dev 不允许覆盖已发布版本，提升 patch/minor/major 版本后重新发布。
- 文件列表包含不该发布的内容：删除文件，或在 `.gitignore` / `ui/.pubignore` 中排除。
