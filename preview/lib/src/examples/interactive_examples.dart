import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});
  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}
class _OverlayExampleState extends State<OverlayExample> {
  bool _alert = true;
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('恰到好处的回应', variant: HyTextStyle.title),
    if (_alert) HyAlert(title: '一切准备就绪', message: '柔光主题已启用。', tone: HyUiTone.success,
      onClose: () => setState(() => _alert = false)),
    const HyAlert(message: '部分内容尚未保存。', tone: HyUiTone.warning),
    const HyAlert(message: '连接失败，请稍后重试。', tone: HyUiTone.error),
    HyCard(title: '轻提示', child: HyWrap(children: [
      for (final tone in [HyUiTone.neutral, HyUiTone.success, HyUiTone.error])
        HyButton.tonal(label: tone == HyUiTone.success ? '成功' : tone == HyUiTone.error ? '失败' : '普通',
          onPressed: () => HyToast.show(context, '这是一条${tone == HyUiTone.success ? '成功' : tone == HyUiTone.error ? '失败' : '普通'}提示', tone: tone)),
    ])),
    HyCard(title: '弹层与操作', child: HyWrap(children: [
      HyButton.tonal(label: '确认弹窗', onPressed: () async {
        final result = await HyDialog.confirm(context, title: '保存更改？', message: '新的偏好将立即生效。');
        if (context.mounted && result == true) HyToast.show(context, '已保存');
      }),
      HyButton.tonal(label: '提示弹窗', onPressed: () => HyDialog.confirm(context,
        title: '更新完成', message: '你正在使用最新版本。', showCancel: false)),
      HyButton.tonal(label: '自定义底部弹窗', onPressed: () => HyBottomSheet.show<void>(context,
        title: '本周灵感', builder: (_) => const HySpace(children: [
          HyText('把复杂留给系统。', variant: HyTextStyle.title), HyText('让界面回归轻盈与自然。'),
          HySkeleton(rows: 2),
        ]))),
      HyButton.tonal(label: '操作菜单', onPressed: () async {
        final result = await HyActionSheet.show(context, title: '照片操作', actions: const [
          HyAction(value: '收藏', label: '收藏', icon: Icons.favorite_border),
          HyAction(value: '删除', label: '删除', icon: Icons.delete_outline, destructive: true)]);
        if (context.mounted && result != null) HyToast.show(context, '选择：$result');
      }),
      HyButton.tonal(label: '全局加载', onPressed: () async {
        await HyLoading.during(context, () => Future<void>.delayed(const Duration(seconds: 2)));
        if (context.mounted) HyToast.show(context, '加载完成');
      }),
      const HyPopover(child: Text('气泡说明'), content: Text('玻璃浮层承载补充信息，点击外部即可关闭。')),
      HyPopupMenu(actions: const [HyAction(value: '编辑', label: '编辑'), HyAction(value: '分享', label: '分享')],
        onSelected: (value) => HyToast.show(context, value)),
    ])),
    const HyCard(title: '局部加载', child: Center(child: HyLoading(label: '正在同步'))),
  ]);
}

class BusinessExample extends StatefulWidget {
  const BusinessExample({super.key});
  @override
  State<BusinessExample> createState() => _BusinessExampleState();
}
class _BusinessExampleState extends State<BusinessExample> {
  DateTime _deadline = DateTime.now().add(const Duration(seconds: 60));
  String _query = '';
  bool _notice = true, _notifications = true;
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('日常，由细节组成', variant: HyTextStyle.title),
    HySearchBar(onChanged: (value) => setState(() => _query = value)),
    if (_query.isNotEmpty) Text('正在搜索：$_query'),
    if (_notice) HyNoticeBar(message: '欢迎体验 Hy UI 柔光玻璃组件库。所有组件共享主题、间距与视觉规范，让每一页都自然一致。',
      onClose: () => setState(() => _notice = false)),
    HyCard(title: '验证码倒计时', child: HySpace(direction: Axis.horizontal, children: [
      HyCountDown(endTime: _deadline), HyButton.tonal(label: '重新计时',
        onPressed: () => setState(() => _deadline = DateTime.now().add(const Duration(seconds: 60)))),
    ])),
    HyMenuGroup(title: '偏好设置', subtitle: '参考设置页的分组卡片与图标层次', children: [
      HyListTile(grouped: true, title: '外观与显示', subtitle: '柔光 · 跟随系统',
        leadingIcon: Icons.palette_outlined, leadingColor: const Color(0xFF8C79CF),
        onTap: () => HyToast.show(context, '可在页面顶部切换明暗主题')),
      HyListTile(grouped: true, title: '消息通知', leadingIcon: Icons.notifications_outlined,
        leadingColor: const Color(0xFFE1A14D), trailing: HySwitch(value: _notifications,
          onChanged: (value) => setState(() => _notifications = value))),
      HyListTile(grouped: true, title: '隐私与安全', leadingIcon: Icons.shield_outlined,
        leadingColor: const Color(0xFF69A894), onTap: () => HyDialog.confirm(context,
          title: '隐私与安全', message: '此处由业务应用接入安全设置。', showCancel: false)),
    ]),
    const HyCollapse(title: '什么是柔光玻璃？', child: Text('通过低饱和背景、透明材质、细腻高光和柔和阴影建立空间层次。')),
    const HyCard(title: '订单时间轴', child: HyTimeline(items: [
      HyTimelineItem(title: '已送达', description: '包裹已安全送达', time: '今天 14:32'),
      HyTimelineItem(title: '正在配送', time: '今天 09:18'),
      HyTimelineItem(title: '订单已发货', time: '昨天 18:40'),
    ])),
  ]);
}

class ListInteractionExample extends StatefulWidget {
  const ListInteractionExample({super.key});
  @override
  State<ListInteractionExample> createState() => _ListInteractionExampleState();
}
class _ListInteractionExampleState extends State<ListInteractionExample> {
  int _count = 12, _generation = 0;
  bool _failNext = false;
  Future<void> _load() async {
    final generation = _generation;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted || generation != _generation) return;
    if (_failNext) { setState(() => _failNext = false); throw StateError('示例加载失败'); }
    setState(() => _count += 6);
  }
  @override
  Widget build(BuildContext context) => HyCard(title: '下拉刷新 / 分页 / 吸顶', child: HySpace(
    alignment: CrossAxisAlignment.stretch, children: [
      HyButton.ghost(label: _failNext ? '下次请求将展示失败重试' : '模拟下次加载失败',
        onPressed: () => setState(() => _failNext = true)),
      SizedBox(height: 360, child: HyLoadMore(hasMore: _count < 30, onLoadMore: _load,
        child: HyPullRefresh(onRefresh: () async {
          _generation++;
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (mounted) setState(() => _count = 12);
        }, child: CustomScrollView(physics: const AlwaysScrollableScrollPhysics(), slivers: [
          const HySticky(child: Padding(padding: EdgeInsets.all(16), child: Text('最近动态 · 吸顶标题'))),
          SliverList(delegate: SliverChildBuilderDelegate((context, index) => HyListTile(
            grouped: true, title: '动态 ${index + 1}', subtitle: '向下滚动加载更多',
            leading: HyAvatar(text: '${index + 1}'), onTap: () => HyToast.show(context, '动态 ${index + 1}')),
            childCount: _count)),
        ])))),
    ]));
}
