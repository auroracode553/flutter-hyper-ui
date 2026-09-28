import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});
  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('恰到好处的回应', size: 'large'),
      HyperCard(
        title: '轻提示',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tone in [
              HyperUiTone.neutral,
              HyperUiTone.success,
              HyperUiTone.error,
            ])
              HyperButton.tonal(
                label: tone == HyperUiTone.success
                    ? '成功'
                    : tone == HyperUiTone.error
                    ? '失败'
                    : '普通',
                onPressed: () => HyperToast.show(
                  context,
                  '这是一条${tone == HyperUiTone.success
                      ? '成功'
                      : tone == HyperUiTone.error
                      ? '失败'
                      : '普通'}提示',
                  tone: tone,
                ),
              ),
          ],
        ),
      ),
      HyperCard(
        title: '弹层与操作',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            HyperButton.tonal(
              label: '确认弹窗',
              onPressed: () async {
                final result = await HyperDialog.confirm(
                  context,
                  title: '保存更改？',
                  message: '新的偏好将立即生效。',
                );
                if (context.mounted && result == true) {
                  HyperToast.show(context, '已保存');
                }
              },
            ),
            HyperButton.tonal(
              label: '提示弹窗',
              onPressed: () => HyperDialog.confirm(
                context,
                title: '更新完成',
                message: '你正在使用最新版本。',
                showCancel: false,
              ),
            ),
            HyperButton.tonal(
              label: '自定义底部弹窗',
              onPressed: () => HyperActionSheet.show<void>(
                context,
                title: '本周灵感',
                builder: (_) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    HyperText('把复杂留给系统。', size: 'large'),
                    HyperText('让界面回归轻盈与自然。'),
                    HyperSkeleton(rows: 2),
                  ],
                ),
              ),
            ),
            HyperButton.tonal(
              label: '操作菜单',
              onPressed: () async {
                final result = await HyperActionSheet.choose(
                  context,
                  title: '照片操作',
                  actions: const [
                    HyperAction(
                      value: '收藏',
                      label: '收藏',
                      icon: LucideIcons.heart,
                    ),
                    HyperAction(
                      value: '删除',
                      label: '删除',
                      icon: LucideIcons.trash,
                      destructive: true,
                    ),
                  ],
                );
                if (context.mounted && result != null) {
                  HyperToast.show(context, '选择：$result');
                }
              },
            ),
            HyperButton.tonal(
              label: '全局加载',
              onPressed: () async {
                await HyperLoading.during(
                  context,
                  () => Future<void>.delayed(const Duration(seconds: 2)),
                );
                if (context.mounted) HyperToast.show(context, '加载完成');
              },
            ),
            const HyperPopover(
              content: Text('玻璃浮层承载补充信息，点击外部即可关闭。'),
              child: Text('气泡说明'),
            ),
            HyperPopupMenu(
              actions: const [
                HyperAction(value: '编辑', label: '编辑'),
                HyperAction(value: '分享', label: '分享'),
              ],
              onSelected: (value) => HyperToast.show(context, value),
            ),
          ],
        ),
      ),
      const HyperCard(
        title: '局部加载',
        child: Center(child: HyperLoading(label: '正在同步')),
      ),
    ],
  );
}

class BusinessExample extends StatefulWidget {
  const BusinessExample({super.key});
  @override
  State<BusinessExample> createState() => _BusinessExampleState();
}

class _BusinessExampleState extends State<BusinessExample> {
  String _query = '';
  bool _notice = true, _notifications = true;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('日常，由细节组成', size: 'large'),
      HyperTextField(
        type: 'search',
        prefix: const Icon(LucideIcons.search),
        hintText: '搜索',
        onChanged: (value) => setState(() => _query = value),
      ),
      if (_query.isNotEmpty) Text('正在搜索：$_query'),
      if (_notice)
        HyperNoticeBar(
          message: '欢迎体验 Hyper UI 柔光玻璃组件库。所有组件共享主题、间距与视觉规范，让每一页都自然一致。',
          onClose: () => setState(() => _notice = false),
        ),
      HyperMenuGroup(
        title: '偏好设置',
        subtitle: '参考设置页的分组卡片与图标层次',
        children: [
          HyperListTile(
            title: '外观与显示',
            subtitle: '柔光 · 跟随系统',
            leadingIcon: LucideIcons.palette,
            leadingColor: const Color(0xFF8C79CF),
            onTap: () => HyperToast.show(context, '可在页面顶部切换明暗主题'),
          ),
          HyperListTile(
            title: '消息通知',
            leadingIcon: LucideIcons.bell,
            leadingColor: const Color(0xFFE1A14D),
            trailing: HyperSwitch(
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
            ),
          ),
          HyperListTile(
            title: '隐私与安全',
            leadingIcon: LucideIcons.shield,
            leadingColor: const Color(0xFF69A894),
            onTap: () => HyperDialog.confirm(
              context,
              title: '隐私与安全',
              message: '此处由业务应用接入安全设置。',
              showCancel: false,
            ),
          ),
        ],
      ),
      const HyperCollapse(
        title: '什么是柔光玻璃？',
        child: Text('通过低饱和背景、透明材质、细腻高光和柔和阴影建立空间层次。'),
      ),
      const HyperCard(
        title: '订单时间轴',
        child: HyperTimeline(
          items: [
            HyperTimelineItem(
              title: '已送达',
              description: '包裹已安全送达',
              time: '今天 14:32',
            ),
            HyperTimelineItem(title: '正在配送', time: '今天 09:18'),
            HyperTimelineItem(title: '订单已发货', time: '昨天 18:40'),
          ],
        ),
      ),
    ],
  );
}
