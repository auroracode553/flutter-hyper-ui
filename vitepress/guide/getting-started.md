# 快速开始

文档直接读取与自身一起分发的 Flutter Web release 产物，并将真实 Widget 挂载到文档的 DOM 容器中。无需启动 4201，不使用 iframe、跨域代理或 Flutter 调试引导程序。

## 依赖清单

核心和预览需要 Flutter >= 3.32、Dart >= 3.8；预览通过本地路径引用 `ui/`。文档依赖已有的 VitePress、Vue 和 Node.js，具体版本见 `vitepress/package.json`。本次没有新增依赖；环境准备与依赖安装由使用者自主进行。

## 手动准备预览包

以下指令只是手动说明，不由项目自动执行。

1. 进入 `preview/`，手动执行 `flutter build web --release --no-web-resources-cdn --base-href /preview/ --output ../vitepress/public/preview`。Flutter 直接生成文档所需的整包，无需手动复制。
2. 进入 `vitepress/`，手动执行 `npm run dev`，访问终端显示的地址。

标准 JS release 构建输出 `main.dart.js`，本方案显式选择包内 CanvasKit，不使用 `--wasm`。`--no-web-resources-cdn` 让构建包含本地引擎资源，启动接口同时将 `canvasKitBaseUrl` 指向包内目录。

```text
vitepress/public/preview/
  hy-preview.json
  flutter_bootstrap.js
  main.dart.js
  index.html
  assets/
  canvaskit/
    canvaskit.js
    canvaskit.wasm
```

这里只列核心文件，Flutter 会直接输出完整构建目录。`preview/web/flutter_bootstrap.js` 中的 Flutter 模板必须经过构建展开；不能把源码目录当成产物目录。

抽屉示例在“反馈与弹层”文档内；独立画廊地址为 `/preview/index.html?component=drawer`。后者同样使用静态构建产物。

## 更新与部署路径

- Dart 改动：重新执行上述构建指令，直接更新文档目录，再刷新文档。此模式不提供 Flutter 热重载。
- Markdown/Vue 改动：由 VitePress 更新页面。
- 主题变化：移除并重新创建当前 Flutter 视图，预览表单等临时状态会重置。
- 子路径部署：例如文档在 `/flutter-hyper-ui/`，Flutter 手动构建时使用 `--base-href /flutter-hyper-ui/preview/`，文档的 `VITEPRESS_BASE` 使用 `/flutter-hyper-ui/`。
- 浏览器统一读取 `${BASE_URL}preview/`，不再支持 `VITE_PREVIEW_BASE`、`FLUTTER_PREVIEW_TARGET` 和 4201 代理。

## 错误与恢复

| 页面提示 | 含义与处理 |
| --- | --- |
| 预览构建产物缺失、不兼容或不可访问 | 检查 `/preview/hy-preview.json` 是否返回 JSON，而不是 404 或 HTML；按上述步骤准备整包 |
| 启动脚本不是本项目的静态预览构建 | 当前目录是旧构建或源码；使用上述输出目录重新构建 |
| 不接收 flutter run 调试产物 | 需要标准 Flutter Web release 构建 |
| 初始化超过 60 秒 | 检查 `main.dart.js`、`canvaskit/canvaskit.js`、`canvaskit/canvaskit.wasm` 的响应及 Console 错误 |
| 未在 20 秒内提交首帧 | 引擎已启动，但 Dart 示例没有确认首帧；检查 Dart 错误、容器大小及整包版本 |

资源清单请求最多等待 12 秒，启动脚本最多等待 15 秒。引擎启动前的连接失败可以重试；脚本部分执行或引擎开始初始化后的失败需要刷新页面，避免在原页面重复初始化引擎。

CanvasKit 从本地静态包加载，但示例中的远程图片、Flutter 字体回退仍可能访问外网。本方案不宣称完全离线；需要离线展示时，应另行打包所需图片和覆盖全部文字的字体。

## 手动验收

1. 关闭 4201 服务后访问文档，真实组件仍能渲染；Network 不应请求 4201 或调试脚本。
2. 首次加载请求一个预览包；同页多个 Demo 共用引擎，页面没有预览 iframe。
3. 打开左右抽屉、切换主题、切换文档页，确认内容和视图清理正常。
4. 缺少预览包时明确显示错误；补齐后点击重试。引擎错误和首帧超时不应无限显示加载中。
5. 若部署到子路径，分别验证文档 Demo 与独立画廊入口。

按仓库约束，本次未执行上述构建和验收步骤。
