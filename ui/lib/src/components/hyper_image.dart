import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'hyper_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';

/// 使用 Flutter ImageCache 的内存缓存；持久缓存可通过 ImageProvider 注入。
class HyperImage extends StatelessWidget {
  const HyperImage({
    super.key,
    required this.provider,
    this.width,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorPlaceholder,
    this.preview = false,
  });
  HyperImage.network(
    String url, {
    Key? key,
    double? width,
    double? height,
    double radius = 16,
    BoxFit fit = BoxFit.cover,
    bool preview = false,
  }) : this(
         key: key,
         provider: NetworkImage(url),
         width: width,
         height: height,
         radius: radius,
         fit: fit,
         preview: preview,
       );
  HyperImage.asset(
    String path, {
    Key? key,
    double? width,
    double? height,
    double radius = 16,
    BoxFit fit = BoxFit.cover,
    bool preview = false,
  }) : this(
         key: key,
         provider: AssetImage(path),
         width: width,
         height: height,
         radius: radius,
         fit: fit,
         preview: preview,
       );
  final ImageProvider provider;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  final Widget? placeholder, errorPlaceholder;
  final bool preview;
  @override
  Widget build(BuildContext context) {
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
              scrim: HyperPalette.black,
              builder: (dialogContext) => SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        minScale: .5,
                        maxScale: 5,
                        child: Image(
                          image: provider,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => fallback(true),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: HyperButton.icon(
                          icon: LucideIcons.x,
                          tooltip: '关闭预览',
                          color: HyperPalette.white,
                          backgroundColor: HyperPalette.black38,
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
            image: provider,
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
    this.size = 40,
    this.radius,
    this.backgroundColor,
  });
  final ImageProvider? image;
  final String? text;
  final double size;
  final double? radius;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final surface = backgroundColor ?? tokens.selectionBackground;
    final foreground = backgroundColor == null
        ? tokens.primary
        : surface.computeLuminance() < 0.5
        ? HyperPalette.white
        : tokens.foreground;
    final fallback = Center(
      child: text == null || text!.isEmpty
          ? Icon(LucideIcons.user, size: size * .5, color: foreground)
          : Text(
              text!.characters.take(2).toString(),
              style: TextStyle(
                fontSize: size * .34,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: Container(
        width: size,
        height: size,
        color: surface,
        child: image == null
            ? fallback
            : HyperImage(
                provider: image!,
                width: size,
                height: size,
                radius: radius ?? size / 2,
                errorPlaceholder: fallback,
              ),
      ),
    );
  }
}
