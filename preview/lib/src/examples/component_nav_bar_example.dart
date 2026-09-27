import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// doc-region NavBarComponentExample
/// 直接使用宿主手机屏幕作为页面视口，不添加演示工具或内层设备框。
class NavBarComponentExample extends StatelessWidget {
  const NavBarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyNavBarPage(
    navBar: const HyNavBar(
      title: Text('今日灵感'),
      automaticallyImplyLeading: false,
    ),
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
  );
}

class _InspirationHeader extends StatelessWidget {
  const _InspirationHeader();

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
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
          HyText('让内容延伸到\n屏幕的每一寸', type: 'title'),
          SizedBox(height: 12),
          HyText('向上滚动，观察这张卡片经过导航标题与状态栏。'),
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
    final tokens = HyUiThemeTokens.of(context);
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
          HyText(
            '灵感 ${index.toString().padLeft(2, '0')}',
            type: 'caption',
          ),
          const SizedBox(height: 18),
          HyText(
            titles[(index - 1) % titles.length],
            type: 'title',
          ),
          const SizedBox(height: 8),
          const HyText('导航栏保持透明，内容沿同一个滚动视口连续向上移动。'),
        ],
      ),
    );
  }
}
// end-doc-region NavBarComponentExample
