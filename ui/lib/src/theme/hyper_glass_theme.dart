import 'package:flutter/widgets.dart';

import 'hyper_ui_theme.dart';
import 'hyper_material.dart';

/// 柔性玻璃视觉令牌。
///
/// 颜色只描述材质层级，不携带任何业务语义。应用可以通过 [HyperUiThemeData.glass]
/// 覆盖它，从而在不修改组件源码的前提下建立自己的品牌风格。
@immutable
class HyperGlassTheme {
  const HyperGlassTheme({
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
    required this.blur,
    required this.blurStrong,
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

  /// 常规表面和浮层的背景模糊半径。
  final double blur;
  final double blurStrong;

  List<BoxShadow> get surfaceShadows => <BoxShadow>[
    BoxShadow(
      color: shadow,
      blurRadius: 28,
      spreadRadius: -6,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: shadow.withValues(alpha: shadow.a * 0.42),
      blurRadius: 8,
      spreadRadius: -3,
      offset: const Offset(0, 3),
    ),
  ];

  /// 所有组件从同一材质档位生成表面颜色和模糊强度。
  factory HyperGlassTheme.forMaterial(
    Brightness brightness,
    HyperMaterial material,
  ) {
    final base = brightness == Brightness.dark
        ? HyperGlassTheme.dark()
        : HyperGlassTheme.light();
    if (material == HyperMaterial.soft) return base;
    final solid = material == HyperMaterial.solid;
    final surface = brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFFFFFFF);
    return base.copyWith(
      surface: surface.withAlpha(solid ? 255 : 118),
      surfaceStrong: surface.withAlpha(solid ? 255 : 153),
      surfaceSubtle: surface.withAlpha(solid ? 255 : 77),
      edgeHighlight: solid
          ? (brightness == Brightness.dark
                ? const Color(0xFF343B47)
                : const Color(0x18111216))
          : base.edgeHighlight,
      edgeShade: solid ? const Color(0x00000000) : base.edgeShade,
      blur: solid ? 0 : 32,
      blurStrong: solid ? 0 : 40,
    );
  }

  factory HyperGlassTheme.light() => const HyperGlassTheme(
    surface: Color(0xD9FFFFFF),
    surfaceStrong: Color(0xF7FFFFFF),
    surfaceSubtle: Color(0xBFFFFFFF),
    edgeHighlight: Color(0xE6FFFFFF),
    edgeShade: Color(0x12111216),
    shadow: Color(0x14111A28),
    controlTrack: Color(0x16000000),
    selection: Color(0x1F000000),
    pressed: Color(0x14000000),
    scrim: Color(0x52080B12),
    blur: 20,
    blurStrong: 28,
  );

  factory HyperGlassTheme.dark() => const HyperGlassTheme(
    surface: Color(0xD91E2026),
    surfaceStrong: Color(0xF22C2E33),
    surfaceSubtle: Color(0xB31E2026),
    edgeHighlight: Color(0x2EFFFFFF),
    edgeShade: Color(0x1FFFFFFF),
    shadow: Color(0x52000000),
    controlTrack: Color(0x24FFFFFF),
    selection: Color(0x1FFFFFFF),
    pressed: Color(0x1FFFFFFF),
    scrim: Color(0x99000000),
    blur: 20,
    blurStrong: 28,
  );

  static HyperGlassTheme of(BuildContext context) {
    return HyperUiTheme.of(context).glass;
  }

  HyperGlassTheme copyWith({
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
    double? blur,
    double? blurStrong,
  }) {
    return HyperGlassTheme(
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
      blur: blur ?? this.blur,
      blurStrong: blurStrong ?? this.blurStrong,
    );
  }

  HyperGlassTheme lerp(HyperGlassTheme other, double t) {
    return HyperGlassTheme(
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
      blur: blur + (other.blur - blur) * t,
      blurStrong: blurStrong + (other.blurStrong - blurStrong) * t,
    );
  }
}
