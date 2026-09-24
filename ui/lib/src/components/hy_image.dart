import 'package:flutter/material.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_icon_button.dart';

/// 使用 Flutter ImageCache 的内存缓存；持久缓存可通过 ImageProvider 注入。
class HyImage extends StatelessWidget {
  const HyImage({
    super.key,
    required this.provider,
    this.width,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorPlaceholder,
    this.preview = false,
    this.semanticLabel,
  });
  HyImage.network(
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
  HyImage.asset(
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
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) {
    Widget fallback(bool error) => ColoredBox(
      color: HyUiThemeTokens.of(context).muted,
      child: Center(
        child: error
            ? (errorPlaceholder ?? const Icon(Icons.broken_image_outlined))
            : (placeholder ?? const Icon(Icons.image_outlined)),
      ),
    );
    return Semantics(
      button: preview,
      label: semanticLabel,
      child: GestureDetector(
        onTap: preview
            ? () => showDialog<void>(
                context: context,
                builder: (dialogContext) => Dialog.fullscreen(
                  backgroundColor: Colors.black,
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
                          child: HyIconButton(
                            icon: Icons.close,
                            tooltip: '关闭预览',
                            color: Colors.white,
                            backgroundColor: Colors.black38,
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
              semanticLabel: semanticLabel,
              frameBuilder: (_, child, frame, sync) =>
                  sync || frame != null ? child : fallback(false),
              errorBuilder: (_, __, ___) => fallback(true),
            ),
          ),
        ),
      ),
    );
  }
}

class HyAvatar extends StatelessWidget {
  const HyAvatar({
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
    final tokens = HyUiThemeTokens.of(context);
    final fallback = Center(
      child: text == null || text!.isEmpty
          ? Icon(Icons.person_rounded, size: size * .5, color: tokens.primary)
          : Text(
              text!.characters.take(2).toString(),
              style: TextStyle(
                fontSize: size * .34,
                fontWeight: FontWeight.w600,
                color: tokens.primary,
              ),
            ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: Container(
        width: size,
        height: size,
        color: backgroundColor ?? tokens.selectionBackground,
        child: image == null
            ? fallback
            : HyImage(
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

class HyCountBadge extends StatelessWidget {
  const HyCountBadge({
    super.key,
    required this.child,
    this.count = 0,
    this.max = 99,
    this.dot = false,
    this.showZero = false,
  });
  final Widget child;
  final int count, max;
  final bool dot, showZero;
  @override
  Widget build(BuildContext context) {
    final visible = dot || count > 0 || showZero;
    final error = HyUiThemeTokens.of(context).error;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (visible)
          Positioned(
            top: -5,
            right: -5,
            child: dot
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: error,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    constraints: const BoxConstraints(minWidth: 16),
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      count > max ? '$max+' : '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}
