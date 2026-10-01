import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// doc-region NavBarComponentExample
/// 使用 HyperNavBar 展示常见页面导航栏布局。
class NavBarComponentExample extends StatefulWidget {
  const NavBarComponentExample({super.key});

  @override
  State<NavBarComponentExample> createState() => _NavBarComponentExampleState();
}

enum _NavBarExample {
  backOnly('仅返回', '只显示尖括号返回按钮'),
  titleOnly('仅标题', '只显示页面标题，不显示返回按钮'),
  backWithTitle('返回与标题', '返回图标旁显示页面标题'),
  more('更多操作', '返回、标题与更多操作'),
  edit('编辑返回', '返回、标题与保存操作'),
  custom('自定义', '自定义插槽与分享操作');

  const _NavBarExample(this.label, this.description);

  final String label;
  final String description;

  String get type => switch (this) {
    _NavBarExample.backOnly => HyperNavBarTypes.backOnly,
    _NavBarExample.titleOnly => HyperNavBarTypes.titleOnly,
    _NavBarExample.backWithTitle => HyperNavBarTypes.backWithTitle,
    _NavBarExample.more => HyperNavBarTypes.more,
    _NavBarExample.edit => HyperNavBarTypes.edit,
    _NavBarExample.custom => HyperNavBarTypes.custom,
  };
}

class _NavBarComponentExampleState extends State<NavBarComponentExample> {
  _NavBarExample _selected = _NavBarExample.backOnly;
  String _feedback = '切换布局或点击顶部操作，查看导航反馈。';

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    const navBarHeight = 44.0;
    final title = switch (_selected) {
      _NavBarExample.backOnly => null,
      _NavBarExample.titleOnly => '今日灵感',
      _NavBarExample.backWithTitle => '今日灵感',
      _NavBarExample.more => '消息',
      _NavBarExample.edit => '编辑资料',
      _NavBarExample.custom => '创作空间',
    };
    return Stack(
      children: <Widget>[
        // 正文视口从屏幕顶部开始，首屏净空作为滚动内容的一部分。
        Positioned.fill(
          child: ColoredBox(
            color: HyperUiThemeTokens.of(context).background,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      safeArea.top + navBarHeight + 12,
                      16,
                      safeArea.bottom + 24,
                    ),
                    sliver: SliverList.builder(
                      itemCount: 14,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: index == 0
                            ? _NavBarControls(
                                selected: _selected,
                                feedback: _feedback,
                                onSelected: (value) => setState(() {
                                  _selected = value;
                                  _feedback = '已切换为「${value.label}」';
                                }),
                              )
                            : index == 1
                            ? const _InspirationHeader()
                            : _InspirationItem(index: index - 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 导航操作悬浮在同一视口上方；HyperNavBar 不绘制整栏背景。
        HyperNavBar(
          type: _selected.type,
          height: navBarHeight,
          title: title == null ? null : Text(title),
          onBackPressed: () => setState(() => _feedback = '已请求返回上一页'),
          onMorePressed: () => setState(() => _feedback = '已点击更多'),
          onSavePressed: () => setState(() => _feedback = '已点击保存'),
          leading: _selected == _NavBarExample.custom
              ? HyperButton(
                  type: 'ghost',
                  icon: HyperIcons.back,
                  tooltip: '返回',
                  onPressed: () => setState(() => _feedback = '已请求返回上一页'),
                )
              : null,
          trailing: _selected == _NavBarExample.custom
              ? HyperButton(
                  type: 'ghost',
                  label: '分享',
                  onPressed: () => setState(() => _feedback = '已点击分享'),
                )
              : null,
        ),
      ],
    );
  }
}

class _NavBarControls extends StatelessWidget {
  const _NavBarControls({
    required this.selected,
    required this.feedback,
    required this.onSelected,
  });

  final _NavBarExample selected;
  final String feedback;
  final ValueChanged<_NavBarExample> onSelected;

  @override
  Widget build(BuildContext context) => HyperCard(
    title: '常见顶部导航',
    subtitle: selected.description,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _NavBarExample.values
              .map(
                (value) => HyperButton(
                  type: value == selected ? 'tonal' : 'ghost',
                  size: 'small',
                  label: value.label,
                  onPressed: () => onSelected(value),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        HyperText(feedback, size: 'small'),
        const SizedBox(height: 6),
        const HyperText('向上滚动，观察正文经过固定导航栏。', size: 'small'),
      ],
    ),
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
