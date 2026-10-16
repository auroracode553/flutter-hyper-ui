# 业务项目接入与 AGENTS.md 模板

接入 Hyper UI 时，把界面规范、共用布局入口和完成检查一并保存在业务项目中。以下模板只约束 Hyper UI 的使用，合并到业务项目现有 `AGENTS.md`，保留该项目已有的架构、运行和交付规则。

## 接入顺序

1. 按[快速开始](./getting-started.md)接入依赖和 HyperUiTheme。
2. 复制 [TabBar 的共用悬浮宿主](../components/tab-bar.md#悬浮页面宿主)，保存为 `lib/widgets/app_floating_tab_scaffold.dart`。已有等价宿主时复用现有实现，并同步调整模板中的名称和路径。
3. 将下面的模板合并到**业务项目根目录**的 `AGENTS.md`。
4. 修改 UI 后执行静态分析，检查完整布局树，并按业务项目允许的方式验证界面。

Hyper UI 仓库自己的 `AGENTS.md` 用来约束库内开发。业务项目仅通过 path、Git 或包依赖引用组件，不会因此继承依赖仓库的指令文件。以 Codex 为例，它按全局目录以及当前项目根目录到工作目录的路径加载指令，具体范围见 [OpenAI 的 AGENTS.md 文档](https://learn.chatgpt.com/docs/agent-configuration/agents-md)。使用其他编码工具时，同时核对该工具支持的指令文件与加载范围。

## 可复制模板

模板引用的 AppFloatingTabScaffold 和 AppPageScrollEnd 是上一步复制到业务项目的类。不要在没有这些实现时直接照搬名称，也不要添加指向不存在的布局检查脚本的强制命令。

```markdown
# Hyper UI 使用规则

## UI 组件

- 本项目使用 flutter_hyper_ui。新增或修改标准控件必须使用 Hyper UI 或项目已有的 Hyper UI 封装。
- 底部导航使用 HyperTabBar，分段切换使用 HyperSegmentedControl，顶部导航使用 HyperNavBar，按钮使用 HyperButton，标准弹窗使用 HyperDialog。
- 禁止用 Container、InkWell、GestureDetector、AnimatedContainer 等重复实现库中已有控件，禁止用 Material/Cupertino 控件替代已有 Hyper UI 控件。
- Scaffold 等页面机制、基础布局、文本、图标和业务专用绘制可以使用 Flutter 基础组件；外观差异通过公开参数、插槽、HyperUiTheme 和主题 tokens 配置。
- 修改前查阅当前依赖版本的组件接口和示例，不凭组件名猜测默认安全区、边距或高度。

## 悬浮底部导航

- 所有底部 Tab 页面复用 lib/widgets/app_floating_tab_scaffold.dart 中的 AppFloatingTabScaffold。页面只注入导航项、选中索引、回调和正文。
- 只有共用宿主可以创建 HyperTabBar 和设置 Scaffold.bottomNavigationBar；宿主必须使用 extendBody: true，底栏 Align 使用 heightFactor: 1。
- HyperTabBar 负责底栏安全区和边距，外层禁止重复包底部 SafeArea/Padding。正文需要 SafeArea 时显式设置 bottom: false，顶部安全区也只处理一次。
- 正文必须可以绘制和滚动到底栏后方。禁止把底栏或避让用 SizedBox 放在正文 Column 的底部，禁止硬编码底栏高度挤压视口。
- 最后一项需要滚出遮挡时，在滚动内容内部末尾使用 AppPageScrollEnd；不得放在滚动容器外，不得再叠加 viewPadding.bottom 或另一份底栏高度。
- ListView 的自动安全区 padding 与手动末尾余量只选一个来源，避免重复避让。

## 修改完成检查

- 修改控件后重新检查宿主、正文、滚动容器、安全区、底栏这条完整布局链，不能只替换组件名。
- 对改动的 Dart 文件做格式检查，并运行 dart analyze。项目已有布局检查脚本时，同时执行实际存在的检查命令。
- 检查正文能滚过底栏后方、末项能完整滚出遮挡，以及大字体、横屏、系统安全区和键盘出现时的布局。
- 遵守业务项目的运行、依赖安装、测试、打包和部署限制。
- 未做界面/真机验收时明确说明；静态分析通过不能作为视觉验收通过的依据。
```

## 布局检查与交付

AGENTS.md 保存约定；共用宿主集中实现约定；源码检查负责发现结构上的违规。业务项目可以给检查工具设置以下规则，并将其实际运行命令写入自己的 AGENTS.md：

| 检查对象 | 需要检查的结构 |
| --- | --- |
| HyperTabBar 的创建位置 | 只出现在共用悬浮宿主中 |
| 共用 Scaffold | extendBody 为 true，底栏使用 bottomNavigationBar |
| 底栏外层 | Align 按内容高度收缩，不叠加固定高度、底部 SafeArea 或 Padding |
| 正文安全区 | 需要 SafeArea 时 bottom 为 false，顶部安全区不重复处理 |
| 滚动末尾 | AppPageScrollEnd 位于滚动内容中；ListView 自动 padding 与额外余量不重复 |

可以先通过 IDE 搜索或以下只读命令检查调用位置；文本搜索结果仍需结合组件树判断：

```sh
rg -n 'HyperTabBar\s*\(|bottomNavigationBar\s*:|extendBody\s*:|SafeArea\s*\(|viewPadding|AppPageScrollEnd\s*\(' lib -g '*.dart'
dart analyze lib
```

源码检查可以接入业务项目已有的提交检查或 CI；它覆盖可见结构，视觉行为仍需界面验收。验收时确认短内容与长列表、大字体、横竖屏和不同系统安全区下，最后一个内容项都能露出，底栏周围没有额外的固定空白区域。
