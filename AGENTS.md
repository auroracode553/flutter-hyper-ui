# 项目协作规则

## UI 库维护与业务页面开发必读

- 开始 UI 库维护、接入或页面开发前，优先阅读[业务接入与页面开发规范](vitepress/guide/consumer-integration.md)、[设计系统基线](vitepress/guide/design-system.md)，再阅读相关组件文档、源码和真实预览。库依赖不会自动让业务项目继承本文件，必须把接入模板合并进业务项目 AGENTS.md，并指向实际依赖版本的文档。
- 应用必须在入口全局开启 edge-to-edge，主题宿主统一设置透明状态栏与手势导航栏和正确的亮暗图标；独立 Activity、独立 Flutter 入口也遵守同一配置，禁止逐页补色块伪装全面屏。
- 所有页面画布延伸到屏幕底部，禁止整页底部 SafeArea 或固定安全区占位截短正文。安全避让只交给必要控件或滚动末尾，并处理一次；键盘弹出仍须允许表单缩小与滚动。
- HyperNavBar 保留既有滚动渐变、渐显和渐隐效果。禁止为统一底色或处理透出内容，在导航材质后添加实色底板、业务宿主裁切或把渐变替换为实色；页面画布与内容卡片分别使用自身语义令牌。
- 导航滚动监听由 HyperNavBarScrollScope 管理：普通页面监听主视口通知，分页、保留 Tab 和嵌套页面通过 source 构造绑定已有主 scrollController 与 active。订阅、位置恢复、活动切换和清理由库完成，禁止消费页复制导航专用布尔缓存、滚动判断或回调链；业务加载与吸附监听按职责保留。绑定不改变控制器所有权、滚动行为、视口或底栏布局。
- 普通 Scaffold 未提供显式作用域时，HyperNavBar 在库内自动订阅框架 ScrollNotificationObserver；作用域存在时只使用作用域，不重复订阅。初始/恢复/尺寸通知与手势使用同一主视口规则；观察者替换、帧尾合并和销毁清理由库处理。禁止因补监听而改变业务 Scaffold、底栏、padding 或滚动范围；不把 WebView 与播放器等业务状态监听当作导航监听删除。
- 悬浮 HyperTabBar 必须允许正文绘制、滚动到其后方，周围区域透明。只有用户明确要求修改底栏布局时，才能改变高度、占位、位置、margin、padding、SafeArea、extendBody 或正文滚动范围；配色、阴影、统一背景和重构要求不构成布局修改授权。
- 禁止给底栏添加全宽不透明底板、固定占位或局部主题包装来绕过布局；底栏两侧应继续响应正文滚动。维护库组件也不得间接改变业务页面的这些约束。
- 正文内容表面复用内部 HyperGlass.card 和主题 cardShadows，保留当前无普通描边、底色分层与双层柔阴影；圆角、间距、选中态和高对比边界按组件原有规则保留。导航、浮层、输入和提示组件保留各自语义，不批量替换成内容卡片。
- 交付前核对完整页面链路的差异，包括系统栏、导航渐变、卡片、底栏、正文视口、末尾余量、键盘与滚动穿透；不能仅以 height 未变或静态分析通过断言布局和视觉没有变化。发现非授权变化时先撤销，再交付。

## 修改 UI 前必读

- 导航材质由库内部限定在状态栏顶部至 Navbar 底部，渐变与渐隐均在此范围内完成，不允许向正文延伸；业务宿主不得另加遮挡或裁切。覆盖式页面将首屏顶部净空放入滚动内容，所有页面复用同一接入方式，不为设置或编辑页另写导航样式。
- 输入框使用框架文本选择手势与 EditableTextState.requestKeyboard；系统返回手势关闭键盘后，即使焦点未改变，再次点击也应唤起键盘。保留长按、拖选、清空、只读与禁用行为，不通过清空文本、强制失焦或直接发送系统通道规避。

