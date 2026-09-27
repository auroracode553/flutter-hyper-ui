import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TooltipComponentExample
class TooltipComponentExample extends StatelessWidget {
  const TooltipComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyperText('悬停、长按或键盘聚焦查看提示', size: 'small'),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperTooltip(
          message: '更改后会同步到所有设备。',
          child: HyperButton.icon(icon: LucideIcons.info, onPressed: () {}),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        HyperTooltip(
          message: '这是一段较长的说明，会在可用宽度内自动换行。',
          child: HyperButton.tonal(label: '查看权限说明', onPressed: () {}),
        ),
      ],
    );
  }
}
// end-doc-region TooltipComponentExample
