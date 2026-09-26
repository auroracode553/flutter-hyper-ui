import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region TextComponentExample
class TextComponentExample extends StatelessWidget {
  const TextComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('文字层级'),
        const HySpace(
          alignment: CrossAxisAlignment.start,
          children: [
            HyText('Display 展示文字', variant: HyTextStyle.display),
            HyText('Title 页面标题', variant: HyTextStyle.title),
            HyText('Heading 小节标题', variant: HyTextStyle.heading),
            HyText('Body 正文用于清晰、连续的内容阅读。'),
            HyText('Caption 辅助说明', variant: HyTextStyle.caption),
            HyText('Hint 弱提示信息', variant: HyTextStyle.hint),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('颜色、字重与行数截断'),
        HyText('自定义颜色', color: HyUiColors.primary),
        const HyText('加粗正文', weight: FontWeight.w600),
        const HyText(
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('常用语义图标（带无障碍标签）'),
        const Wrap(
          spacing: 22,
          runSpacing: 22,
          children: [
            HyIcon(HyIcons.home, label: '首页'),
            HyIcon(HyIcons.search, label: '搜索'),
            HyIcon(HyIcons.cart, label: '购物袋'),
            HyIcon(HyIcons.settings, label: '设置'),
            HyIcon(HyIcons.profile, label: '个人中心'),
            HyIcon(HyIcons.success, label: '成功'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('尺寸与颜色'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyIcon(HyIcons.image, size: 18),
            HyIcon(HyIcons.image, size: 24),
            HyIcon(HyIcons.image, size: 32),
            HyIcon(HyIcons.warning, size: 28, color: HyUiColors.warning),
            HyIcon(HyIcons.success, size: 28, color: HyUiColors.success),
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('网络图片与点击预览'),
        HyImage.network(
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=900',
          height: 180,
          width: double.infinity,
          radius: 22,
          preview: true,
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('加载占位与失败兜底'),
        Row(
          children: [
            Expanded(
              // provider 直连时可用 placeholder / errorPlaceholder 定制状态。
              child: HyImage(
                provider: NetworkImage(
                  'https://images.unsplash.com/photo-1742666553489-3b34b0c8b77b?w=600',
                ),
                height: 110,
                radius: 16,
                placeholder: const Center(child: HyLoading()),
              ),
            ),
            SizedBox(width: HyUiSpacing.md),
            Expanded(
              child: HyImage(
                provider: NetworkImage('https://invalid.example/broken.png'),
                height: 110,
                radius: 16,
                errorPlaceholder: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.imageOff),
                    SizedBox(height: 4),
                    HyText('加载失败', variant: HyTextStyle.hint),
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
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
            HyAvatar(text: '林', size: 44),
            HyAvatar(text: 'HY', size: 56),
            HyAvatar(size: 56),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('圆角与背景色'),
        const Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            HyAvatar(text: '设计', size: 64, radius: 20),
            HyAvatar(text: '品', size: 56, radius: 16),
            HyAvatar(text: 'A', size: 56, backgroundColor: HyUiColors.primary),
            HyAvatar(text: 'B', size: 56, backgroundColor: HyUiColors.success),
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
      SizedBox(height: HyUiSpacing.xl),
      _CountBadgeExample(),
      SizedBox(height: HyUiSpacing.xl),
      _TagBadgeExample(),
    ],
  );
}

class _CountBadgeExample extends StatelessWidget {
  const _CountBadgeExample();

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
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
            HyBadge.count(count: 8, child: HyAvatar(text: '消息')),
            // 超过 max（默认 99）显示 99+。
            HyBadge.count(
              count: 128,
              child: HyIcon(LucideIcons.mail, size: 32),
            ),
            // showZero: 数字为 0 也显示。
            HyBadge.count(
              count: 0,
              showZero: true,
              child: HyIcon(LucideIcons.inbox, size: 32),
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('红点模式'),
        const Wrap(
          spacing: 26,
          runSpacing: 8,
          children: [
            HyBadge.count(
              dot: true,
              child: HyIcon(LucideIcons.bell, size: 32),
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
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
            HyBadge(label: '默认'),
            HyBadge(
              label: '处理中',
              tone: HyUiTone.info,
              icon: LucideIcons.refreshCw,
            ),
            HyBadge(
              label: '已完成',
              tone: HyUiTone.success,
              icon: LucideIcons.check,
            ),
            HyBadge(label: '需注意', tone: HyUiTone.warning),
            HyBadge(label: '失败', tone: HyUiTone.error),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('强调样式（subtle: false）'),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyBadge(label: '默认', subtle: false),
            HyBadge(label: '处理中', tone: HyUiTone.info, subtle: false),
            HyBadge(label: '失败', tone: HyUiTone.error, subtle: false),
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
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
            HyBadge.tag(
              label: '可选标签',
              selected: _selected,
              icon: LucideIcons.sparkles,
              onTap: () => setState(() => _selected = !_selected),
            ),
            HyBadge.tag(
              label: '设计',
              selected: !_selected,
              onTap: () => setState(() => _selected = !_selected),
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('语义色与图标'),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            HyBadge.tag(label: '成功', tone: HyUiTone.success),
            HyBadge.tag(label: '警告', tone: HyUiTone.warning),
            HyBadge.tag(
              label: '错误',
              tone: HyUiTone.error,
              icon: LucideIcons.circleAlert,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('可移除'),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            if (_visible)
              HyBadge.tag(
                label: '可移除',
                onClose: () => setState(() => _visible = false),
              )
            else
              HyBadge.tag(
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
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
            for (final tone in HyUiTone.values)
              HyBadge(label: '语义色', tone: tone),
          ],
        ),
        const SizedBox(height: HyUiSpacing.sm),
        const HyText(
          'HyUiTone 跨组件复用：徽标、提示、通知等共用同一套语义色。',
          variant: HyTextStyle.hint,
        ),
      ],
    );
  }
}
// end-doc-region ToneComponentExample