- 修改 `ui/lib/src/` 或 `preview/lib/src/` 前，必须阅读 [UI 样式与功能实现基线](vitepress/guide/design-system.md)，并核对对应源码、组件页和真实预览示例。
- 基线中的默认样式、状态行为和专用样式保留清单属于维护约束。不得以“统一样式”“清理自定义”或“复用组件”为由，批量替换控件、删除选中态或改变专用布局。
- 用户明确要求的修改按授权范围执行；确定为多余的覆盖可以直接清理。拿不准用途、可能改变视觉或交互的地方，先列出位置、当前用途、修改影响和建议，找用户确认后再改，不自行猜测。
- 调整已获授权的样式或功能时，同步更新基线、对应组件文档与预览；不得先擅自改实现，再通过改文档把变化视为已获认可。源码与基线冲突时，先查明原因，不直接用其中一方覆盖另一方。

## 一、项目运行约束

允许提供由使用者手动启动的本地 dev/watch 脚本；脚本启动后可以监听 Dart 变化并执行开发构建，但不得自动部署。

不主动配置系统环境。

## 二、代码架构规范（低耦合强制要求）

- 本项目的组件预览是与 `D:/my_project/android_project/hyper-ui` 对齐的视觉基准；两端手机外框、背景、安全区、分组顺序、文案、图标、尺寸、间距与状态展示保持一致，不在另一端额外添加标题、控制项或计数。

- 本项目与 `D:/my_project/android_project/hyper-ui` 的对应组件保持默认 UI 一致。修改默认布局、尺寸、按钮类型或状态展示规则时，同时更新另一端的实现、文档与预览示例；框架 API 差异不能导致默认视觉规则分叉。

- 遵循单一职责原则，功能拆分模块化，避免大杂烩式代码；功能、工具、配置、业务逻辑分层隔离，减少跨模块硬编码依赖。
- 禁止全局变量滥用，组件与函数依赖通过入参注入、接口调用实现，杜绝模块间直接修改内部属性。
- 公共通用逻辑抽离至独立工具文件，复用代码不重复粘贴，降低耦合度。

## 三、单文件行数限制

- 单个源码文件有效代码行数不超过 3000 行，临近上限时自动拆分文件，拆分后标注文件用途与引入关系。
- 若业务逻辑庞大，主动拆分多个子文件并梳理导入关系，附文件目录说明。

## 四、附加编码细则

- 关键逻辑添加简明注释，区分业务注释与代码正文；中英文注释按需区分。
- 变量、函数、文件命名语义化，避免无意义缩写。
- 输出代码时分文件分段标注文件名，不乱合并多文件代码至同一文本块。
- 不要默认扫描 `dist` 和 `node_modules` 目录。

## 文件清理规则

- 禁止新增版权、许可、授权等声明文件，也不要在 README、组件文档或源码注释中追加这类声明。
- 禁止创建与当前功能、构建或必要文档无关的文件；优先复用现有文件，不额外生成过程报告、备份或一次性脚本。
- 验证截图、日志等临时产物放在系统临时目录，任务完成后清理，不保存在项目目录。
- 修改完成后清理重复、废弃和未使用的文件，同时删除失效引用。

## 组件文档表格（强制）

- 每个 VitePress 组件页必须展示公开 API 签名和 Props/参数表格；不得在重构、精简文档或调整预览时删除表格。
- 表格应覆盖该组件当前公开参数，列出名称、作用、必填状态和默认值，并与 `ui/lib/src/` 源码同步；无构造参数的枚举、扩展或函数类型应列出公开值或调用参数。
- 表格内容不加反引号包裹；长内容在单元格中换行。修改组件 API 时同步维护 `vitepress/.vitepress/catalog.ts` 的属性说明和组件页展示。

## 五、禁用 Material 视觉组件（强制）

本组件库为 Flutter 自绘玻璃拟态风格（Hyper* 组件），与 Material Design 视觉语言不一致，**禁止在 ui 库与 preview 示例中使用 Material 视觉组件**：

