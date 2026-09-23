# 快速开始

Hy UI 是一个独立的 Flutter 移动端组件包。它只依赖 Flutter SDK，不要求特定路由、状态管理、网络或持久化方案。

## 环境要求

- Flutter `>= 3.32.0`
- Dart `>= 3.8.0 < 4.0.0`
- Material 3

依赖与 SDK 由使用者自行准备，本项目不会自动安装或修改系统环境。

## 添加依赖

当前仓库可通过本地路径接入：

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../flutter-hyper-ui/ui
```

组件库没有运行时第三方依赖。执行依赖解析的时机由你的项目自行决定。

## 接入主题

公开 API 全部由一个入口导出：

```dart
import 'package:flutter_hyper_ui/hy_ui.dart';
```

在应用根节点使用 Hy UI 的明暗主题：

```dart
MaterialApp(
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  themeMode: ThemeMode.system,
  home: const AppHome(),
);
```

`HyUiTheme` 仍然是标准 `ThemeData`，可以继续使用 Flutter 原生主题机制。品牌色和字体可在构建主题时覆盖：

```dart
theme: HyUiTheme.light(
  primary: const Color(0xFF6750A4),
  fontFamily: 'YourFont',
),
```

## 创建第一个页面

`HySoftBackground` 提供低饱和环境色，让透明材质具有可见景深；它不是必需的业务容器。

```dart
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const HyNavBar(
        title: '收藏',
        subtitle: '12 个项目',
      ),
      body: HySoftBackground(
        child: ListView(
          padding: const EdgeInsets.all(HyUiSpacing.pagePadding),
          children: const [
            HyCard(
              title: '开始创作',
              subtitle: '所有组件共享同一套材质与交互规则。',
            ),
          ],
        ),
      ),
      bottomNavigationBar: HyTabBar(
        items: const [
          HyTabItem(icon: Icons.home_outlined, label: '首页'),
          HyTabItem(icon: Icons.favorite_outline, label: '收藏'),
          HyTabItem(icon: Icons.person_outline, label: '我的'),
        ],
        selectedIndex: selectedIndex,
        onSelected: (value) => setState(() => selectedIndex = value),
      ),
    );
  }
}
```

## 受控组件

Hy UI 不持有业务状态。输入和选择组件通过值与回调工作：

```dart
HySwitch(
  value: notificationsEnabled,
  onChanged: (value) {
    setState(() => notificationsEnabled = value);
  },
)
```

同一组件可以配合 `setState`、Provider、Riverpod、Bloc 或任意其他方案，无需适配层。

## 下一步

- 阅读[设计系统](./design-system.md)，理解玻璃层级和交互规则。
- 前往[组件总览](../components/catalog.md)，体验真实 Flutter Widget。
