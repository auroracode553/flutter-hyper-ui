import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region ScrollGradientComponentExample
class ScrollGradientComponentExample extends StatefulWidget {
  const ScrollGradientComponentExample({super.key});

  @override
  State<ScrollGradientComponentExample> createState() =>
      _ScrollGradientComponentExampleState();
}

class _ScrollGradientComponentExampleState
    extends State<ScrollGradientComponentExample> {
  final _scroll = ScrollController();
  bool _forceVisible = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return HyperNavBarScrollScope(
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: HyperUiThemeTokens.of(context).background,
              child: ListView.builder(
                controller: _scroll,
                padding: EdgeInsets.fromLTRB(16, top + 44 + 12, 16, 24),
                itemCount: 21,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: index == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HyperText('向上滚动观察渐显，回到顶部恢复透明。'),
                            const SizedBox(height: 12),
                            const HyperText('渐变不采样正文，前景操作保持清晰。'),
                            const SizedBox(height: 12),
                            HyperButton(
                              label: _forceVisible ? '恢复自动感知' : '固定显示材质',
                              onPressed: () => setState(
                                () => _forceVisible = !_forceVisible,
                              ),
                            ),
                          ],
                        )
                      : HyperCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HyperText('灵感 $index'),
                                const SizedBox(height: 12),
                                const HyperText('让内容自然流动，前景操作保持清晰。'),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          HyperScrollGradient(
            scrolledUnder: _forceVisible,
            child: Padding(
              padding: EdgeInsets.only(top: top),
              child: SizedBox(
                height: 44,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const HyperText('滚动渐变'),
                      const SizedBox(width: 8),
                      HyperButton(
                        label: '回到顶部',
                        onPressed: () => _scroll.animateTo(
                          0,
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// end-doc-region ScrollGradientComponentExample
