# Hy UI · Flutter Hyper UI

面向移动端的柔光玻璃组件库。所有组件使用 `Hy` 前缀，文件使用 `hy_` 命名，入口为 `package:flutter_hyper_ui/hy_ui.dart`。

视觉参考 fast-buy-flutter 的悬浮 TabBar 和设置菜单：半透明材质、柔和高光、低饱和背景、16 / 24 / 28 dp 圆角与轻阴影。提供明暗主题、导航选中动效及减少动画适配。

## 源码结构

- `ui/lib/hy_ui.dart`：公共导出入口。
- `ui/lib/src/theme/`：色彩、主题令牌、间距和圆角。
- `ui/lib/src/components/`：基础、布局、表单、反馈、导航、列表与业务组件；按功能拆分文件。
- `ui/lib/src/utils/`：屏幕适配、路由、键盘、安全区与主题控制器。
- `preview/lib/src/examples/`：可交互示例，含模拟上传与分页失败重试。
- `vitepress/components/catalog.md`：完整组件映射、使用约定、适配接口与手动验收说明。

依赖关系：应用 → 公共入口 → 组件 / 工具 → 主题。上传适配器通过构造参数注入，不包含业务 API 或全局状态。

## 组件与示例

覆盖基础原子、布局容器、表单、反馈、导航、列表、业务组件和工具八类需求。完整列表见 [组件文档](vitepress/components/catalog.md)。

预览入口支持 `?component=atoms`、`layout`、`forms`、`overlays`、`full-navigation`、`business`，以及原有按钮、卡片等示例。独立预览右上角可切换明暗主题。

## 依赖清单

核心库：Flutter >= 3.32、Dart >= 3.8；没有新增第三方运行时依赖。

现有开发依赖：flutter_test、flutter_lints。文档使用 Node.js、VitePress、Vue。

可选平台能力：由应用选择相册 / 摄像头 / 文件选择插件及 HTTP 客户端，通过 `HyFilePicker` 和 `HyFileUpload` 接入；本次没有安装依赖或修改系统权限配置。图片默认使用 Flutter 内存缓存，持久缓存可注入 ImageProvider。

## 验证状态

按项目约束仅编辑源码和文档，未运行、编译、打包、部署项目，未执行 Flutter 分析器或测试。已进行源码引用、命名、文件长度与分隔符静态检查。视觉与平台交互仍需使用者手动验证。

上传示例为显式标记的模拟适配器，核心库已实现选择入口、预览、删除、进度、重试和取消信号；实际相册权限、拍照与服务器上传由应用适配器实现。