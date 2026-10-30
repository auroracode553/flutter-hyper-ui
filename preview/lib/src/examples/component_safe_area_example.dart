import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region SafeAreaComponentExample
class SafeAreaComponentExample extends StatefulWidget {
  const SafeAreaComponentExample({super.key});
  @override
  State<SafeAreaComponentExample> createState() => _SafeAreaExampleState();
}

class _SafeAreaExampleState extends State<SafeAreaComponentExample> {
  bool _top = false;
  bool _portrait = true;
  bool _nested = false;
  bool _systemArea = true;
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    final edge = _top ? HyperSafeAreaEdge.top : HyperSafeAreaEdge.bottom;
    final action = HyperButton(
      onPressed: () => setState(() => _count++),
      content: const Text('操作按钮'),
    );
    final simulated = MediaQuery.of(context).copyWith(
      size: _portrait ? const Size(375, 817) : const Size(817, 375),
      padding: EdgeInsets.only(
        top: _systemArea ? 48 : 0,
        bottom: _systemArea ? 28 : 0,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            HyperButton(
              onPressed: () => setState(() => _top = !_top),
              content: Text(_top ? '顶部' : '底部'),
            ),
            const SizedBox(width: 8),
            HyperButton(
              onPressed: () => setState(() => _nested = !_nested),
              content: Text(_nested ? '嵌套：开' : '嵌套：关'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HyperButton(
          onPressed: () => setState(() => _systemArea = !_systemArea),
          content: Text(_systemArea ? '系统区：开' : '系统区：关'),
        ),
        const SizedBox(height: 12),
        HyperButton(
          onPressed: () => setState(() => _portrait = !_portrait),
          content: Text(_portrait ? '竖屏' : '横屏'),
        ),
        Text('嵌套不重复；竖屏底部最小 20dp，横屏只避系统区；操作 $_count 次'),
        const SizedBox(height: 12),
        MediaQuery(
          data: simulated,
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: ColoredBox(
              color: HyperUiThemeTokens.of(context).background,
              child: Align(
                alignment: _top ? Alignment.topCenter : Alignment.bottomCenter,
                child: HyperSafeArea(
                  edge: edge,
                  child: _nested
                      ? HyperSafeArea(edge: edge, child: action)
                      : action,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// end-doc-region SafeAreaComponentExample
