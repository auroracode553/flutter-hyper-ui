import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_palette.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';

/// 紧凑横向分类筛选栏。业务持有选中索引，组件只管理横向可见位置。
class HyperFilterBar<T> extends StatefulWidget {
  const HyperFilterBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    required this.itemBuilder,
    this.enabled = true,
    this.itemEnabled,
  }) : assert(selectedIndex >= 0 && selectedIndex < items.length);

  final List<T> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Widget Function(T item, bool selected, bool enabled) itemBuilder;
  final bool enabled;
  final bool Function(T item)? itemEnabled;

  @override
  State<HyperFilterBar<T>> createState() => _HyperFilterBarState<T>();
}

class _HyperFilterBarState<T> extends State<HyperFilterBar<T>> {
  final _viewportKey = GlobalKey();
  final _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void didUpdateWidget(covariant HyperFilterBar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != _itemKeys.length) {
      _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.items.length != widget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _revealSelected() {
    if (!mounted ||
        !_scrollController.hasClients ||
        widget.selectedIndex >= _itemKeys.length)
      return;
    final selectedContext = _itemKeys[widget.selectedIndex].currentContext;
    final viewport = _viewportKey.currentContext?.findRenderObject();
    final selected = selectedContext?.findRenderObject();
    if (selectedContext == null ||
        viewport is! RenderBox ||
        selected is! RenderBox ||
        !viewport.hasSize ||
        !selected.hasSize)
      return;
    final offset = selected.localToGlobal(Offset.zero, ancestor: viewport);
    if (offset.dx >= 0 &&
        offset.dx + selected.size.width <= viewport.size.width)
      return;
    // 只滚动分类栏，不调用会连带移动页面纵向视口的 ensureVisible。
    final delta = offset.dx < 0
        ? offset.dx
        : offset.dx + selected.size.width - viewport.size.width;
    final position = _scrollController.position;
    final direction = position.axisDirection == AxisDirection.left ? -1 : 1;
    final target = (position.pixels + delta * direction).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: HyperUiEffects.durationOf(
        context,
        HyperUiEffects.stateDuration,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    return SingleChildScrollView(
      key: _viewportKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < widget.items.length; index++) ...[
            if (index > 0) const SizedBox(width: 6),
            Builder(
              builder: (_) {
                final item = widget.items[index];
                final selected = index == widget.selectedIndex;
                final enabled =
                    widget.enabled && (widget.itemEnabled?.call(item) ?? true);
                final foreground = selected
                    ? tokens.foreground
                    : tokens.mutedForeground;
                return Opacity(
                  opacity: enabled ? 1 : .4,
                  child: HyperPressable(
                    onPressed: enabled
                        ? () {
                            if (!selected) widget.onChanged(index);
                          }
                        : null,
                    borderRadius: BorderRadius.circular(100),
                    child: AnimatedContainer(
                      key: _itemKeys[index],
                      duration: HyperUiEffects.durationOf(
                        context,
                        HyperUiEffects.stateDuration,
                      ),
                      curve: Curves.easeOutCubic,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? glass.selection
                            : HyperPalette.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Align(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: foreground,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          child: IconTheme.merge(
                            data: IconThemeData(size: 16, color: foreground),
                            child: widget.itemBuilder(item, selected, enabled),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
