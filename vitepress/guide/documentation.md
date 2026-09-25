# 文档开发

文档由 VitePress、Flutter Web 预览应用和 UI 包组成。所有命令均由使用者手动执行，脚本不会安装依赖或部署。

## 目录职责

```text
ui/          Flutter UI 组件库
preview/     独立的 Flutter 交互示例
vitepress/   文档页面、目录数据和预览宿主
tools/       本地开发与构建编排脚本
```

## 本地开发

在 `vitepress/` 目录手动启动：

```powershell
npm run dev:watch
```

该脚本启动 Flutter Web Debug 服务与 VitePress，默认使用 AMD 调试模块，监听 Dart 文件并请求 Flutter 热重启。这样可以避开 DDC 在 Dart 入口前加载整套模块的等待。Markdown、Vue 和 CSS 由 Vite HMR 更新。按 `Ctrl+C` 只停止本次启动的本地子进程。

如果需要 DDC 热重载，可在 Windows PowerShell 中先设置 `$env:HY_UI_PREVIEW_AMD='0'`，再运行脚本。还可以用 `HY_UI_FLUTTER_PORT` 和 `HY_UI_VITE_PORT` 覆盖本地端口。

首次打开预览时，Flutter Debug 会先编译，再通过浏览器加载 Dart SDK 和大量 DDC JavaScript 模块。页面显示“加载 Dart 模块”时，Flutter 启动脚本已返回，正在下载或执行调试模块；数字是已完成的脚本请求数，不是编译百分比。Debug 的 `main.dart.js` 是引导脚本，开发预览会同时预取后续所需的 SDK 和模块加载器。浏览器控制台中的 `[Hy UI 预览] 首次加载耗时` 分别列出启动脚本等待、Dart 模块和 Flutter 引擎的耗时，以及最慢脚本；可据此判断慢在 Flutter 首编译、DDC 模块传输与执行，还是渲染引擎。首次冷启动通常比后续刷新慢。

预览入口通过 `hy_ui_preview_core.dart` 只同步加载 Flutter 外壳所需的主题和基础组件。示例文件通过 Dart `deferred` 导入，当前视图建立后才调用对应文件的 `loadLibrary()`；同文件内的示例共享加载结果。Flutter 外壳首帧出现时，文档骨架屏退场，当前组件在 Flutter 页面内继续显示加载状态；真实组件提交首帧后才标记为完成。远离视口的文档示例不会主动创建视图。首次仍需下载 Flutter 引擎与 Dart SDK，但不会为了一个组件等全部示例代码加载完。控制台中的 `[Hy UI 预览] 组件加载耗时` 可以继续区分外壳首帧和当前示例模块的耗时。

开发模式不执行 release 构建，也不复制静态产物。

## 新增组件文档

1. 从 `ui/lib/hy_ui.dart` 导出公开源码。
2. 在 `preview/lib/src/examples/` 编写不含业务依赖的交互示例。
3. 在 `preview_catalog.dart` 注册演示 ID。
4. 在 `.vitepress/catalog.ts` 的对应分类登记组件并配置 `preview`；`id` 会成为组件路由，组件页不会回退到分类组合 Demo。
5. 新建 `components/<id>.md`，并写入 `<ComponentDoc component-id="<id>" />`。
6. 确保组件名称、路由、源码路径和演示 ID 唯一。

组件侧栏由目录数据自动生成，分类标题不可跳转，组件名称直接进入独立文档页，不需要手动修改 `config.mts`。每个组件条目都必须配置专属预览，ID 固定为 `component-<id>`；同一文件包含多个独立场景时，用 `doc-region` 标记当前组件的源码片段。VitePress 加载配置时会只读校验公开导出、声明名称、页面路由、预览完整性、预览 ID、源码片段、源码文件和 PreviewCatalog ID，避免文档与实现分离。

## 静态文档构建

最终验收时由使用者手动执行：

```powershell
npm run build:all
```

脚本依次构建 Flutter Web release、同步完整预览包并构建 VitePress，不执行部署。部署到子路径时可在运行前设置 `PREVIEW_BASE_HREF` 与 `VITEPRESS_BASE`。

## 预览架构

文档文字、搜索和代码块保持为 HTML；真实 Widget 通过 Flutter 官方 multi-view API 挂载到 DemoBlock 的 DOM 容器中。页面只启动一个 Flutter 引擎，每个可见 Demo 创建独立 FlutterView。

```text
DemoBlock → preview-runtime → bundle-loader → Flutter engine
    ↓                                             ↓
DOM host  ←──────────── addView / first frame ─── ViewCollection
```

开发环境由 Vite 将 `/preview` 代理到 Flutter Debug 服务；静态文档读取同站点的完整 release 预览包。两种模式共用相同的宿主协议。

## 常见问题

| 现象 | 处理 |
| --- | --- |
| 端口被占用 | 关闭旧开发进程，再手动重新启动 watcher |
| Dart 保存后没有变化 | 查看终端是否发出热重启；结构性修改仍可手动重启 |
| 演示提示资源不完整 | 最终静态预览需重新执行 `npm run build:all` |
| Shader 无法写入 | 不要自行指定项目外输出目录，沿用已有构建脚本 |
