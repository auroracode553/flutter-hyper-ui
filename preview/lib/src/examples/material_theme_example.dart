import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 在局部主题内切换材质，便于同时观察卡片、按钮和输入框。
class MaterialThemeExample extends StatefulWidget {
  const MaterialThemeExample({super.key});

  @override
  State<MaterialThemeExample> createState() => _MaterialThemeExampleState();
}

class _MaterialThemeExampleState extends State<MaterialThemeExample> {
  HyperMaterial _material = HyperMaterial.solid;

  @override
  Widget build(BuildContext context) {
    return HyperUiTheme(
      data: HyperUiTheme.of(context).copyWith(material: _material),
      child: Stack(
        children: [
          Positioned(
            top: 42,
            right: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HyperUiTheme.of(context).tokens.primary.withAlpha(90),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 130, height: 130),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final material in HyperMaterial.values)
                    HyperButton(
                      type: material == _material ? 'filled' : 'tonal',
                      label: material.name,
                      onPressed: () => setState(() => _material = material),
                    ),
                ],
              ),
              HyperCard(
                title: '主题材质：${_material.name}',
                subtitle: '卡片、按钮和输入框统一读取当前材质',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    const HyperTextField(hintText: '输入内容'),
                    HyperButton(label: '主要操作', onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
