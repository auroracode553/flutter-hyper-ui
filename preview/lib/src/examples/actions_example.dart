import 'package:flutter/material.dart';

import 'buttons_example.dart';
import 'cards_example.dart';

/// 文档“按钮与卡片”分类的组合演示，直接复用两个单职责示例。
class ActionsExample extends StatelessWidget {
  const ActionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ButtonsExample(),
        SizedBox(height: 24),
        CardsExample(),
      ],
    );
  }
}
