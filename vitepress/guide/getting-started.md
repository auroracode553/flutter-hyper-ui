# 快速开始

文档开发模式同时运行 VitePress 和 Flutter Web Debug 服务。VitePress 将 `/preview` 同源代理到 Flutter，真实 Widget 仍通过官方 multi-view API 挂载到文档 DOM；不使用 iframe，也不复制构建产物。

## 依赖清单

- Flutter >= 3.35，推荐使用当前项目的 Flutter 3.47；Web 热重载从 3.35 起默认启用。
- Dart 与 Flutter SDK 配套。
- Node.js，以及 `vitepress/package.json` 中已有的 VitePress、Vue 依赖。
- 预览应用通过本地路径依赖 `ui/`，没有新增第三方运行依赖。

依赖和系统环境由使用者自主准备，项目脚本不会自动安装或部署。

## 启动开发文档

在 `vitepress/` 目录只需启动一次 watcher：

```powershell
cd D:\my_project\flutter_project\flutter-hyper-ui\vitepress
npm run dev:watch
```

脚本会完成以下工作：

1. 启动 `flutter run -d web-server` 调试服务。
2. 启动 VitePress 开发服务。
3. 将文档的 `/preview` 请求代理到 Flutter 调试服务。
4. 监听 `ui/lib/**/*.dart` 和 `preview/lib/**/*.dart`。
5. Dart 文件保存后自动向 Flutter 发送热重载指令。
6. 按 `Ctrl+C` 时只停止本次启动的两个本地子进程。

访问：

- 文档首页：`http://localhost:9000/`
- 组件总览：`http://localhost:9000/components/catalog`

开发模式不执行 `flutter build web`，不生成 release 包，也不向 `vitepress/public/preview` 复制文件。Markdown、Vue 和 CSS 由 Vite HMR 更新；Dart 组件由 Flutter 原生热重载更新。

## 热重载边界

普通 Widget 构建逻辑、样式和交互修改可以热重载，并尽量保留状态。以下变化通常需要停止并重新运行 `npm run dev:watch`：

- 修改 `pubspec.yaml`、依赖或资源声明。
- 修改 Web 启动模板或 `flutter_bootstrap.js`。
- 修改 `main()`、初始化流程，或进行 Flutter 不支持热重载的类型结构变化。
- Flutter 或 VitePress 子进程异常退出。

## 构建完整静态文档

最终验收或发布前，在 `vitepress/` 手动启动本地构建脚本：

```powershell
cd D:\my_project\flutter_project\flutter-hyper-ui\vitepress
npm run build:all
```

脚本按顺序执行 Flutter release 构建、自动同步完整产物、VitePress 构建。Flutter 始终先输出到默认的 `preview/build/web`，因此不会触发 Windows 自定义 `--output` 的 shader 写入问题。同步由脚本完成，用户不需要复制文件。脚本不会部署。

部署到子路径时，可在运行脚本前设置：

```powershell
$env:PREVIEW_BASE_HREF = '/flutter-hyper-ui/preview/'
$env:VITEPRESS_BASE = '/flutter-hyper-ui/'
npm run build:all
```

release 文档包含：

```text
vitepress/public/preview/
  version.json
  flutter_bootstrap.js
  main.dart.js
  index.html
  assets/
  canvaskit/
```

## 常见问题

| 现象 | 处理 |
| --- | --- |
| 端口 4201 或 9000 被占用 | 关闭占用端口的旧开发进程，再重新运行 watcher |
| 文档提示无法读取启动脚本 | 确认 watcher 中的 Flutter 服务没有退出，然后刷新页面 |
| Dart 保存后没有变化 | 查看 watcher 终端是否输出“请求 Flutter 热重载”；结构性修改需要重启 watcher |
| `ShaderCompilerException: Could not write file` | 不要自行添加项目外 `--output`；使用 `npm run build:all` |
| release 预览包不完整 | 重新执行 `npm run build:all`，脚本会先验证 `main.dart.js` 再同步 |

## 文档中的交互预览

每个 Demo 支持自适应/手机宽度切换、状态重置、全屏、真实源码展开和复制。展示源码直接读取 `preview/lib/src/examples/`，与实际运行的示例保持同源。

新增演示时，先在 `preview/lib/src/preview_catalog.dart` 注册 Demo ID，再在 `vitepress/.vitepress/catalog.ts` 的对应分类加入相同 ID 和源码文件。VitePress 启动或构建时会检查 ID、源码路径和公开组件目录。
