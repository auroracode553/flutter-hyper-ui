---
title: HyperNavBar
description: 44px 透明导航栏
---

<ComponentDoc component-id="nav-bar" />

## 公开参数

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
| onBackPressed | VoidCallback? | 否 | null | 默认返回按钮回调；未提供时调用 Navigator.maybePop。 |
| onMorePressed | VoidCallback? | 否 | null | more 类型右侧更多操作回调。 |
| onSavePressed | VoidCallback? | 否 | null | edit 类型右侧保存操作回调。 |
| centerTitle | bool | 否 | false | custom 类型是否将标题按整栏居中。 |

## 页面导航

预览提供五种固定类型：`backOnly`、`titleOnly`、`backWithTitle`、`more` 和 `edit`；需要完整插槽时使用 `custom`。固定类型直接传 `type`，标题和动作回调由调用方注入。

`HyperNavBar` 本身不绘制整栏背景。要让内容滚动到导航栏和状态栏后方，页面需让滚动视口占满屏幕，并把导航栏叠在上方。首屏留白放进滚动内容，随内容一起滚走；不要用 `Column` 把导航栏和列表上下排列。

```dart
Builder(
  builder: (context) {
    final safeArea = MediaQuery.paddingOf(context);
    const navBarHeight = 44.0;
    return Stack(
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
    );
  },
)
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
    type: 'tonal',
    icon: HyperIcons.back,
    tooltip: '返回',
    onPressed: () {},
  ),
  title: const Text('创作空间'),
  trailing: HyperButton(type: 'ghost', label: '分享', onPressed: () {}),
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
  trailing: HyperButton(type: 'ghost', label: '编辑', onPressed: () {}),
)
```

```dart
HyperNavBar(
  height: 52,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  child: HyperTextField(
    type: 'search',
    hintText: '搜索灵感',
    onChanged: (value) {},
  ),
)
```
