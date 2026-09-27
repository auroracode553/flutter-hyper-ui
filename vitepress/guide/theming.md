# 主题与令牌

Hyper UI 使用自己的主题容器和两组令牌。`HyperUiThemeTokens` 负责内容与状态颜色，`HyperGlassTheme` 负责玻璃表面、边缘、阴影和遮罩。

## 基础主题

```dart
final lightTheme = HyperUiTheme.light(
  primary: const Color(0xFF5C6BC0),
);

final darkTheme = HyperUiTheme.dark(
  primary: const Color(0xFF9FA8DA),
);
```

应用根节点直接使用 `HyperUiTheme.app(home: const AppHome(), primary: brandColor)`，默认跟随系统明暗模式。需要局部覆盖时再构造 `HyperUiTheme(data: ..., child: ...)`。

## 覆盖玻璃表面

```dart
final customTheme = HyperUiTheme.light(
  primary: const Color(0xFF5C6BC0),
).copyWith(
  glass: HyperGlassTheme.light().copyWith(
    surface: const Color(0xDDF8F7FF),
    surfaceStrong: const Color(0xF8F8F7FF),
    selection: const Color(0x205C6BC0),
    pressed: const Color(0x185C6BC0),
  ),
);
```

明暗主题应分别配置，避免把浅色背景的透明度直接用于深色背景。

## 局部主题

```dart
HyperUiTheme(
  data: HyperUiTheme.of(context).copyWith(
    tokens: HyperUiThemeTokens.of(context).copyWith(
      primary: const Color(0xFF00897B),
    ),
  ),
  child: const ProfileEditor(),
)
```

## 在组件中读取令牌

```dart
final colors = context.hyperUi;
final glass = context.hyperGlass;

return HyperGlass(
  borderColor: glass.edgeHighlight,
  child: Text(
    '自定义内容',
    style: TextStyle(color: colors.foreground),
  ),
);
```

`HyperGlass(blur: 0)` 仍绘制表面、边界和阴影，但不执行背景模糊。长列表可用一个分组表面包住多行内容，减少重复模糊。
