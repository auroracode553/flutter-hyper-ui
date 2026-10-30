---
title: HyperNavBar
description: 44px 顶部透明、滚动时渐显毛玻璃的导航栏
---

<ComponentDoc component-id="nav-bar" />

## 公开参数

```dart
const HyperNavBar({
  Key? key,
  String type = HyperNavBarTypes.custom,
  Widget? title,
  Widget? subtitle,
  Widget? leading,
  Widget? trailing,
  List<Widget> actions = const [],
  Widget? child,
  double height = 44,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
  bool safeArea = true,
  bool scrolledUnder = false,
  VoidCallback? onBackPressed,
  VoidCallback? onMorePressed,
  VoidCallback? onSavePressed,
  bool centerTitle = false,
})
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| title | Widget? | 否 | null | 主标题插槽。 |
| subtitle | Widget? | 否 | null | 副标题插槽。 |
| type | String | 否 | HyperNavBarTypes.custom | 固定布局类型：custom、backOnly、titleOnly、backWithTitle、more、edit。 |
| leading | Widget? | 否 | null | custom 类型的左侧导航内容。 |
| trailing | Widget? | 否 | null | 右侧自定义内容，与 actions 二选一。 |
| actions | List&lt;Widget&gt; | 否 | const [] | 右侧操作列表。 |
| child | Widget? | 否 | null | 接管整行布局，与其他内容插槽互斥。 |
| height | double | 否 | 44 | 导航栏内容高度，不含安全区。 |
| padding | EdgeInsetsGeometry | 否 | EdgeInsets.symmetric(horizontal: 16) | 内容内边距。 |
| safeArea | bool | 否 | true | 是否避让顶部安全区。 |
| scrolledUnder | bool | 否 | false | true 强制显示毛玻璃；false 优先使用显式滚动作用域，否则自动读取最近 Scaffold 的观察者；均不存在时透明。 |
| onBackPressed | VoidCallback? | 否 | null | 默认返回按钮回调；未提供时调用 Navigator.maybePop。 |
| onMorePressed | VoidCallback? | 否 | null | more 类型右侧更多操作回调。 |
| onSavePressed | VoidCallback? | 否 | null | edit 类型右侧保存操作回调。 |
| centerTitle | bool | 否 | false | custom 类型是否将标题按整栏居中。 |

## 页面导航

预览提供五种固定类型：`backOnly`、`titleOnly`、`backWithTitle`、`more` 和 `edit`；需要完整插槽时使用 `custom`。固定类型直接传 `type`，标题和动作回调由调用方注入。

导航在正文顶部时完全透明，不执行背景采样；滚入时显示向下渐隐的背景模糊与主题 background 画布色，160ms 完成过渡。导航不使用 card 内容卡片色，避免页面与顶部产生色块分割。背景覆盖顶部安全区，在导航底部以内淡出到完全透明；蒙版同时淡出 20px 模糊采样和底色，不绘制底部分隔线。延伸区域不占布局高度、不拦截触摸，标题和按钮在独立前景层保持清晰。高对比模式仅在导航区域使用实色，关闭动画时立即切换。

## 普通 Scaffold 自动接入

HyperNavBar 自动订阅最近的 ScrollNotificationObserver；Flutter 的 Scaffold 已在内部提供该观察者，appBar 与 body 因此不必属于同一子树。消费页面无需额外声明导航监听、布尔状态或回调，位置恢复与尺寸变化通过框架转换的指标通知同步；忽略横向和嵌套视口，只在状态变化时重建导航自身。

```dart
Scaffold(
  appBar: const HyperNavBar(
    type: HyperNavBarTypes.backWithTitle,
    title: Text('设置'),
  ),
  body: ListView(children: settingsItems),
)
```

库内管理观察者替换与销毁清理。存在显式 HyperNavBarScrollScope 时只采用其状态，不再订阅 Scaffold 观察者，避免保留 Tab、侧栏或嵌套滚动误驱动同一导航。非 Scaffold 的普通 Stack 宿主仍使用下面的显式作用域；分页和多主视口继续绑定 source。WebView 的网页滚动不属于 Flutter 滚动通知，不为此添加业务 Bridge 监听。

自动感知只选择状态来源，不修改现有 Scaffold、导航布局、正文约束、安全区、padding、physics、TabBar 或滚动范围。需要正文经过导航后方时，按现有页面布局规范接入，不通过监听迁移顺带改动布局。

## 自动滚动作用域

```dart
const HyperNavBarScrollScope({Key? key, required Widget child, Object? scrollKey})

factory HyperNavBarScrollScope.source({
  Key? key,
  required ScrollController scrollController,
  bool active = true,
  required Widget child,
})
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| child | Widget | 是 | 无 | 导航栏与主滚动视口的共同父级。 |
| scrollKey | Object? | 否 | null | 逻辑页面标识；变化时重置滚动状态，不替换子树或影响底栏动画。 |
| source.scrollController | ScrollController | 是 | 无 | source 构造的主视口控制器；必须与子视口使用同一个实例，生命周期归调用方。 |
| source.active | bool | 否 | true | source 所在逻辑页是否活动；隐藏页和相邻预览页传 false。 |
| source.child | Widget | 是 | 无 | 绑定主控制器的滚动内容；必须位于普通 HyperNavBarScrollScope 之内。 |

