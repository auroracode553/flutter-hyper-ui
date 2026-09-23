import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region TextComponentExample
class TextComponentExample extends StatelessWidget {
  const TextComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HySpace(
    alignment: CrossAxisAlignment.start,
    children: [
      HyText('Display 展示文字', variant: HyTextStyle.display),
      HyText('Title 页面标题', variant: HyTextStyle.title),
      HyText('Heading 小节标题', variant: HyTextStyle.heading),
      HyText('Body 正文用于清晰、连续的内容阅读。'),
      HyText('Caption 辅助说明', variant: HyTextStyle.caption),
      HyText('Hint 弱提示信息', variant: HyTextStyle.hint),
    ],
  );
}
// end-doc-region TextComponentExample

// doc-region IconComponentExample
class IconComponentExample extends StatelessWidget {
  const IconComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyWrap(
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
  );
}
// end-doc-region IconComponentExample

// doc-region ImageComponentExample
class ImageComponentExample extends StatelessWidget {
  const ImageComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyImage.network(
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=900',
    height: 190,
    width: double.infinity,
    radius: 22,
    preview: true,
  );
}
// end-doc-region ImageComponentExample

// doc-region AvatarComponentExample
class AvatarComponentExample extends StatelessWidget {
  const AvatarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyWrap(
    spacing: 18,
    children: [
      HyAvatar(text: '林', size: 44),
      HyAvatar(text: 'HY', size: 56),
      HyAvatar(text: '设计', size: 64, radius: 20),
      HyAvatar(size: 56),
    ],
  );
}
// end-doc-region AvatarComponentExample

// doc-region CountBadgeComponentExample
class CountBadgeComponentExample extends StatelessWidget {
  const CountBadgeComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyWrap(
    spacing: 26,
    children: [
      HyCountBadge(count: 8, child: HyAvatar(text: '消息')),
      HyCountBadge(count: 128, child: HyIcon(Icons.mail_outline_rounded, size: 32)),
      HyCountBadge(dot: true, child: HyIcon(Icons.notifications_outlined, size: 32)),
    ],
  );
}
// end-doc-region CountBadgeComponentExample

// doc-region BadgeComponentExample
class BadgeComponentExample extends StatelessWidget {
  const BadgeComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyWrap(
    children: [
      HyBadge(label: '默认'),
      HyBadge(label: '处理中', tone: HyUiTone.info, icon: Icons.sync_rounded),
      HyBadge(label: '已完成', tone: HyUiTone.success, icon: Icons.check_rounded),
      HyBadge(label: '需注意', tone: HyUiTone.warning),
      HyBadge(label: '失败', tone: HyUiTone.error, subtle: false),
    ],
  );
}
// end-doc-region BadgeComponentExample

// doc-region TagComponentExample
class TagComponentExample extends StatefulWidget {
  const TagComponentExample({super.key});

  @override
  State<TagComponentExample> createState() => _TagComponentExampleState();
}

class _TagComponentExampleState extends State<TagComponentExample> {
  bool _selected = true;
  bool _visible = true;

  @override
  Widget build(BuildContext context) => HyWrap(
    children: [
      HyTag(
        label: '可选择',
        selected: _selected,
        icon: Icons.auto_awesome_outlined,
        onTap: () => setState(() => _selected = !_selected),
      ),
      const HyTag(label: '成功', tone: HyUiTone.success),
      const HyTag(label: '警告', tone: HyUiTone.warning),
      if (_visible) HyTag(label: '可移除', onClose: () => setState(() => _visible = false)),
    ],
  );
}
// end-doc-region TagComponentExample

// doc-region ToneComponentExample
class ToneComponentExample extends StatelessWidget {
  const ToneComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyWrap(
    children: [
      for (final tone in HyUiTone.values) HyBadge(label: '语义色', tone: tone),
    ],
  );
}
// end-doc-region ToneComponentExample
