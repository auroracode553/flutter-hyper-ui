import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TextComponentExample
class TextComponentExample extends StatelessWidget {
  const TextComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('文字尺寸'),
        const Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HyperText('Large 大号文字', size: 'large'),
            HyperText('Default 默认文字'),
            HyperText('Small 辅助文字', size: 'small'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('颜色、字重与行数截断'),
        HyperText('主题品牌色', color: HyperUiThemeTokens.of(context).primary),
        const HyperText('加粗正文', weight: FontWeight.w600),
        const HyperText(
          'maxLines: 1 时超长文本自动省略：统一文字层级让界面在不同密度下保持稳定节奏。',
          maxLines: 1,
        ),
      ],
    );
  }
}
// end-doc-region TextComponentExample

// doc-region IconComponentExample
class IconComponentExample extends StatelessWidget {
  const IconComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('常用语义图标'),
        const Wrap(
          spacing: 22,
          runSpacing: 22,
          children: [
            HyperIcon(HyperIcons.home),
            HyperIcon(HyperIcons.search),
            HyperIcon(HyperIcons.cart),
            HyperIcon(HyperIcons.settings),
            HyperIcon(HyperIcons.profile),
            HyperIcon(HyperIcons.success),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('尺寸与颜色'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyperIcon(HyperIcons.image, size: 'small'),
            HyperIcon(HyperIcons.image, size: 'default'),
            HyperIcon(HyperIcons.image, size: 'large'),
            HyperIcon(
              HyperIcons.warning,
              size: 'large',
              color: HyperUiColors.warning,
            ),
            HyperIcon(
              HyperIcons.success,
              size: 'large',
              color: HyperUiColors.success,
            ),
          ],
        ),
      ],
    );
  }
}
// end-doc-region IconComponentExample

// doc-region ImageComponentExample
class ImageComponentExample extends StatelessWidget {
  const ImageComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('网络图片与点击预览'),
        HyperImage(
          type: 'network',
          source:
              'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=900',
          height: 180,
          width: double.infinity,
          radius: 22,
          preview: true,
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('加载占位与失败兜底'),
        Row(
          children: [
            Expanded(
              // provider 直连时可用 placeholder / errorPlaceholder 定制状态。
              child: HyperImage(
                provider: NetworkImage(
                  'https://images.unsplash.com/photo-1742666553489-3b34b0c8b77b?w=600',
                ),
                height: 110,
                radius: 16,
                placeholder: const Center(child: HyperLoading()),
              ),
            ),
            SizedBox(width: HyperUiSpacing.md),
            Expanded(
              child: HyperImage(
                provider: NetworkImage('https://invalid.example/broken.png'),
                height: 110,
                radius: 16,
                errorPlaceholder: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.imageOff),
                    SizedBox(height: 4),
                    HyperText('加载失败', size: 'small'),
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
// end-doc-region ImageComponentExample

// doc-region AvatarComponentExample
class AvatarComponentExample extends StatelessWidget {
  const AvatarComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('文字头像与尺寸'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyperAvatar(text: '林', size: 'default'),
            HyperAvatar(text: 'UI', size: 'large'),
            HyperAvatar(size: 'large'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('圆角与背景色'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyperAvatar(text: '设计', size: 'large', radius: 20),
            HyperAvatar(text: '品', size: 'large', radius: 16),
            HyperAvatar(
              text: 'A',
              size: 'large',
              backgroundColor: HyperUiColors.primary,
            ),
            HyperAvatar(
              text: 'B',
              size: 'large',
              backgroundColor: HyperUiColors.success,
            ),
          ],
        ),
      ],
    );
  }
}
// end-doc-region AvatarComponentExample

// doc-region BadgeComponentExample
class BadgeComponentExample extends StatelessWidget {
  const BadgeComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _StatusBadgeExample(),
      SizedBox(height: HyperUiSpacing.xl),
      _CountBadgeExample(),
      SizedBox(height: HyperUiSpacing.xl),
      _TagBadgeExample(),
    ],
  );
}

class _CountBadgeExample extends StatelessWidget {
  const _CountBadgeExample();

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('数字角标与最大值'),
        const Wrap(
          spacing: 26,
          runSpacing: 26,
          children: [
            HyperBadge(
              type: 'count',
              count: 8,
              child: HyperAvatar(text: '消息'),
            ),
            // 超过 max（默认 99）显示 99+。
            HyperBadge(
              type: 'count',
              count: 128,
              child: HyperIcon(LucideIcons.mail, size: 'large'),
            ),
            // showZero: 数字为 0 也显示。
            HyperBadge(
              type: 'count',
              count: 0,
              showZero: true,
              child: HyperIcon(LucideIcons.inbox, size: 'large'),
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('红点模式'),
        const Wrap(
          spacing: 26,
          runSpacing: 8,
          children: [
            HyperBadge(
              type: 'count',
              dot: true,
              child: HyperIcon(LucideIcons.bell, size: 'large'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadgeExample extends StatelessWidget {
  const _StatusBadgeExample();

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('弱化样式（subtle，默认）'),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyperBadge(label: '默认'),
            HyperBadge(
              label: '处理中',
              tone: HyperUiTone.info,
              icon: LucideIcons.refreshCw,
            ),
            HyperBadge(
              label: '已完成',
              tone: HyperUiTone.success,
              icon: LucideIcons.check,
            ),
            HyperBadge(label: '需注意', tone: HyperUiTone.warning),
            HyperBadge(label: '失败', tone: HyperUiTone.error),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('强调样式（subtle: false）'),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyperBadge(label: '默认', subtle: false),
            HyperBadge(label: '处理中', tone: HyperUiTone.info, subtle: false),
            HyperBadge(label: '失败', tone: HyperUiTone.error, subtle: false),
          ],
        ),
      ],
    );
  }
}

class _TagBadgeExample extends StatefulWidget {
  const _TagBadgeExample();

  @override
  State<_TagBadgeExample> createState() => _TagBadgeExampleState();
}

class _TagBadgeExampleState extends State<_TagBadgeExample> {
  bool _selected = true;
  bool _visible = true;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('可选择（点击切换选中态）'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyperBadge(
              type: 'tag',
              label: '可选标签',
              selected: _selected,
              icon: LucideIcons.sparkles,
              onTap: () => setState(() => _selected = !_selected),
            ),
            HyperBadge(
              type: 'tag',
              label: '设计',
              selected: !_selected,
              onTap: () => setState(() => _selected = !_selected),
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('语义色与图标'),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyperBadge(type: 'tag', label: '成功', tone: HyperUiTone.success),
            HyperBadge(type: 'tag', label: '警告', tone: HyperUiTone.warning),
            HyperBadge(
              type: 'tag',
              label: '错误',
              tone: HyperUiTone.error,
              icon: LucideIcons.circleAlert,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('可移除'),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            if (_visible)
              HyperBadge(
                type: 'tag',
                label: '可移除',
                onClose: () => setState(() => _visible = false),
              )
            else
              HyperBadge(
                type: 'tag',
                label: '恢复',
                icon: LucideIcons.rotateCcw,
                onTap: () => setState(() => _visible = true),
              ),
          ],
        ),
      ],
    );
  }
}
// end-doc-region BadgeComponentExample

// doc-region ToneComponentExample
class ToneComponentExample extends StatelessWidget {
  const ToneComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('五种语义状态'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final tone in HyperUiTone.values)
              HyperBadge(label: '语义色', tone: tone),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperText('HyperUiTone 跨组件复用：徽标、提示、通知等共用同一套语义色。', size: 'small'),
      ],
    );
  }
}
// end-doc-region ToneComponentExample
