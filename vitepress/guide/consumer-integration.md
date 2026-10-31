# 业务项目接入与 AGENTS.md 模板

接入 Hyper UI 时，把界面规范、共用布局入口和完成检查一并保存在业务项目中。以下模板只约束 Hyper UI 的使用，合并到业务项目现有 `AGENTS.md`，保留该项目已有的架构、运行和交付规则。

## AI 与开发者开始前必读

先读本文的页面开发规范，再读[设计系统基线](./design-system.md)，最后核对当前依赖版本的组件 API、源码与真实预览。处理背景、安全区、导航或卡片时也必须遵守此顺序，不得凭以往组件经验直接修改布局。库内维护同样受根目录 AGENTS.md 约束。

业务项目根目录的 AGENTS.md 必须指向实际依赖库的这两份文档。下面模板中的“HyperUI库根目录”需要替换为实际 path/Git 依赖的本地目录；包依赖则指向该版本已提供的使用规范。不要保留无法访问的占位路径，也不能假设依赖仓库的 AGENTS.md 会自动生效。

## 全面屏与页面开发规范

1. 在应用启动入口全局开启 SystemUiMode.edgeToEdge，主入口和独立 Flutter/Activity 入口共用配置；具体入口代码见[全局全面屏](./getting-started.md#应用全局全面屏)。HyperUiTheme.app 提供主题，不代替应用入口的系统 UI 配置。
2. 全局主题宿主配置透明状态栏和手势导航栏，并随实际主题设置图标亮暗。页面画布使用 background 覆盖整个屏幕，不为系统栏另画色块；内容卡片保留独立表面和阴影。
3. 所有页面正文可延伸到系统手势区，不在整页外层套底部 SafeArea，不用安全区高度的固定容器裁短正文。固定操作控件可以局部避让；滚动末项需要避让时，将余量放在滚动内容内且只计算一次。
4. Navbar 使用库内滚动渐变和渐显/渐隐；滚动内容需要经过导航后方时使用覆盖式宿主并将首屏净空放进滚动内容。不得通过实色底板或业务宿主裁切盖住滚动渐变。库内部将渐变和渐隐限定在状态栏顶部至 Navbar 底部，正文区域不参与绘制。顶部图标和标题只避让一次安全区。
5. TabBar 保持原有悬浮布局，周围透明，正文能够滚入其后方。single 独立入口固定直径 48 逻辑像素，multiple 按钮组默认高 56，并排垂直居中；禁止在库中改成等高或由业务覆写尺寸。改配色或阴影不能改变底栏高度、占位、位置、边距、安全区、正文视口或滚动范围；不添加全宽底板和局部主题包装。
6. 普通正文使用 HyperCard、HyperMenuGroup 等公开组件；库内对应组件复用 HyperGlass.card，共用无普通描边和双层柔阴影。选中、高对比、输入、提示和浮层保留各自语义。
7. 键盘出现时，编辑表单仍应正确缩小并允许底部输入项滚动到可见范围；全面屏不等于关闭 resizeToAvoidBottomInset，也不等于让固定按钮与系统手势冲突。

独立顶部渐变使用 [HyperScrollGradient](../components/scroll-gradient.md)，Navbar 共用同一实现和主滚动作用域，不采样正文。HyperNavBar.type 仅区分 standard（标准操作行）和 simple（真实状态栏/挖孔，无标题与操作行）；standard 的内容布局由 layout 选择。首屏净空只进入滚动内容，不增加永久占位。

## 接入顺序

1. 先完成上面的必读顺序，再按[快速开始](./getting-started.md)接入依赖、HyperUiTheme 和应用全局全面屏。
2. 复制 [TabBar 的共用悬浮宿主](../components/tab-bar.md#悬浮页面宿主)，保存为 `lib/widgets/app_floating_tab_scaffold.dart`。已有等价宿主时复用现有实现，并同步调整模板中的名称和路径。
3. 将下面的模板合并到**业务项目根目录**的 `AGENTS.md`。
4. 修改 UI 后执行静态分析，检查完整布局树，并按业务项目允许的方式验证界面。

普通 Scaffold 的 appBar/body 使用 HyperNavBar 时，导航自动接入框架内置的 ScrollNotificationObserver，页面无需另写监听。非 Scaffold 宿主或需要限定正文来源时，使用 [HyperNavBarScrollScope](../components/nav-bar.md#自动滚动作用域) 包装导航与主视口的共同父级。已有共用页面宿主继续复用；显式作用域优先，不重复订阅框架观察者。

分页、保留 Tab 或嵌套滚动时，在各主视口外使用 HyperNavBarScrollScope.source，传入已有 scrollController 及 active；普通列表继续自动监听通知。控制器仍归业务持有，不在页面另写导航专用监听、滚动判断、缓存或回调链。绑定不改变原有滚动与底栏布局，业务分页加载和吸附等监听按职责保留。

Hyper UI 仓库自己的 `AGENTS.md` 用来约束库内开发。业务项目仅通过 path、Git 或包依赖引用组件，不会因此继承依赖仓库的指令文件。以 Codex 为例，它按全局目录以及当前项目根目录到工作目录的路径加载指令，具体范围见 [OpenAI 的 AGENTS.md 文档](https://learn.chatgpt.com/docs/agent-configuration/agents-md)。使用其他编码工具时，同时核对该工具支持的指令文件与加载范围。

## 可复制模板

模板引用的 AppFloatingTabScaffold 和 AppPageScrollEnd 是上一步复制到业务项目的类。不要在没有这些实现时直接照搬名称，也不要添加指向不存在的布局检查脚本的强制命令。

```markdown
# Hyper UI 使用规则

## 开发前必读

- 新增、修改页面或 UI 前，先阅读 HyperUI库根目录/vitepress/guide/consumer-integration.md 与 HyperUI库根目录/vitepress/guide/design-system.md，再核对当前依赖版本的相关组件 API、源码与预览。
- 用户的配色、阴影或重构要求不授权修改底栏布局；发生规则冲突时以用户最新的明确要求为准，不自行扩大改动范围。

## 应用全局全面屏

- 应用启动入口全局开启 SystemUiMode.edgeToEdge；独立 Flutter 入口和 Activity 使用同一系统 UI 配置，不逐页切换系统模式。
- 全局主题宿主统一透明状态栏、透明手势导航栏与亮暗图标。页面背景延伸至屏幕边缘，使用 background；卡片继续使用库内表面及阴影。
- 全部页面禁止整页底部 SafeArea 和固定安全区占位裁短正文。必要避让交给具体控件或滚动末尾，只处理一次；键盘出现时表单仍可缩小和滚动。
- HyperNavBar 保留库内滚动渐变与渐显/渐隐，禁止实色底板、业务宿主裁切或手写渐变覆盖原有效果。需要内容滚过导航后方时，首屏顶部净空应放在滚动内容内；库内部的渐变和渐隐只覆盖状态栏顶部至 Navbar 底部，不向正文延伸。

## UI 组件

- 本项目使用 flutter_hyper_ui。新增或修改标准控件必须使用 Hyper UI 或项目已有的 Hyper UI 封装。
- 底部导航使用 HyperTabBar，分段切换使用 HyperTabs，顶部导航使用 HyperNavBar，按钮使用 HyperButton，标准弹窗使用 HyperDialog。
- 禁止用 Container、InkWell、GestureDetector、AnimatedContainer 等重复实现库中已有控件，禁止用 Material/Cupertino 控件替代已有 Hyper UI 控件。
- Scaffold 等页面机制、基础布局、文本、图标和业务专用绘制可以使用 Flutter 基础组件；外观差异通过公开参数、插槽、HyperUiTheme 和主题 tokens 配置。
- 修改前查阅当前依赖版本的组件接口和示例，不凭组件名猜测默认安全区、边距或高度。
- 普通 Scaffold 的导航滚动由 HyperNavBar 自动感知；需要限定正文来源或非 Scaffold 宿主时共用 HyperNavBarScrollScope。已有共用宿主继续复用，显式作用域优先；不逐页复制滚动状态、监听或 BackdropFilter。
- 分页、保留 Tab 和嵌套滚动的主视口使用 HyperNavBarScrollScope.source 绑定已有 scrollController 及 active；禁止页面自行计算、缓存或转发导航 scrolledUnder。只启用当前逻辑页，不用嵌套次级列表驱动导航；业务加载和吸附监听保留。

## 悬浮底部导航

- 所有底部 Tab 页面复用 lib/widgets/app_floating_tab_scaffold.dart 中的 AppFloatingTabScaffold。页面只注入导航项、选中索引、回调和正文。
- 只有共用宿主可以创建 HyperTabBar 和设置 Scaffold.bottomNavigationBar；宿主必须使用 extendBody: true，底栏 Align 使用 heightFactor: 1。
- HyperTabBar 负责底栏安全区和边距，外层禁止重复包底部 SafeArea/Padding。正文需要 SafeArea 时显式设置 bottom: false，顶部安全区也只处理一次。
- HyperTabBar 的 single 独立入口由库固定为直径 48 逻辑像素，multiple 按钮组默认高 56；并排垂直居中，禁止改成等高，也不在业务层覆写尺寸。
- 正文必须可以绘制和滚动到底栏后方。禁止把底栏或避让用 SizedBox 放在正文 Column 的底部，禁止硬编码底栏高度挤压视口。
- 最后一项需要滚出遮挡时，在滚动内容内部末尾使用 AppPageScrollEnd；不得放在滚动容器外，不得再叠加 viewPadding.bottom 或另一份底栏高度。
- ListView 的自动安全区 padding 与手动末尾余量只选一个来源，避免重复避让。
- 未经用户明确要求修改底栏布局，不得更改其高度、占位、位置、margin、padding、SafeArea、extendBody 或正文滚动范围。禁止为统一背景添加全宽不透明底板、固定占位或局部主题包装；底栏两侧保留正文的滚动操作。

## 修改完成检查

- 修改控件后重新检查宿主、正文、滚动容器、安全区、底栏这条完整布局链，不能只替换组件名。
- 对改动的 Dart 文件做格式检查，并运行 dart analyze。项目已有布局检查脚本时，同时执行实际存在的检查命令。
- 检查正文能滚过底栏后方、末项能完整滚出遮挡，以及大字体、横屏、系统安全区和键盘出现时的布局。
- 核对所有页面与独立入口的全面屏、导航渐变、卡片层次；核对底栏及正文的实际占位和遮挡，不能仅检查 height 数值。非授权布局变化必须在交付前撤销。
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
