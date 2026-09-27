import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region CarouselComponentExample
class CarouselComponentExample extends StatefulWidget {
  const CarouselComponentExample({super.key});

  @override
  State<CarouselComponentExample> createState() =>
      _CarouselComponentExampleState();
}

class _CarouselComponentExampleState extends State<CarouselComponentExample> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HyperCarousel(
          height: 150,
          onPageChanged: (page) => setState(() => _page = page),
          items: <Widget>[
            _CarouselPanel(
              title: '柔性玻璃',
              icon: LucideIcons.aperture,
              color: tokens.primary.withAlpha(35),
            ),
            _CarouselPanel(
              title: '轻量交互',
              icon: LucideIcons.hand,
              color: tokens.success.withAlpha(35),
            ),
            _CarouselPanel(
              title: '一致尺寸',
              icon: LucideIcons.ratio,
              color: tokens.info.withAlpha(35),
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperText('当前第 ${_page + 1} 页', size: 'small'),
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
    final tokens = HyperUiThemeTokens.of(context);
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 30, color: tokens.primary),
          const SizedBox(height: HyperUiSpacing.xs),
          HyperText(title, size: 'large'),
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
        const HyperText('点击圆点切换选中页', size: 'small'),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperPageIndicator(
          count: 5,
          index: _index,
          onSelected: (index) => setState(() => _index = index),
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperText('只读指示器', size: 'small'),
        const HyperPageIndicator(count: 3, index: 1),
      ],
    );
  }
}
// end-doc-region PageIndicatorComponentExample
