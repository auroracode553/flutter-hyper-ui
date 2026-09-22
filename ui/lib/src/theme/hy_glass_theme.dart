import 'package:flutter/material.dart';

/// 柔性玻璃视觉令牌。
///
/// 颜色只描述材质层级，不携带任何业务语义。应用可以通过 [ThemeData.extensions]
/// 覆盖它，从而在不修改组件源码的前提下建立自己的品牌风格。
@immutable
class HyGlassTheme extends ThemeExtension<HyGlassTheme> {
  const HyGlassTheme({
    required this.surface,
    required this.surfaceStrong,
    required this.surfaceSubtle,
    required this.edgeHighlight,
    required this.edgeShade,
    required this.shadow,
    required this.controlTrack,
    required this.selection,
    required this.pressed,
    required this.scrim,
  });

  /// 标准玻璃表面，用于卡片和常规容器。
  final Color surface;

  /// 高不透明度玻璃表面，用于抽屉、弹层等强调层级。
  final Color surfaceStrong;

  /// 轻量玻璃表面，用于输入框和小型控件。
  final Color surfaceSubtle;

  /// 模拟玻璃迎光边缘的高光色。
  final Color edgeHighlight;

  /// 为浅色玻璃提供轮廓、为深色玻璃提供分隔的边缘色。
  final Color edgeShade;

  /// 浮动表面的环境阴影色。
  final Color shadow;

  /// 未选中控件轨道、骨架和低强调背景色。
  final Color controlTrack;

  /// 胶囊、菜单和分段控件的选中背景色。
  final Color selection;

  /// 触控按下、悬停和聚焦状态的反馈色。
  final Color pressed;

  /// 模态抽屉、对话框和加载层使用的背景遮罩色。
  final Color scrim;

  factory HyGlassTheme.light() => const HyGlassTheme(
    surface: Color(0xD9FFFFFF),
    surfaceStrong: Color(0xF7FFFFFF),
    surfaceSubtle: Color(0xBFFFFFFF),
    edgeHighlight: Color(0xE6FFFFFF),
    edgeShade: Color(0x12111216),
    shadow: Color(0x18111A28),
    controlTrack: Color(0x16000000),
    selection: Color(0x1F000000),
    pressed: Color(0x14000000),
    scrim: Color(0x52080B12),
  );

  factory HyGlassTheme.dark() => const HyGlassTheme(
    surface: Color(0xD91E2026),
    surfaceStrong: Color(0xF22C2E33),
    surfaceSubtle: Color(0xB31E2026),
    edgeHighlight: Color(0x2EFFFFFF),
    edgeShade: Color(0x1FFFFFFF),
    shadow: Color(0x80000000),
    controlTrack: Color(0x24FFFFFF),
    selection: Color(0x1FFFFFFF),
    pressed: Color(0x1FFFFFFF),
    scrim: Color(0x99000000),
  );

  static HyGlassTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<HyGlassTheme>() ??
        (theme.brightness == Brightness.dark
            ? HyGlassTheme.dark()
            : HyGlassTheme.light());
  }

  @override
  HyGlassTheme copyWith({
    Color? surface,
    Color? surfaceStrong,
    Color? surfaceSubtle,
    Color? edgeHighlight,
    Color? edgeShade,
    Color? shadow,
    Color? controlTrack,
    Color? selection,
    Color? pressed,
    Color? scrim,
  }) {
    return HyGlassTheme(
      surface: surface ?? this.surface,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      edgeHighlight: edgeHighlight ?? this.edgeHighlight,
      edgeShade: edgeShade ?? this.edgeShade,
      shadow: shadow ?? this.shadow,
      controlTrack: controlTrack ?? this.controlTrack,
      selection: selection ?? this.selection,
      pressed: pressed ?? this.pressed,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  HyGlassTheme lerp(ThemeExtension<HyGlassTheme>? other, double t) {
    if (other is! HyGlassTheme) return this;
    return HyGlassTheme(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      edgeHighlight: Color.lerp(edgeHighlight, other.edgeHighlight, t)!,
      edgeShade: Color.lerp(edgeShade, other.edgeShade, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      controlTrack: Color.lerp(controlTrack, other.controlTrack, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
      pressed: Color.lerp(pressed, other.pressed, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}
