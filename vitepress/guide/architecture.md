# 文档与预览架构

## 调研结论

Flutter 可以编译为浏览器执行的 JavaScript / WebAssembly，并保留 Flutter 渲染引擎；这不等于把 Widget 转换成 Vue 组件或普通 HTML/CSS。官方也建议让文字型页面采用 Web 文档结构，把交互体验嵌入其中。[Flutter Web 工作方式](https://docs.flutter.dev/platform-integration/web)

| 成熟路线 | 官方文档或实际项目 | 适用情况 |
| --- | --- | --- |
| Widgetbook 组件工作台 | [Widgetbook](https://docs.widgetbook.io/)、[Embedding](https://docs.widgetbook.io/essentials/embedding) | 隔离开发、调节组件状态、设计评审；其文档嵌入示例使用 iframe，不符合本项目当前约束 |
| 整站 Flutter 组件画廊 | [shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter) 的 `packages/docs/` | 文档与组件都用 Flutter 编写，展示真实 Widget；需要迁移现有 Markdown 文档体系 |
| Web 文档 + Flutter DOM 直接嵌入 | [Flutter 官方嵌入文档](https://docs.flutter.dev/platform-integration/web/embedding-flutter-web)、[官方 web_embedding 示例](https://github.com/flutter/samples/tree/main/web_embedding) | 保留文档的 HTML、搜索和代码展示，同时在容器内展示真实组件 |

本项目选择第三条路线。开发模式通过 Vite 同源代理连接 Flutter Debug 服务，发布模式使用同源 release 静态包；两者复用相同的多视图协议。这是一种基于官方接口的项目实现，不是把 Dart 转换成 Vue 组件。

## 与旧实现的区别

开发服务不再由浏览器跨站直连，而是由 Vite 将 `/preview` 同源代理到固定的 Flutter Web Debug 服务。watcher 监听 Dart 文件并向 Flutter 进程发送热重载指令，因此开发期间无需 release 构建或文件复制。

发布模式仍只读取同站点完整 release 包；CanvasKit 的 JS/Wasm 从包内读取。Debug 与 Release 共用 `hyUiPreviewBundle` 协议，加载器根据构建时环境选择是否执行 release 身份检查。

## 数据与控制流

```text
开发：Dart 保存 → watcher → Flutter hot reload → Vite /preview 同源代理
发布：build:all → Flutter build/web → 自动同步 public/preview → VitePress build

DemoBlock → bundle-loader → Debug 代理 / release 静态包 → Flutter 引擎（每页一个）
    ↓                                                   ↓
preview-view ───── addView(hostElement, initialData) ──→ ViewCollection
    ↑                                                       ↓
隐藏加载占位 ←──────────── Dart 首帧提交回调 ─────────── PreviewApp
```

- `contracts.ts` 定义协议、视图参数和错误状态。
- `bundle-loader.ts` 负责选择 Debug/Release 资源、检查 release 包身份、加载脚本和启动唯一引擎。
- `preview-view.ts` 只负责一个 DOM 容器的视图、超时、首帧与销毁。
- `preview-runtime.ts` 连接页面可见性和主题变化。
- `preview/web/flutter_bootstrap.js` 使用官方 `_flutter.loader.load` / `initializeEngine` / `runApp`，显式配置资源根目录与 CanvasKit 目录。
- `PreviewApp` 第一帧提交后调用宿主注入的 `onFirstFrame`；这是渲染流程确认，不是每个异步图片资源都已完成加载的保证。

初始化与资源配置依据 [Flutter 官方初始化文档](https://docs.flutter.dev/platform-integration/web/initialization)。

## 生命周期与失败边界

release 包身份检查 12 秒、脚本 15 秒、引擎 60 秒、视图首帧 20 秒分别设置上限。HTTP 200 但返回 HTML不会通过 `version.json` 检查。Debug 模式允许 Flutter 调试编译目标，Release 模式仍要求标准 `dart2js` 构建。

加载前失败可以重试。脚本超时、接口不兼容和引擎初始化失败要求刷新，防止复用已经部分初始化的 Flutter 全局状态。卸载 Demo 会断开观察器、移除视图、清理首帧定时器；迟到回调通过实例代次与卸载状态过滤。

主题切换会重建现有视图，临时交互状态会重置。开发 watcher 不写入 `vitepress/public/preview`。本地完整构建脚本让 Flutter 输出到默认的 `preview/build/web`，验证成功后自动镜像到 `vitepress/public/preview`，避免 Windows shader 编译器处理项目外输出路径。静态目录需要作为完整版本一起发布。

## 验证边界

脚本不会自动安装依赖或部署。开发服务与完整构建都必须由使用者显式启动，使用方式见[快速开始](./getting-started.md)。
