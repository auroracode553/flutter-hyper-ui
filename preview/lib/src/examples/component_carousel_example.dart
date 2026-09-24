import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region CarouselComponentExample
class CarouselComponentExample extends StatefulWidget {
  const CarouselComponentExample({super.key});

  @override
  State<CarouselComponentExample> createState() => _CarouselComponentExampleState();
}

class _CarouselComponentExampleState extends State<CarouselComponentExample> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HyCarousel(
          height: 150,
          onPageChanged: (page) => setState(() => _page = page),
          items: <Widget>[
            _CarouselPanel(
              title: '柔性玻璃',
              icon: Icons.blur_on_rounded,
              color: tokens.primary.withAlpha(35),
            ),
            _CarouselPanel(
              title: '轻量交互',
              icon: Icons.touch_app_rounded,
              color: tokens.success.withAlpha(35),
            ),
            _CarouselPanel(
              title: '一致尺寸',
              icon: Icons.aspect_ratio_rounded,
              color: tokens.info.withAlpha(35),
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.xs),
        HyText('当前第 ${_page + 1} 页', variant: HyTextStyle.caption),
      ],
    );
  }
}

class _CarouselPanel extends StatelessWidget {
  const _CarouselPanel({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 30, color: tokens.primary),
          const SizedBox(height: HyUiSpacing.xs),
          HyText(title, variant: HyTextStyle.heading),
        ],
      ),
    );
  }
}
// end-doc-region CarouselComponentExample

// doc-region PageIndicatorComponentExample
class PageIndicatorComponentExample extends StatefulWidget {
  const PageIndicatorComponentExample({super.key});

  @override
  State<PageIndicatorComponentExample> createState() =>
      _PageIndicatorComponentExampleState();
}

class _PageIndicatorComponentExampleState
    extends State<PageIndicatorComponentExample> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyText('点击圆点切换选中页', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        HyPageIndicator(
          count: 5,
          index: _index,
          onSelected: (index) => setState(() => _index = index),
        ),
        const SizedBox(height: HyUiSpacing.sm),
        const HyText('只读指示器', variant: HyTextStyle.caption),
        const HyPageIndicator(count: 3, index: 1),
      ],
    );
  }
}
// end-doc-region PageIndicatorComponentExample
