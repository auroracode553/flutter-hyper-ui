import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_icon_button.dart';
import 'hy_pressable.dart';

/// 适合明确跳页场景的受控分页导航；页码从 1 开始。
class HyPagination extends StatelessWidget {
  const HyPagination({
    super.key,
    required this.page,
    required this.pageCount,
    this.onChanged,
    this.maxVisiblePages = 5,
  }) : assert(pageCount >= 0),
       assert(maxVisiblePages >= 1),
       assert((pageCount == 0 && page == 0) ||
           (pageCount > 0 && page >= 1 && page <= pageCount));

  final int page;
  final int pageCount;
  final ValueChanged<int>? onChanged;
  final int maxVisiblePages;

  List<int?> _visiblePages() {
    if (pageCount == 0) return const <int?>[];
    final start = math.max(
      1,
      math.min(page - maxVisiblePages ~/ 2, pageCount - maxVisiblePages + 1),
    );
    final end = math.min(pageCount, start + maxVisiblePages - 1);
    return <int?>[
      if (start > 1) 1,
      if (start > 2) null,
      for (var number = start; number <= end; number++) number,
      if (end < pageCount - 1) null,
      if (end < pageCount) pageCount,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: HyGlass(
        radius: 16,
        blur: 12,
        weight: HyGlassWeight.subtle,
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HyIconButton(
              icon: rtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
              semanticLabel: '上一页',
              size: 32,
              iconSize: 18,
              radius: 12,
              color: page > 1 ? tokens.foreground : tokens.mutedForeground,
              onPressed: page > 1 && onChanged != null
                  ? () => onChanged!(page - 1)
                  : null,
            ),
            if (pageCount == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('0 / 0', style: TextStyle(color: tokens.mutedForeground)),
              )
            else
              for (final number in _visiblePages())
                number == null
                    ? SizedBox(
                        width: 22,
                        child: Text(
                          '…',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: tokens.mutedForeground),
                        ),
                      )
                    : Semantics(
                        selected: number == page,
                        child: HyPressable(
                          semanticLabel: '第 $number 页，共 $pageCount 页',
                          onPressed: onChanged == null || number == page
                              ? null
                              : () => onChanged!(number),
                          borderRadius: BorderRadius.circular(11),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 32),
                            height: 32,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: number == page
                                  ? glass.selection
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text(
                              '$number',
                              style: TextStyle(
                                color: number == page
                                    ? tokens.primary
                                    : tokens.foreground,
                                fontSize: 12,
                                fontWeight: number == page
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
            HyIconButton(
              icon: rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              semanticLabel: '下一页',
              size: 32,
              iconSize: 18,
              radius: 12,
              color: page < pageCount
                  ? tokens.foreground
                  : tokens.mutedForeground,
              onPressed: page < pageCount && onChanged != null
                  ? () => onChanged!(page + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
