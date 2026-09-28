<script setup>
import DemoBlock from '../.vitepress/theme/components/DemoBlock.vue';

const materialCode = `HyperUiTheme.app(
  material: HyperMaterial.soft,
  home: const AppHome(),
);

HyperUiTheme(
  data: HyperUiTheme.of(context).copyWith(material: HyperMaterial.clear),
  child: const ProfilePanel(),
);`;
</script>

# 主题配置

`HyperUiTheme` 同时配置明暗模式、品牌色和表面材质。`HyperUiThemeTokens` 提供内容与状态颜色；`HyperGlassTheme` 是内部组件共享的表面、边缘、遮罩和模糊令牌。

## 在应用中接入 UI 库

在应用入口包裹 `HyperUiTheme.app`，其子树中的 Hyper 组件会读取同一份主题。只需引入组件库公开入口：

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

void main() {
  runApp(
    HyperUiTheme.app(
      home: const AppHome(),
      primary: const Color(0xFF5C6BC0),
      material: HyperMaterial.soft,
    ),
  );
}
```

| 配置项 | 用途 | 默认值 |
| --- | --- | --- |
| `brightness` | 指定亮色或暗色；省略时跟随系统 | 系统模式 |
| `primary` | 品牌主色 | 库默认主色 |
| `material` | 选择表面材质 | `HyperMaterial.solid` |
| `fontFamily` | 指定全局字体族 | Flutter 默认字体 |

已有页面宿主时，可构造 `HyperUiTheme.light(...)` 或 `HyperUiTheme.dark(...)`，再用 `HyperUiTheme(data: theme, child: ...)` 包裹需要使用 Hyper 组件的子树。

## 明暗模式

```dart
HyperUiTheme.app(
  home: const AppHome(),
  primary: const Color(0xFF5C6BC0),
);
```

默认跟随系统明暗模式；传入 `brightness: Brightness.light` 或 `Brightness.dark` 可固定模式。

## 表面材质

材质可选 `HyperMaterial.solid`、`HyperMaterial.soft`、`HyperMaterial.clear`，默认 `solid`。主题同时调整常规、轻量和浮层表面的透明度与模糊强度，卡片、菜单、按钮及输入框会一起更新。

<DemoBlock
  title="切换表面材质"
  component="theme-material"
  :code="materialCode"
  :height="420"
/>

全应用配置：

```dart
HyperUiTheme.app(
  material: HyperMaterial.soft,
  home: const AppHome(),
);
```

运行时切换时，用应用状态保存所选材质，重建 `HyperUiTheme.app` 并传入新值。局部容器可继承当前主题后覆盖：

```dart
HyperUiTheme(
  data: HyperUiTheme.of(context).copyWith(material: HyperMaterial.clear),
  child: const ProfilePanel(),
)
```

## 精细覆盖

需要调整品牌表面时，从当前主题的令牌复制，保持明暗模式和材质档位一致：

```dart
final current = HyperUiTheme.of(context);
final custom = current.copyWith(
  glass: current.glass.copyWith(
    selection: const Color(0x205C6BC0),
    pressed: const Color(0x185C6BC0),
  ),
);

return HyperUiTheme(data: custom, child: const ProfilePanel());
```

`copyWith(material: ...)` 会生成该档位对应的表面令牌。若同次调用也传入 `glass`，以传入的完整令牌为准。

## 从旧 API 迁移

| 旧写法 | 新写法 |
| --- | --- |
| `HyperGlass(...)` | 用 `HyperCard`、`HyperMenuGroup` 等语义组件承载内容；材质由主题设置 |
| `HyperGlass(type: 'solid', ...)` | 在应用或局部主题设置 `HyperMaterial.solid` |
| `HyperGlass(blur: ...)` | 选择 `solid / soft / clear`，或精细覆盖 `glass.blur` 与 `glass.blurStrong` |

`HyperGlass` 不再从包入口导出，也不再作为独立组件登记。`HyperGlassTheme` 仍可用于精细主题配置。
