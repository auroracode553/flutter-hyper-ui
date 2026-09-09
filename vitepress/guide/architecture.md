# 文档与预览架构

## 重构目标

旧结构中，一个 `DemoBlock` 对应一个 iframe。组件总览同时出现多个 Demo 时，浏览器会重复下载资源、初始化 Flutter 引擎和创建独立内存堆；移动 iframe 或使用查询参数切换组件还可能重建 browsing context。与此同时，侧栏、Markdown API 表、示例代码和 Flutter 演示目录分别维护，容易产生名称、参数和预览错位。

重构后将“文档数据”和“预览运行时”分离：

```text
ui/lib/src/**/*.dart ──只读导入──> 当前公开签名
          │
          └── hy_ui.dart 导出契约 ──┐
                                    ├── catalog-validation
catalog.ts ──> 侧栏 / 总览 / 分类页 ┤
                                    └── previewId 契约
PreviewCatalog ──> Widget builder ──> ViewCollection
                                           ▲
VitePress DemoBlock ── addView(hostElement)┘
```

## 实时切换流程

1. 首个进入预加载区域的 Demo 加载 `flutter_bootstrap.js`，以 `multiViewEnabled: true` 启动唯一引擎。
2. Dart 入口使用 `runWidget` 启动 `ViewCollection`，等待宿主添加视图。
3. VitePress 为当前 Demo 调用 `app.addView`，将它自己的容器作为 `hostElement`，同时传入组件 ID 和主题。
4. Flutter 根据 `FlutterView.viewId` 读取 `initialData`，构建对应的 `PreviewApp` 和真实 UI 组件。
5. 页面卸载 Demo 时调用 `removeView`；菜单切换只增删视图，Flutter 引擎、运行时和共享内存保持存活。
6. VitePress 主题变化时重建现有视图，但不会重新下载资源或重启引擎。

首次 Flutter Web 下载和引擎初始化无法完全消除，但从第二个 Demo 开始只创建轻量 FlutterView。多个 Demo 可以同时显示真实组件，又不会随着数量线性增加引擎和独立内存堆。

## 为什么不把整套文档改成 Flutter

| 方案 | 优点 | 主要问题 | 结论 |
| --- | --- | --- | --- |
| 全 Flutter 文档站 | UI 与组件同技术栈 | 正文、路由、搜索和首屏全部等待引擎；SEO、代码高亮和 Markdown 维护较弱 | 不采用 |
| Vue 重写演示 | 首屏最快 | 展示的是仿制品，不是真实 Flutter Widget，仍会漂移 | 不采用 |
| iframe | 隔离简单 | 每个 iframe 独立引擎；切换和移动可能重新加载 | 淘汰 |
| VitePress + Flutter multi-view | 文档保持 Web 原生，每个 Demo 渲染真实 Widget，所有视图共享引擎 | 首次仍有 Flutter 冷启动；集成代码更复杂 | 采用 |

## 文档同步规则

- `vitepress/.vitepress/catalog.ts` 只维护分类、说明、示例和预览 ID。
- 分类页、组件总览和 VitePress 侧栏均从目录生成。
- `dart-api.ts` 以 raw module 方式读取实际 Dart 文件并提取公开构造器、静态方法、枚举和 typedef；开发态由 Vite HMR 更新。
- `catalog-validation.ts` 在 VitePress 启动或构建时检查缺失源码、缺失导出、未记录公开 API、重复页面和未注册预览 ID，并尽早失败。
- `PreviewCatalog` 仅承担演示 ID 到 Widget builder 的适配，不保存文档 API 参数。

## 性能边界

- 冷启动：仍取决于 Flutter Web 资源体积、网络和浏览器编译速度，页面提供稳定加载占位。
- 页面切换：不产生 iframe 导航或新 Flutter 引擎，卸载页面只移除对应 FlutterView。
- 文档负载：Dart 源码作为文本进入文档构建，体积远小于额外 Flutter 运行时；API 签名默认折叠。
- 图片演示：外部网络图片仍受第三方响应速度影响，但不会阻塞 Flutter 引擎和其他视图。

## 手动验收建议

按项目约束，由使用者按需手动启动两个开发服务。打开组件总览后可在浏览器开发者工具中确认：页面不存在组件预览 iframe；每个已加载 Demo 内有 Flutter 创建的视图节点；点击 VitePress 菜单后 `flutter_bootstrap.js` 不会再次请求；修改 Dart 构造参数后分类页签名随 Vite 开发更新刷新。
