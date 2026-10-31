import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region LoadingComponentExample
class LoadingComponentExample extends StatelessWidget {
  const LoadingComponentExample({super.key});
  static const _names = [
    '行波脉冲',
    '双弦错织',
    '弧带换向',
    '三体协奏',
    '双彗交汇',
    '光子穿梭',
    '磁光星芒',
    '流金沙漏',
    '变频鳍片',
    '柔波光栅',
  ];

  @override
  Widget build(BuildContext context) {
    final types = HyperLoadingType.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyperText('默认随机'),
        const SizedBox(height: 16),
        const Center(child: HyperLoading(label: '加载中')),
        const SizedBox(height: 24),
        const HyperText('十款原生动画'),
        const SizedBox(height: 8),
        for (var row = 0; row < 5; row++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var col = 0; col < 2; col++)
                Expanded(
                  child: SizedBox(
                    height: 170,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 132,
                          child: Center(
                            child: HyperLoading(
                              type: types[row * 2 + col],
                              label: _names[row * 2 + col],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          types[row * 2 + col].name,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
// end-doc-region LoadingComponentExample
