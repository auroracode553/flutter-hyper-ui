import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region TooltipComponentExample
class TooltipComponentExample extends StatelessWidget {
  const TooltipComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyText('悬停、长按或键盘聚焦查看提示', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.sm),
        HyTooltip(
          message: '更改后会同步到所有设备。',
          child: HyIconButton(
            icon: LucideIcons.info,
            semanticLabel: '同步说明',
            onPressed: () {},
          ),
        ),
        const SizedBox(height: HyUiSpacing.lg),
        HyTooltip(
          message: '这是一段较长的说明，会在可用宽度内自动换行。',
          child: HyButton.tonal(label: '查看权限说明', onPressed: () {}),
        ),
      ],
    );
  }
}
// end-doc-region TooltipComponentExample
