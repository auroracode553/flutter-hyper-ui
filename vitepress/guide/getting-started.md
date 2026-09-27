# 快速开始

Hyper UI 是独立的 Flutter 组件包。界面颜色、玻璃表面和交互样式由 Hyper 组件提供。

## 环境要求

- Flutter `>= 3.32.0`
- Dart `>= 3.8.0 < 4.0.0`

依赖与 SDK 由使用者自行准备，本项目不会自动安装或修改系统环境。

## 添加依赖

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../flutter-hyper-ui/ui
```

组件图标使用 `lucide_icons_flutter`，依赖清单见 `ui/pubspec.yaml`。

## 接入主题

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

HyperUiTheme.app(home: const AppHome());
```

默认跟随系统明暗模式。需要固定模式时传 `brightness: Brightness.light` 或 `Brightness.dark`；品牌色用 `primary`。局部精细覆盖仍可使用 `HyperUiTheme(data: ..., child: ...)`。

## 简化后的组件 API

| 场景 | 现在的写法 |
| --- | --- |
| 默认按钮 | `HyperButton(label: '保存', onPressed: save)` |
| 其他按钮外观 | `HyperButton.tonal(...)`、`.outline(...)`、`.ghost(...)`、`.danger(...)` |
| 密码或多行输入 | `HyperTextField.password(...)`、`HyperTextField.multiline(...)` |
| 单选与多选 | `HyperSelect(value: ..., onChanged: ...)`、`HyperSelect<T>.multiple(values: ..., onMultipleChanged: ...)` |
| 标签与页面 | `HyperTabs(tabs: [...], pages: [...])` |
| 文字尺寸与颜色 | `HyperText('标题', size: 'large', color: brandColor)` |
| 操作列表弹层 | `HyperActionSheet.choose(context, actions: [...])` |

组件的颜色、圆角和间距由主题提供默认值。按钮的 `child`、输入框的 `prefix` / `suffix`、卡片与导航栏的内容插槽仍接受自定义 Widget。
`HyperGlass` 是材质基础层，因此继续开放模糊、边框和颜色等样式参数；`HyperUploader` 的文件选择与上传回调继续由应用注入。

## 创建第一个页面

页面使用 Flutter 布局基底和 Hyper 组件：

```dart
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      const HyperNavBar(title: Text('收藏'), subtitle: Text('12 个项目')),
      const Expanded(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(HyperUiSpacing.pagePadding),
              sliver: SliverToBoxAdapter(
                child: HyperCard(
                  title: '开始创作',
                  subtitle: '所有组件共享同一套材质与交互规则。',
                ),
              ),
            ),
          ],
        ),
      ),
      HyperTabBar(
        items: const <HyperTabItem>[
          HyperTabItem(icon: HyperIcons.home, label: '首页'),
          HyperTabItem(icon: HyperIcons.profile, label: '我的'),
        ],
        selectedIndex: selectedIndex,
        onSelected: (value) => setState(() => selectedIndex = value),
      ),
    ],
  );
}
```

## 受控组件

Hyper UI 不持有业务状态。输入和选择组件通过值与回调工作：

```dart
HyperSwitch(
  value: notificationsEnabled,
  onChanged: (value) => setState(() => notificationsEnabled = value),
)
```

继续阅读[主题与令牌](./theming.md)和[组件总览](../components/catalog.md)。
