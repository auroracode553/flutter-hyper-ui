# 主题与令牌

Hy UI 使用两个 `ThemeExtension` 分离语义颜色和玻璃材质。应用可以只覆盖品牌色，也可以完整定义一套材质语言。

## 两层令牌

### `HyUiThemeTokens`

负责内容与状态语义：

- 页面、卡片和文字颜色
- 品牌主色及其前景色
- 弱化文字与边界
- success、warning、error、info

### `HyGlassTheme`

负责空间与材质语义：

- `surface`、`surfaceSubtle`、`surfaceStrong`
- `edgeHighlight`、`edgeShade`
- `shadow`、`scrim`
- `controlTrack`、`selection`、`pressed`

组件不会在内部复制一套私有玻璃颜色。修改 ThemeExtension 后，Navbar、TabBar、表单、菜单和弹层会同时更新。

## 快速品牌化

只改变主色时使用主题构造参数：

```dart
final lightTheme = HyUiTheme.light(
  primary: const Color(0xFF5C6BC0),
);

final darkTheme = HyUiTheme.dark(
  primary: const Color(0xFF9FA8DA),
);
```

## 覆盖玻璃材质

先创建基础主题，再替换扩展：

```dart
ThemeData createLightTheme() {
  final base = HyUiTheme.light(
    primary: const Color(0xFF5C6BC0),
  );

  return base.copyWith(
    extensions: [
      ...base.extensions.values.where(
        (extension) => extension is! HyGlassTheme,
      ),
      HyGlassTheme.light().copyWith(
        surface: const Color(0xDDF8F7FF),
        surfaceStrong: const Color(0xF8F8F7FF),
        selection: const Color(0x205C6BC0),
        pressed: const Color(0x185C6BC0),
      ),
    ],
  );
}
```

明暗主题应分别配置，避免把适合浅色背景的透明度直接用于深色背景。

## 局部主题

页面局部可以使用标准 `Theme` 覆盖：

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      HyUiThemeTokens.of(context).copyWith(
        primary: const Color(0xFF00897B),
      ),
      HyGlassTheme.of(context),
    ],
  ),
  child: const ProfileEditor(),
)
```

除非页面确实代表独立品牌或任务上下文，否则优先保持全局一致性。

## 在组件中读取令牌

自定义组件可以直接复用相同语言：

```dart
final colors = context.hyUi;
final glass = context.hyGlass;

return HyGlass(
  borderColor: glass.edgeHighlight,
  child: Text(
    '自定义内容',
    style: TextStyle(color: colors.foreground),
  ),
);
```

## 透明度与性能

- 长列表中不要为每一行单独开启大半径模糊；使用一个分组材质包住多行内容。
- `HyGlass(blur: 0)` 保留表面、边界和阴影，但不执行背景模糊。
- 大型弹层使用 `prominent`，小控件使用 `subtle`，避免透明表面层层叠加。
- 系统高对比度开启时，`HyGlass` 会自动转向更实的表面和更强边界。

