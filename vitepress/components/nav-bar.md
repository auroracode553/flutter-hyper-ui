---
title: HyperNavBar
description: 44px 透明导航栏
---

<ComponentDoc component-id="nav-bar" />

## 页面导航

```dart
Column(
  children: <Widget>[
    const HyperNavBar(title: Text('今日灵感')),
    Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: 30,
              itemBuilder: (_, index) => HyperListTile(title: '灵感 $index'),
            ),
          ),
        ],
      ),
    ),
  ],
)
```

## 自定义插槽

```dart
HyperNavBar(
  height: 56,
  showBackButton: false,
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
