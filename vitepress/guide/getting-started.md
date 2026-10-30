# 快速开始

Hyper UI 是独立的 Flutter 组件包。界面颜色、玻璃表面和交互样式由 Hyper 组件提供。

开始接入或页面开发前，先阅读[使用规则与页面开发规范](./consumer-integration.md)，将其中 AGENTS.md 模板按实际依赖路径合并到业务项目，再核对[设计系统基线](./design-system.md)与相关组件接口。

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

默认跟随系统明暗模式，材质默认为 `HyperMaterial.solid`。需要固定模式时传 `brightness: Brightness.light` 或 `Brightness.dark`；品牌色用 `primary`。通过 `material: HyperMaterial.soft` 或 `HyperMaterial.clear` 切换全应用材质。局部覆盖使用 `HyperUiTheme(data: ..., child: ...)`。

完整配置与运行时切换见[主题配置](./theming.md)。

## 应用全局全面屏

应用在启动入口全局开启 edge-to-edge；主入口与独立 Flutter/Activity 入口都要执行。HyperUiTheme.app 不代替系统模式配置。全局主题宿主通过 AnnotatedRegion 配置透明系统栏，下面示例默认跟随系统明暗；应用支持自选主题时，图标亮暗必须跟随实际应用主题。

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(HyperUiTheme.app(
    home: const AppHome(),
    builder: (context, child) {
      final dark = HyperUiTheme.of(context).brightness == Brightness.dark;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: const Color(0x00000000),
          systemNavigationBarColor: const Color(0x00000000),
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarIconBrightness:
              dark ? Brightness.light : Brightness.dark,
        ),
        child: child!,
      );
    },
  ));
}
```

页面画布使用主题 background 贯穿状态栏、正文和手势区。不要给整页包底部 SafeArea 或为系统栏单独绘制色块；必要控件可局部避让，末项滚动余量放在滚动内容内部。Navbar 的模糊与渐隐由库提供，禁止用实色底板挡住采样。TabBar 周围透明，保留原有尺寸与滚动范围。

## 简化后的组件 API

| 场景 | 现在的写法 |
| --- | --- |
| 默认按钮 | `HyperButton(label: '保存', onPressed: save)` |
| 按钮外观 | 省略 type 为默认描边；type 控制 filled/icon；colorStyle 控制 primary/success/info/warning/danger，color 自定义颜色优先 |
| 密码或多行输入 | `HyperTextField(type: 'password', ...)`、`HyperTextField(type: 'textarea', rows: 3, ...)` |
| 表面材质 | `HyperUiTheme.app(material: HyperMaterial.soft, home: content)` |
| 图片来源 | `HyperImage(type: 'network', source: url)`、`HyperImage(type: 'asset', source: path)` |
| 徽标与提示 | `HyperBadge(type: 'tag', label: '完成')`、`HyperToast.show(context, '完成', type: 'success')` |
| 单选与多选 | `HyperSelect(value: ..., onChanged: ...)`、`HyperSelect<T>(type: 'multiple', values: ..., onMultipleChanged: ...)` |
| 进度与步骤 | `HyperProgress(type: 'circular')`、`HyperSteps(type: 'vertical', steps: steps, current: 1)` |
| 分隔与骨架 | `HyperDivider(type: 'dashed')`、`HyperSkeleton(type: 'card')` |
| 列表表面 | `HyperListTile(type: 'plain', title: '设置')` |
| 固定分段 | `HyperTabs(tabs: [...], selectedIndex: selected, onChanged: select)` |
| 横向分类 | `HyperFilterBar(items: categories, selectedIndex: selected, onChanged: select, itemBuilder: (item, selected, enabled) => HyperText(item))` |
| 文字尺寸与颜色 | `HyperText('标题', color: brandColor)` |
| 默认规格 | `HyperButton(label: '保存', onPressed: save)`、`HyperAvatar()`、`HyperProgress(type: 'circular')` |
| 操作列表弹层 | `HyperActionSheet.choose(context, actions: [...])` |

每类组件只保留一套默认规格，文字和图标继承宿主样式，并从主题读取默认颜色。`color` 接受 Flutter `Color`，覆盖组件的主要颜色；`backgroundColor` 等带限定词的参数只覆盖对应部位。按钮的 `content`、输入框的 `prefix` / `suffix`、卡片与导航栏的内容插槽仍接受自定义 Widget。
表面材质由主题统一配置；`HyperUploader` 的文件选择与上传回调继续由应用注入。

`type` 只用于同一组件内的形态或视觉层级。日期、时间和区间选择返回不同的 Dart 类型，继续使用 `HyperDatePicker.date/time/range`；自定义弹层和操作列表需要不同的必填参数，继续使用 `HyperActionSheet.show/choose`。独立开关选项保持布尔参数。

## 创建第一个页面

先将 [TabBar 文档中的共用悬浮宿主](../components/tab-bar.md#悬浮页面宿主)保存为业务项目的 `lib/widgets/app_floating_tab_scaffold.dart`，再复制下面的完整入口为 `lib/main.dart`。AppFloatingTabScaffold 和 AppPageScrollEnd 属于该业务文件，不是 UI 包导出的类。

示例使用 Flutter 内置图标，业务项目的 `pubspec.yaml` 需保留 `flutter.uses-material-design: true`。依赖准备完成后，页面与底栏通过共用宿主组合：

```dart
// lib/main.dart
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

import 'widgets/app_floating_tab_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(HyperUiTheme.app(
    home: const AppHome(),
    builder: (context, child) {
      final dark = HyperUiTheme.of(context).brightness == Brightness.dark;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: const Color(0x00000000),
          systemNavigationBarColor: const Color(0x00000000),
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarIconBrightness:
              dark ? Brightness.light : Brightness.dark,
        ),
        child: child!,
      );
    },
  ));
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final title = _selectedIndex == 0 ? '首页' : '我的';
    final itemCount = _selectedIndex == 0 ? 24 : 3;
    return AppFloatingTabScaffold(
      items: const [
        HyperTabItem(icon: Icons.home_rounded, label: '首页'),
        HyperTabItem(icon: Icons.person_rounded, label: '我的'),
      ],
      selectedIndex: _selectedIndex,
      onChanged: (index) => setState(() => _selectedIndex = index),
      body: CustomScrollView(
        key: PageStorageKey<int>(_selectedIndex),
        slivers: [
          PinnedHeaderSliver(child: HyperNavBar(title: Text(title))),
          HyperPageContentSliver(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: List.generate(
                itemCount,
                (index) => HyperListTile(
                  title: '$title · 项目 ${index + 1}',
                  showChevron: false,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: AppPageScrollEnd()),
        ],
      ),
    );
  }
}
```

底栏由宿主的 bottomNavigationBar 挂载，正文可以滚动到它后方。HyperNavBar 负责顶部安全区，HyperTabBar 负责底部安全区；页面不再套整页 SafeArea。AppPageScrollEnd 在正文子树中读取实际底栏高度，只提供末项的滚动余量。

将[业务项目 AGENTS.md 模板](./consumer-integration.md#可复制模板)合并到项目规则后，后续页面继续复用同一个宿主。

## 受控组件

Hyper UI 不持有业务状态。输入和选择组件通过值与回调工作：

```dart
HyperSwitch(
  value: notificationsEnabled,
  onChanged: (value) => setState(() => notificationsEnabled = value),
)
```

继续阅读[主题与令牌](./theming.md)和[组件总览](../components/catalog.md)。