- 禁止使用：`ListTile`、`TextButton`、`IconButton`、`Material` + `InkWell/InkResponse`、`CheckboxListTile`、`SwitchListTile`、`RadioListTile`、`CircleAvatar`、`Card`、`Divider`、`Badge` 等任何自带 Material 外观的组件。
- 统一改用 Hyper 组件：`HyperListTile`、`HyperButton`（图标按钮使用 `type: 'icon'`）、`HyperPressable`、`HyperDivider`、`HyperCard`、`HyperBadge` 等；列表项、按钮、图标按钮一律从 `ui/lib/src/components/` 的 Hyper 自绘组件选取。
- 允许保留（属机制基础设施，非视觉组件）：弹层宿主（`showDialog` / `Dialog` / `showModalBottomSheet` / `SnackBar` 容器与 `ScaffoldMessenger`）、控件绘制基底（`Checkbox` / `Radio` / `Switch` / `Slider`、`CircularProgressIndicator` / `LinearProgressIndicator`）、滑动与弹层物理（`TabBar` / `TabBarView`、`MenuAnchor` / `MenuController`）、页面宿主（`Scaffold` / `AppBar`）以及 `Icon` / `Text` / `TextField` 等基础 Widget。
- 新增公开组件必须是 `Hyper` 前缀的自绘组件，并同步登记到 vitepress 组件目录（`vitepress/.vitepress/catalog.ts`、`preview_catalog.dart`、示例源文件与文档页），否则 vitepress 启动契约校验会失败。

## 六、禁用无障碍语义标签（强制）

本项目不支持无障碍语义标签，**禁止新增任何无障碍标签与语义包装 API**：

- 禁止使用：`Semantics` / `ExcludeSemantics` / `MergeSemantics` 组件包装、`semanticLabel` 属性、`Icon.semanticLabel` / `Image.semanticLabel`、`barrierLabel` 等无障碍语义参数。
- 组件不得暴露 `semanticLabel` 类入参；文档、示例与注释中不得出现“无障碍标签”“无障碍语义”等表述。
- 允许保留与标签无关的自适应行为：`MediaQuery.disableAnimations`、`MediaQuery.highContrast`、`textScaler`、RTL 逻辑方向，以及键盘焦点/快捷键基础设施（`Focus`、`FocusableActionDetector`）。

## 业务项目接入文档

- 完整页面的底部导航示例必须使用 Scaffold.extendBody 与 bottomNavigationBar，让正文延伸至底栏后方；不得把 HyperTabBar 放在正文 Column 底部挤占视口。
- 示例的底栏安全区和边距交给 HyperTabBar，滚动末尾余量只取一次 Scaffold 注入正文的实际 bottom padding；正文使用 SafeArea 时显式 bottom: false。
- 业务项目的接入规则模板维护在 vitepress/guide/consumer-integration.md，共用悬浮宿主示例维护在 vitepress/components/tab-bar.md；快速开始和 README 应能直接到达这两个入口。

## 两端 API 一致性

- 对应组件的业务参数、状态枚举、回调名称和默认语义必须保持一致；仅保留框架布局、宿主及原生类型差异。
- 点击统一 onPressed，值变化统一 onChanged，关闭统一 onClose；页签采用 selectedIndex，单选采用 value/groupValue，插槽使用 title/subtitle/leading/trailing/actions/footer/child。
- HyperButton 的主体插槽两端统一使用 content；不要改为 child，也不保留两套参数或别名。
- 通用图标直接使用现有 Lucide 图标库；禁止在两端项目内手写或复制 SVG／字体轮廓、另建图标别名转接表。HyperIcon 只负责尺寸与颜色继承。
- type 表示形态；按钮预设颜色使用 colorStyle，自定义颜色使用 color，禁止恢复 ghost、outline 或把颜色写回按钮 type。
- API 重构直接删除旧参数、旧类型和旧名称，更新所有调用方；禁止废弃别名、兼容入口和双轨实现。
- 文档仅描述当前 API、默认值和使用方式，不保留迁移对照、旧写法或历史重构说明；同步两端实现、预览、README 和完整参数表。

## 组件规格与分类筛选

- 每类组件只提供一套默认规格，禁止新增或恢复 small/default/large 等尺寸档位及兼容参数。文字、图标继续继承宿主样式，必要的业务布局与字体缩放独立保留。
- HyperTabs 用于固定分段切换，使用 tabs / selectedIndex / onChanged；可左右滑动的分类筛选使用紧凑 HyperFilterBar，分类项保持浅底细线、淡主题色选中态，不添加阴影和厚重描边。禁止恢复整条 54dp 分类胶囊或旧分段组件名称，不保留废弃别名与兼容壳。

导航形态统一使用 HyperNavBar.type = standard / simple；standard 的内容布局通过 layout 选择。两种形态只保留滚动渐变，不录制或采样正文、不做像素模糊。simple 不生成操作行，仅读取真实顶部系统 Insets，禁止用固定栏高模拟。
