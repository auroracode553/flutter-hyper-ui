# 文档与预览架构

## 调研结论

Flutter 可以编译为浏览器执行的 JavaScript / WebAssembly，并保留 Flutter 渲染引擎；这不等于把 Widget 转换成 Vue 组件或普通 HTML/CSS。官方也建议让文字型页面采用 Web 文档结构，把交互体验嵌入其中。[Flutter Web 工作方式](https://docs.flutter.dev/platform-integration/web)

| 成熟路线 | 官方文档或实际项目 | 适用情况 |
| --- | --- | --- |
| Widgetbook 组件工作台 | [Widgetbook](https://docs.widgetbook.io/)、[Embedding](https://docs.widgetbook.io/essentials/embedding) | 隔离开发、调节组件状态、设计评审；其文档嵌入示例使用 iframe，不符合本项目当前约束 |
| 整站 Flutter 组件画廊 | [shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter) 的 `packages/docs/` | 文档与组件都用 Flutter 编写，展示真实 Widget；需要迁移现有 Markdown 文档体系 |
| Web 文档 + Flutter DOM 直接嵌入 | [Flutter 官方嵌入文档](https://docs.flutter.dev/platform-integration/web/embedding-flutter-web)、[官方 web_embedding 示例](https://github.com/flutter/samples/tree/main/web_embedding) | 保留文档的 HTML、搜索和代码展示，同时在容器内展示真实组件 |

本项目选择第三条路线，并把运行模式收敛为 **同源 release 静态包**。这是一种基于官方接口的项目实现，不是安装一个插件后自动将 Dart 转换为文档组件。

## 与旧实现的区别

旧实现实际上已经使用 multi-view，没有 iframe；但开发模式仍跨站引入 `flutter run` 产物，涉及调试引导、调试连接、外部引擎资源和加载失败缓存。仅检查端口与脚本 HTTP 200 不能证明引擎运行成功。

新实现删除开发服务地址覆盖和代理。开发、发布都读取同一目录结构的 release 产物；CanvasKit 的 JS/Wasm 明确从包内读取。仍需 Flutter 引擎，无法承诺瞬时首屏，但失败会按阶段结束并提示。

## 数据与控制流

```text
Dart UI 组件 → 预览示例 → 使用者手动 Flutter release 构建
                               ↓
                 vitepress/public/preview/ 完整静态包
                               ↓
DemoBlock → bundle-loader → bootstrap → Flutter 引擎（每页一个）
    ↓                                  ↓
preview-view ───── addView(hostElement, initialData) ──→ ViewCollection
    ↑                                                       ↓
隐藏加载占位 ←──────────── Dart 首帧提交回调 ─────────── PreviewApp
```

- `contracts.ts` 定义协议、视图参数和错误状态。
- `bundle-loader.ts` 只负责读取清单、加载启动脚本和启动唯一引擎。
- `preview-view.ts` 只负责一个 DOM 容器的视图、超时、首帧与销毁。
- `preview-runtime.ts` 连接页面可见性和主题变化。
- `preview/web/flutter_bootstrap.js` 使用官方 `_flutter.loader.load` / `initializeEngine` / `runApp`，显式配置资源根目录与 CanvasKit 目录。
- `PreviewApp` 第一帧提交后调用宿主注入的 `onFirstFrame`；这是渲染流程确认，不是每个异步图片资源都已完成加载的保证。

初始化与资源配置依据 [Flutter 官方初始化文档](https://docs.flutter.dev/platform-integration/web/initialization)。

## 生命周期与失败边界

清单 12 秒、脚本 15 秒、引擎 60 秒、视图首帧 20 秒分别设置上限。HTTP 200 但返回 HTML 不会通过 JSON 清单检查。启动接口验证构建目标，拒绝 DDC 调试入口。

加载前失败可以重试。脚本超时、接口不兼容和引擎初始化失败要求刷新，防止复用已经部分初始化的 Flutter 全局状态。卸载 Demo 会断开观察器、移除视图、清理首帧定时器；迟到回调通过实例代次与卸载状态过滤。

主题切换会重建现有视图，临时交互状态会重置。组件更新时通过 `--output ../vitepress/public/preview` 直接重新构建到文档目录，无需复制。静态目录需要作为完整版本一起发布，协议清单只能检查接口兼容性，不能替代完整包的一致性管理。

## 验证边界

源码重构不包含构建产物。本次按仓库约束未运行项目、编译、安装或执行测试；实际预览要在使用者完成[手动构建与验收](./getting-started.md)后验证。
