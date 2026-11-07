import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TooltipComponentExample
class TooltipComponentExample extends StatelessWidget {
  /// 使用顶部普通内容入口验证提示翻转；滚动与大字号仍受窗口安全边界限制。
  const TooltipComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyperText('悬停、长按或键盘聚焦查看提示'),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperTooltip(
          message: '更改后会同步到所有设备。',
          child: HyperButton(
            type: 'icon',
            icon: LucideIcons.info,
            onPressed: () {},
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        HyperTooltip(
          // 复用现有长说明入口，让正常手机视口也能验证向下翻转和边界限制。
          message: '较长的补充提示会自动换行，顶部空间不足时向下显示，内容始终限制在窗口安全区域内。' * 8,
          child: HyperButton(label: '查看权限说明', onPressed: () {}),
        ),
      ],
    );
  }
}
// end-doc-region TooltipComponentExample
