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
| scrolledUnder | bool | 否 | false | 正文是否已滚入导航区域；为 true 时渐显毛玻璃，为 false 时恢复透明。 |
| onBackPressed | VoidCallback? | 否 | null | 默认返回按钮回调；未提供时调用 Navigator.maybePop。 |
| onMorePressed | VoidCallback? | 否 | null | more 类型右侧更多操作回调。 |
| onSavePressed | VoidCallback? | 否 | null | edit 类型右侧保存操作回调。 |
| centerTitle | bool | 否 | false | custom 类型是否将标题按整栏居中。 |

## 页面导航

预览提供五种固定类型：`backOnly`、`titleOnly`、`backWithTitle`、`more` 和 `edit`；需要完整插槽时使用 `custom`。固定类型直接传 `type`，标题和动作回调由调用方注入。

导航在 scrolledUnder 为 false 时完全透明，不执行背景采样；为 true 时显示向下渐隐的背景模糊与主题表面色，160ms 完成过渡。背景覆盖顶部安全区，向导航下方延伸 56px 并淡出到完全透明；蒙版同时淡出 20px 模糊采样和底色，不绘制底部分隔线。延伸区域不占布局高度、不拦截触摸，标题和按钮在独立前景层保持清晰。高对比模式仅在导航区域使用实色，关闭动画时立即切换。

滚动位置归页面宿主管理。使用 NotificationListener 读取主列表的 extentBefore，并将是否大于 0.5 传给 scrolledUnder；忽略横向和嵌套列表，通知返回 false，避免截断其他监听器。反向列表使用 extentAfter；恢复滚动位置或程序滚动时也应同步状态。组件不创建、接管或释放页面的 ScrollController。

要让内容滚动到导航栏和状态栏后方，页面需让滚动视口占满屏幕，并把导航栏叠在上方。首屏留白放进滚动内容，随内容一起滚走；不要用 Column 把导航栏和列表上下排列。Scaffold 接入时设置 extendBodyBehindAppBar 为 true，并把 Scaffold 提供的 MediaQuery.padding.top 计入列表内部 padding。

```dart
// State 内字段；仅在布尔状态改变时刷新，不逐像素重建页面。
bool scrolledUnder = false;

Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    const navBarHeight = 44.0;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 && notification.metrics.axis == Axis.vertical) {
          final next = notification.metrics.extentBefore > 0.5;
          if (next != scrolledUnder) setState(() => scrolledUnder = next);
        }
        return false;
      },
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
          scrolledUnder: scrolledUnder,
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
  leading: HyperButton(type : 'tonal',
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
  leading: const HyperAvatar(text: '林', size: 'small'),
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
