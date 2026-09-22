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

该脚本启动 Flutter Web Debug 服务与 VitePress，监听 Dart 文件并请求 Flutter 热重载。Markdown、Vue 和 CSS 由 Vite HMR 更新。按 `Ctrl+C` 只停止本次启动的本地子进程。

开发模式不执行 release 构建，也不复制静态产物。

## 新增组件文档

1. 从 `ui/lib/hy_ui.dart` 导出公开源码。
2. 在 `preview/lib/src/examples/` 编写不含业务依赖的交互示例。
3. 在 `preview_catalog.dart` 注册演示 ID。
4. 在 `.vitepress/catalog.ts` 的对应分类登记组件和演示；`id` 会成为组件路由。
5. 新建 `components/<id>.md`，并写入 `<ComponentDoc component-id="<id>" />`。
6. 确保组件名称、路由、源码路径和演示 ID 唯一。

组件侧栏由目录数据自动生成，分类标题不可跳转，组件名称直接进入独立文档页，不需要手动修改 `config.mts`。VitePress 加载配置时会只读校验公开导出、声明名称、页面路由、源码文件和 PreviewCatalog ID，避免文档与实现分离。

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
| Dart 保存后没有变化 | 查看终端是否发出热重载；结构性修改需要重启 |
| 演示提示资源不完整 | 最终静态预览需重新执行 `npm run build:all` |
| Shader 无法写入 | 不要自行指定项目外输出目录，沿用已有构建脚本 |