HyperNavBarScrollScope 不占布局空间，普通列表自动读取 depth=0 的主视口通知和布局指标。普通垂直列表使用 extentBefore，反向列表使用 extentAfter，以 0.5 为切换阈值；忽略横向和嵌套列表，不截断通知，不创建、接管或释放 ScrollController。恢复滚动位置、程序滚动和窗口尺寸变化也会同步。库内在帧尾合并状态，只通知依赖它的导航栏，不重建整页。

分页、保留多个 Tab 或 NestedScrollView 等复合页面，在各主视口外使用 HyperNavBarScrollScope.source，传入该视口已有的 scrollController 和 active。库内负责订阅、控制器替换、初始位置恢复、尺寸变化、活动切换及销毁清理，不再由业务声明导航专用监听、布尔字段或回调。注册了 source 后，仅采用这些显式来源；非活动来源不贡献状态，也不回退监听隐藏页或嵌套列表。多个活动来源按是否有任一来源滚入合并；分页场景只启用当前逻辑页。source 必须放在包含 Navbar 的普通作用域之内，它本身不创建新作用域。

```dart
// scrollController 由页面持有，也传给同一主视口；不在页面判断滚动位置。
HyperNavBarScrollScope.source(
  scrollController: scrollController,
  active: isCurrentPage,
  child: ListView(
    controller: scrollController,
    padding: existingContentPadding,
    children: items,
  ),
)
```

source 只绑定数据，不改变视口约束、滚动偏移、physics、padding、SafeArea 或 TabBar 布局。业务仍可保留分页加载、月盘吸附等自身监听，但不得再计算和转发 Navbar 的 scrolledUnder。

全部显式来源暂时 inactive（例如弹层打开或应用进入后台）时保留上一份导航材质，恢复活动来源后读取其真实位置；不因暂停业务交互让背景闪回透明。来源全部移除后回到普通通知模式。

将作用域放在导航栏和滚动视口的共同父级，HyperNavBar 优先使用该状态，不必逐页声明滚动字段。scrolledUnder 为 true 可强制显示；false 自动使用作用域或 Scaffold 观察者。没有任何状态来源时保持透明。

正文必须能画到导航和状态栏后方。下面将首屏净空放进滚动内容，随正文滚走；不要用 Column 把导航栏和列表上下排列。也可以用 PinnedHeaderSliver 承载导航；Scaffold.appBar 布局则开启 extendBodyBehindAppBar，并只处理一次顶部安全区。

```dart
Widget build(BuildContext context) {
  final safeArea = MediaQuery.paddingOf(context);
  const navBarHeight = 44.0;
  return HyperNavBarScrollScope(
    child: Stack(
      children: [
        Positioned.fill(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16, safeArea.top + navBarHeight + 12,
                    16, safeArea.bottom + 24,
                  ),
                  sliver: SliverList.builder(
                    itemCount: 30,
                    itemBuilder: (_, index) => HyperListTile(title: '灵感 $index'),
                  ),
                ),
              ],
            ),
          ),
        ),
        HyperNavBar(
          type: HyperNavBarTypes.backOnly,
          height: navBarHeight,
          onBackPressed: () {},
        ),
      ],
    ),
  );
}
```

## 常见布局

```dart
// 仅返回：不传 title。
HyperNavBar(
  type: HyperNavBarTypes.backOnly,
  onBackPressed: () {},
)

// 仅标题：固定类型自动隐藏返回按钮。
const HyperNavBar(
  type: HyperNavBarTypes.titleOnly,
  title: Text('今日灵感'),
)

// 返回与标题：固定类型自动生成尖括号返回按钮。
HyperNavBar(
  type: HyperNavBarTypes.backWithTitle,
  title: const Text('今日灵感'),
  onBackPressed: () {},
)

// 更多操作：右侧标准按钮由 type 生成。
HyperNavBar(
  type: HyperNavBarTypes.more,
  title: const Text('消息'),
  onBackPressed: () {},
  onMorePressed: () {},
)

// 编辑页：右侧显示保存文字操作。
HyperNavBar(
  type: HyperNavBarTypes.edit,
  title: const Text('编辑资料'),
  onBackPressed: () {},
  onSavePressed: () {},
)

// 自定义：固定类型之外的布局使用完整插槽。
HyperNavBar(
  type: HyperNavBarTypes.custom,
  leading: HyperButton(
    type: 'icon',
    icon: HyperIcons.back,
    tooltip: '返回',
    onPressed: () {},
  ),
  title: const Text('创作空间'),
  trailing: HyperButton(label: '分享', onPressed: () {}),
)
```

## 自定义插槽

```dart
HyperNavBar(
  height: 56,
  type: HyperNavBarTypes.custom,
  leading: const HyperAvatar(text: '林'),
  title: const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('工作空间'),
      SizedBox(width: 8),
      HyperBadge(type: 'tag', label: '个人'),
    ],
  ),
  subtitle: const Text('把想法留下来'),
  trailing: HyperButton(label: '编辑', onPressed: () {}),
)
```

```dart
HyperNavBar(
  height: 52,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  child: HyperTextField(
    type: 'search',
    placeholder: '搜索灵感',
    onChanged: (value) {},
  ),
)
```
