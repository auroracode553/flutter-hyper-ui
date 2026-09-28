import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'hyper_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_size.dart';
import 'hyper_button.dart';

/// 使用 Flutter ImageCache 的内存缓存；持久缓存可通过 ImageProvider 注入。
class HyperImage extends StatelessWidget {
  const HyperImage({
    super.key,
    this.type = 'provider',
    this.provider,
    this.source,
    this.width,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorPlaceholder,
    this.preview = false,
  }) : assert(type == 'provider' || type == 'network' || type == 'asset'),
       assert(type == 'provider' ? provider != null : source != null),
       assert(type != 'provider' || source == null),
       assert(type == 'provider' || provider == null);
  final String type;
  final ImageProvider? provider;
  final String? source;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  final Widget? placeholder, errorPlaceholder;
  final bool preview;
  @override
  Widget build(BuildContext context) {
    if (type == 'provider'
        ? provider == null
        : source == null || source!.isEmpty) {
      throw ArgumentError(
        'HyperImage requires provider or nonempty source for its type.',
      );
    }
    if (type == 'provider' ? source != null : provider != null) {
      throw ArgumentError('HyperImage accepts one image source for its type.');
    }
    final ImageProvider imageProvider = switch (type) {
      'network' => NetworkImage(source!),
      'asset' => AssetImage(source!),
      'provider' => provider!,
      _ => throw ArgumentError.value(type, 'type', 'Invalid image type'),
    };
    Widget fallback(bool error) => ColoredBox(
      color: HyperUiThemeTokens.of(context).muted,
      child: Center(
        child: error
            ? (errorPlaceholder ?? const Icon(LucideIcons.imageOff))
            : (placeholder ?? const Icon(LucideIcons.image)),
      ),
    );
    return GestureDetector(
      onTap: preview
          ? () => showHyperModal<void>(
              context,
              scrim: HyperGlassTheme.of(context).scrim,
              builder: (dialogContext) => SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        minScale: .5,
                        maxScale: 5,
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => fallback(true),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: HyperButton(
                          type: 'tonal',
                          icon: LucideIcons.x,
                          tooltip: '关闭预览',
                          color: HyperUiThemeTokens.of(context).foreground,
                          backgroundColor: HyperGlassTheme.of(
                            context,
                          ).surfaceStrong,
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: Image(
            image: imageProvider,
            fit: fit,
            frameBuilder: (_, child, frame, sync) =>
                sync || frame != null ? child : fallback(false),
            errorBuilder: (_, __, ___) => fallback(true),
          ),
        ),
      ),
    );
  }
}

class HyperAvatar extends StatelessWidget {
  const HyperAvatar({
    super.key,
    this.image,
    this.text,
    this.size = 'default',
    this.radius,
    this.color,
    this.backgroundColor,
  });
  final ImageProvider? image;
  final String? text;
  final String size;
  final double? radius;
  final Color? color;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final dimension = hyperUiSizeValue(size, small: 32, normal: 40, large: 56);
    final tokens = HyperUiThemeTokens.of(context);
    final surface =
        backgroundColor ??
        Color.alphaBlend(
          tokens.primary.withAlpha(25),
          HyperGlassTheme.of(context).surfaceSubtle,
        );
    final foreground =
        color ??
        (backgroundColor == null
            ? tokens.primary
            : surface.computeLuminance() < 0.5
            ? HyperPalette.white
            : tokens.foreground);
    final fallback = Center(
      child: text == null || text!.isEmpty
          ? Icon(LucideIcons.user, size: dimension * .5, color: foreground)
          : Text(
              text!.characters.take(2).toString(),
              style: TextStyle(
                fontSize: dimension * .34,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? dimension / 2),
      child: Container(
        width: dimension,
        height: dimension,
        color: surface,
        child: image == null
            ? fallback
            : HyperImage(
                provider: image!,
                width: dimension,
                height: dimension,
                radius: radius ?? dimension / 2,
                errorPlaceholder: fallback,
              ),
      ),
    );
  }
}
