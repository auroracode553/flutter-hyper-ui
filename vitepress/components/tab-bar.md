---
title: HyperTabBar
description: HyperTabBar 组件与公开 API
---

<script setup>
import { exampleSourceFor } from '../.vitepress/theme/example-source';
</script>

<ComponentDoc component-id="tab-bar" />

<DemoBlock component="component-tab-bar-docked" title="非悬浮动作栏：重复点击与禁用项" :height="680" :full-screen="true" :code="exampleSourceFor('component_tab_bar_examples.dart', 'DockedTabBarComponentExample')" />

<DemoBlock component="component-tab-bar-single" title="单动作与角标" :height="680" :full-screen="true" :code="exampleSourceFor('component_tab_bar_examples.dart', 'SingleTabBarComponentExample')" />

多项模式只接受 2–5 项，超过 5 项在构建时抛出 ArgumentError，不静默截断。底栏默认悬浮；floating=false 为全宽贴底的 multiple 形态。itemEnabled 控制单项禁用；选择模式支持点击与横向拖动，selectedIndex=null 则为可重复触发且不响应拖动的动作模式。

## 固定玻璃与吸附

独立入口和悬浮胶囊的外缘与 Kotlin 一致：沿实际轮廓绘制 0.5 逻辑像素描边，由圆角裁切保留内侧半边；静止高光透明度依次为 0.3/0.02/0.25、渐变位置 0/0.5/1。描边不参与测量，独立入口保持 48×48、图标 22。悬浮胶囊固定使用 8 的背景模糊、24/24 的边缘深度与折射位移；选中镜片合成独立录制的容器和主题色标签，按下时边缘/位移从 0 过渡到 10/14，带七波段色散、方向性高光和内阴影。拖动按手指位置连续预览，点击和松手通过临界阻尼弹簧（mass 1、stiffness 1000、damping 63.2455532）定位；取消恢复受控值，松手才提交 onChanged。点击及切换途中，整条 Bar 保持原比例；镜片按压目标为横向 1.04、纵向 1.08，横纵弹簧 dampingRatio 分别为 0.85/0.9、stiffness 400。移动速度先除以 max(1, 项数−1) 归一化，再经 dampingRatio 0.85、stiffness 400 弹簧平滑；其绝对值除以 10 并限制至 0–1，控制横向最多附加 3%、纵向最多压缩 1.5%。最终横纵缩放限制在 0.98–1.08 和 0.98–1.10，左右切换使用相同幅度。距目标小于总行程 2.5% 后释放并回弹。

横向拖动按累计位移 / 栏宽经 EaseOut 缓动映射到最多 ±4 逻辑像素，松手或取消使用 dampingRatio 1、stiffness 300 回正；柔和高光跟随镜片中心。贴底形态不偏移整条栏。以上只改变瞬时绘制，容器及选中块的静态测量、48/56 规格、外边距、安全区、点击区域和正文滚动范围保持不变。禁用项不触发按压动效，减少动态效果时直接定位并关闭镜片缩放与拖动偏移。

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

单项模式仅显示 `icon`，`label` 保留为导航项定义。多项模式使用默认的 `type: 'multiple'`，支持点击和横向拖动选择。选中块使用临界阻尼弹簧移动到目标项。

## 多项布局

多项底栏按内容收缩，外部使用 Align 或 Center 居中。每项默认占宽 76 逻辑像素，长标签和大字体按文字宽度加 32 逻辑像素留白扩展；总宽超出父级时服从可用宽度。底栏高度至少 56 逻辑像素，水平内边距为 4；选中镜片保持按钮组内容高度减 8，默认可见高 48、上下各 4；宽度随所在项变化，点击区域覆盖整项，不单独压缩镜片高度。两个短标签的底栏内容宽度为 160 逻辑像素，不再横向铺满手机屏幕。两端 TabBar 示例统一使用 Kotlin 文档的完整手机场景、文案、图标和展示状态；预览不叠加水平页面 padding，组件及组合只消费一次边距。

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

<DemoBlock component="component-tab-bar-trailing" title="56dp 主导航与 48dp 独立操作居中并排" :height="680" :full-screen="true" :code="exampleSourceFor('component_tab_bar_examples.dart', 'TrailingTabBarComponentExample')" />

single 使用库内 HyperTabBar.singleDiameter = 48 的固定直径，multiple 悬浮 / 贴底按钮组使用 HyperTabBar.height = 56 的默认内容高度，仅按钮组按标签字体在库内扩展。单独按钮必须比按钮组小，禁止为并排等高将 single 改为 56；业务不得设置固定高度、SizedBox.square、额外约束或缩放来实现 48。悬浮多项默认 margin 为 (12, 8, 12, 20)，并排入口由共同 Row 处理一次边距并使用 CrossAxisAlignment.center，保留各自默认尺寸；独立入口与导航间距 8，组合示例左右留白 12。胶囊内部最多 5 项，胶囊外最多另放 1 个独立入口，两者分别计数；消息入口位于胶囊外，不删减导航项。预览支持点击、按住与横拖观察。

| 默认值 | 类型 | 必填 | 值 | 作用 |
| --- | --- | --- | --- | --- |
| HyperTabBar.singleDiameter | double | 否 | 48 | single 独立圆形入口的固定直径，单位为逻辑像素 |
| HyperTabBar.height | double | 否 | 56 | multiple 悬浮 / 贴底按钮组默认内容高度，单位为逻辑像素；字体扩展由库内部处理 |

HyperBackdrop(background: 背景, child: 组件) 定义独立取样来源，不是材质档位。组件自身固定使用玻璃；背景、容器、标签与镜片分开录制，镜片不进入自己的背景。
