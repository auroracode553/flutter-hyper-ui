import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TextComponentExample
class TextComponentExample extends StatelessWidget {
  const TextComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('文字层级'),
        const Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HyperText('Display 展示文字', type: 'h1'),
            HyperText('Title 页面标题', type: 'h2'),
            HyperText('Heading 小节标题', type: 'h3'),
            HyperText('Body 正文用于清晰、连续的内容阅读。'),
            HyperText('Caption 辅助说明', type: 'h5'),
            HyperText('Hint 弱提示信息', type: 'h6'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('颜色、字重与行数截断'),
        HyperText('自定义颜色', color: HyperUiColors.primary),
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
    child: HyperText(text, type: 'h5'),
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
            HyperIcon(HyperIcons.image, size: 18),
            HyperIcon(HyperIcons.image, size: 24),
            HyperIcon(HyperIcons.image, size: 32),
            HyperIcon(HyperIcons.warning, size: 28, color: HyperUiColors.warning),
            HyperIcon(HyperIcons.success, size: 28, color: HyperUiColors.success),
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
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('网络图片与点击预览'),
        HyperImage.network(
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
                    HyperText('加载失败', type: 'h6'),
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
    child: HyperText(text, type: 'h5'),
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
            HyperAvatar(text: '林', size: 44),
            HyperAvatar(text: 'UI', size: 56),
            HyperAvatar(size: 56),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('圆角与背景色'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyperAvatar(text: '设计', size: 64, radius: 20),
            HyperAvatar(text: '品', size: 56, radius: 16),
            HyperAvatar(text: 'A', size: 56, backgroundColor: HyperUiColors.primary),
            HyperAvatar(text: 'B', size: 56, backgroundColor: HyperUiColors.success),
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
    child: HyperText(text, type: 'h5'),
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
            HyperBadge.count(count: 8, child: HyperAvatar(text: '消息')),
            // 超过 max（默认 99）显示 99+。
            HyperBadge.count(
              count: 128,
              child: HyperIcon(LucideIcons.mail, size: 32),
            ),
            // showZero: 数字为 0 也显示。
            HyperBadge.count(
              count: 0,
              showZero: true,
              child: HyperIcon(LucideIcons.inbox, size: 32),
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('红点模式'),
        const Wrap(
          spacing: 26,
          runSpacing: 8,
          children: [
            HyperBadge.count(dot: true, child: HyperIcon(LucideIcons.bell, size: 32)),
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
    child: HyperText(text, type: 'h5'),
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
    child: HyperText(text, type: 'h5'),
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
            HyperBadge.tag(
              label: '可选标签',
              selected: _selected,
              icon: LucideIcons.sparkles,
              onTap: () => setState(() => _selected = !_selected),
            ),
            HyperBadge.tag(
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
            HyperBadge.tag(label: '成功', tone: HyperUiTone.success),
            HyperBadge.tag(label: '警告', tone: HyperUiTone.warning),
            HyperBadge.tag(
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
              HyperBadge.tag(
                label: '可移除',
                onClose: () => setState(() => _visible = false),
              )
            else
              HyperBadge.tag(
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
    child: HyperText(text, type: 'h5'),
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
        const HyperText('HyperUiTone 跨组件复用：徽标、提示、通知等共用同一套语义色。', type: 'h6'),
      ],
    );
  }
}
// end-doc-region ToneComponentExample
