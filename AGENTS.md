# 项目协作规则

## 一、项目运行约束

允许提供由使用者手动启动的本地 dev/watch 脚本；脚本启动后可以监听 Dart 变化并执行开发构建，但不得自动部署。

不主动安装依赖或配置系统环境。依赖清单单独罗列，由使用者自主按需安装。

## 二、代码架构规范（低耦合强制要求）

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

## 五、禁用 Material 视觉组件（强制）

本组件库为 Flutter 自绘玻璃拟态风格（Hy* 组件），与 Material Design 视觉语言不一致，**禁止在 ui 库与 preview 示例中使用 Material 视觉组件**：

- 禁止使用：`ListTile`、`TextButton`、`IconButton`、`Material` + `InkWell/InkResponse`、`CheckboxListTile`、`SwitchListTile`、`RadioListTile`、`CircleAvatar`、`Card`、`Divider`、`Badge` 等任何自带 Material 外观的组件。
- 统一改用 Hy 组件：`HyListTile`、`HyButton`、`HyIconButton`、`HyPressable`、`HyDivider`、`HyAvatar`、`HyCard`、`HyBadge` 等；列表项、按钮、图标按钮一律从 `ui/lib/src/components/` 的 Hy 自绘组件选取。
- 允许保留（属机制基础设施，非视觉组件）：弹层宿主（`showDialog` / `Dialog` / `showModalBottomSheet` / `SnackBar` 容器与 `ScaffoldMessenger`）、控件绘制基底（`Checkbox` / `Radio` / `Switch` / `Slider`、`CircularProgressIndicator` / `LinearProgressIndicator`）、滑动与弹层物理（`TabBar` / `TabBarView`、`MenuAnchor` / `MenuController`）、页面宿主（`Scaffold` / `AppBar`）以及 `Icon` / `Text` / `TextField` 等基础 Widget。
- 新增公开组件必须是 `Hy` 前缀的自绘组件，并同步登记到 vitepress 组件目录（`vitepress/.vitepress/catalog.ts`、`preview_catalog.dart`、示例源文件与文档页），否则 vitepress 启动契约校验会失败。

