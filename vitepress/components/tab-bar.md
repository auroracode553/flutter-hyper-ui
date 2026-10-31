---
title: HyperTabBar
description: HyperTabBar 组件与公开 API
---

<ComponentDoc component-id="tab-bar" />

底栏默认悬浮；floating=false 为全宽贴底的 multiple 形态。itemEnabled 控制单项禁用；选择模式支持点击与横向拖动，selectedIndex=null 则为可重复触发且不响应拖动的动作模式。

## 非悬浮动作栏

`floating: false` 使用库内全宽平直表面，没有悬浮胶囊、圆角、外侧留白或浮层阴影；默认 margin 为零，safeArea 默认 true。与悬浮多项按钮组共用默认内容高度 56，仅按钮组按标签字体在库内扩展；single 独立入口固定直径 48。安全区位于内容尺寸之外。放入 Scaffold.bottomNavigationBar 时采用普通正文避让，不叠加底板、额外 SafeArea 或固定底栏高度。

```dart
HyperTabBar(
  floating: false,
  selectedIndex: null,
  items: actions,
  itemEnabled: (item) => item.label != '前进' || canGoForward,
  onChanged: onAction,
)
```

空选中值不绘制常驻选中块，每次有效点击都会回调，适合浏览器前进、后退和菜单操作。非空选中值保持原有选择行为，重复点击当前项不回调，拖动松手提交。两种模式中的禁用项均不触发操作。

## 单项入口

`type: 'single'` 用于与底部导航并排的独立操作入口，例如通知。它在库内固定为直径 48 逻辑像素的圆形图标按钮，不随按钮组高度或标签字体放大，并可显示数量角标；点击时始终通过 `onChanged(0)` 通知调用方。`badgeCount` 为 0 时隐藏角标，超过 99 时显示 `99+`。

```dart
HyperTabBar(
  type: 'single',
  safeArea: false,
  margin: EdgeInsets.zero,
  items: const [HyperTabItem(icon: Icons.notifications_none_rounded, label: '通知')],
  selectedIndex: 0,
  badgeCount: unreadCount,
  onChanged: (_) => openNotifications(),
)
```

单项模式仅显示 `icon`，`label` 保留为导航项定义。多项模式使用默认的 `type: 'multiple'`，支持点击和横向拖动选择。选中块以 160 毫秒移动到目标项；不执行水珠膨胀、弹簧回弹或矩阵折射绘制。

## 多项布局

多项底栏按内容收缩，外部使用 Align 或 Center 居中。每项默认占宽 76 逻辑像素，长标签和大字体按文字宽度加 32 逻辑像素留白扩展；总宽超出父级时服从可用宽度。底栏高度至少 56 逻辑像素，内边距为 4，选中区域随所在项宽度变化。两个短标签的底栏内容宽度为 160 逻辑像素，不再横向铺满手机屏幕。

## 悬浮页面宿主

业务页面通过共用宿主组合 Scaffold 与 HyperTabBar。Scaffold 使用 extendBody: true，底栏放入 bottomNavigationBar，Align 使用 heightFactor: 1，让底栏区域按组件实际高度收缩。正文的视口延伸到底栏后方，内容可从底栏后滚过。

| 范围 | 负责方 | 使用约定 |
| --- | --- | --- |
| 底栏外观、切换与选中动画 | HyperTabBar | 通过 items、selectedIndex、onChanged 等公开参数接入 |
| 底栏安全区、默认边距 | HyperTabBar | 保留默认 safeArea: true；边距通过 margin 调整，外层不再叠加 SafeArea 或 Padding |
| 页面与底栏的叠放 | Scaffold | extendBody: true，bottomNavigationBar 只挂载共用宿主中的底栏 |
| 正文安全区 | 页面 | 正文需要 SafeArea 时显式设置 bottom: false；顶部安全区也只处理一次 |
| 最后一项的滚动余量 | AppPageScrollEnd | 放在滚动内容内部末尾，读取正文 MediaQuery.padding.bottom |

下面两个类是**业务项目自行保存的布局封装**，不是 flutter_hyper_ui 包导出的组件。复制为业务项目的 `lib/widgets/app_floating_tab_scaffold.dart`；已有等价封装的项目应复用现有实现。

```dart
// lib/widgets/app_floating_tab_scaffold.dart
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

class AppFloatingTabScaffold extends StatelessWidget {
  const AppFloatingTabScaffold({
    super.key,
    required this.body,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  final Widget body;
  final List<HyperTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: HyperUiTheme.of(context).tokens.background,
    extendBody: true,
    body: body,
    bottomNavigationBar: Align(
      heightFactor: 1,
      child: HyperTabBar(
        items: items,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
      ),
    ),
  );
}

/// 在正文子树中读取 Scaffold 注入的实际底栏高度。
class AppPageScrollEnd extends StatelessWidget {
  const AppPageScrollEnd({super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.paddingOf(context).bottom);
}
```

正文不为底栏预留固定高度，不在外层 Column 中新增占位行，也不手算 56、80 等底栏高度。组件会随字体缩放调整尺寸，应使用 Scaffold 注入正文的实际底部 padding。

`AppPageScrollEnd` 放在 CustomScrollView 的末尾 SliverToBoxAdapter 中，或 SingleChildScrollView 的内容末尾。它增加可滚动的距离，让最后一项完整滚出遮挡；不要把它放在滚动容器外，不要再叠加 viewPadding.bottom。使用 ListView 时，将实际底部 padding 合并到列表 padding 中一次即可，不能再同时追加末尾余量。

完整的主题入口、页面切换与滚动正文见[快速开始](../guide/getting-started.md#创建第一个页面)。跨项目复用规则见[业务项目接入与 AGENTS.md 模板](../guide/consumer-integration.md)。

## 默认尺寸与并排操作

single 使用库内 HyperTabBar.singleDiameter = 48 的固定直径，multiple 悬浮 / 贴底按钮组使用 HyperTabBar.height = 56 的默认内容高度，仅按钮组按标签字体在库内扩展。单独按钮必须比按钮组小，禁止为并排等高将 single 改为 56；业务不得设置固定高度、SizedBox.square、额外约束或缩放来实现 48。悬浮多项默认 margin 为 (20, 8, 20, 20)，并排入口由共同 Row 处理一次边距并使用 CrossAxisAlignment.center，保留各自默认尺寸；预览支持点击和切换观察。

| 默认值 | 类型 | 必填 | 值 | 作用 |
| --- | --- | --- | --- | --- |
| HyperTabBar.singleDiameter | double | 否 | 48 | single 独立圆形入口的固定直径，单位为逻辑像素 |
| HyperTabBar.height | double | 否 | 56 | multiple 悬浮 / 贴底按钮组默认内容高度，单位为逻辑像素；字体扩展由库内部处理 |
