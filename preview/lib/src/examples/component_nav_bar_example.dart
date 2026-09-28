import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// doc-region NavBarComponentExample
/// 使用 HyperNavBar 作为页面导航栏。
class NavBarComponentExample extends StatelessWidget {
  const NavBarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      const HyperNavBar(title: Text('今日灵感'), showBackButton: false),
      Expanded(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverList.builder(
                itemCount: 13,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: index == 0
                      ? const _InspirationHeader()
                      : _InspirationItem(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _InspirationHeader extends StatelessWidget {
  const _InspirationHeader();

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            tokens.primary.withValues(alpha: .24),
            tokens.primary.withValues(alpha: .06),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(LucideIcons.sparkles, size: 28),
          SizedBox(height: 28),
          HyperText('让内容自然流动', size: 'large'),
          SizedBox(height: 12),
          HyperText('向上滚动，观察导航栏保持固定。'),
        ],
      ),
    );
  }
}

class _InspirationItem extends StatelessWidget {
  const _InspirationItem({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    const titles = <String>['留一点空白', '光影与秩序', '日常里的灵感'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: index.isEven ? .12 : .05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HyperText('灵感 ${index.toString().padLeft(2, '0')}', size: 'small'),
          const SizedBox(height: 18),
          HyperText(titles[(index - 1) % titles.length], size: 'large'),
          const SizedBox(height: 8),
          const HyperText('导航栏保持透明，列表内容连续向上移动。'),
        ],
      ),
    );
  }
}
// end-doc-region NavBarComponentExample
