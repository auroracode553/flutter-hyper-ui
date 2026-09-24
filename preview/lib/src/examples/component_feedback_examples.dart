import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region ToastComponentExample
class ToastComponentExample extends StatelessWidget {
  const ToastComponentExample({super.key});

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
        _label('语义色调'),
        HyWrap(
          spacing: HyUiSpacing.sm,
          runSpacing: HyUiSpacing.sm,
          children: [
            HyButton.tonal(
              label: '默认',
              onPressed: () => HyToast.show(context, '已复制到剪贴板'),
            ),
            HyButton.tonal(
              label: '成功',
              onPressed: () =>
                  HyToast.show(context, '保存成功', tone: HyUiTone.success),
            ),
            HyButton.tonal(
              label: '警告',
              onPressed: () =>
                  HyToast.show(context, '请检查输入内容', tone: HyUiTone.warning),
            ),
            HyButton.tonal(
              label: '错误',
              onPressed: () =>
                  HyToast.show(context, '网络连接失败', tone: HyUiTone.error),
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('操作按钮与时长'),
        HyButton.tonal(
          label: '可撤销（4 秒）',
          onPressed: () => HyToast.show(
            context,
            '已删除 3 个文件',
            tone: HyUiTone.warning,
            duration: const Duration(seconds: 4),
            actionLabel: '撤销',
            onAction: () =>
                HyToast.show(context, '已恢复删除', tone: HyUiTone.success),
          ),
        ),
      ],
    );
  }
}
// end-doc-region ToastComponentExample

// doc-region DrawerComponentExample
class DrawerComponentExample extends StatefulWidget {
  const DrawerComponentExample({super.key});

  @override
  State<DrawerComponentExample> createState() => _DrawerComponentExampleState();
}

class _DrawerComponentExampleState extends State<DrawerComponentExample> {
  String _result = '尚未选择';

  /// 右侧抽屉：选择后通过 Navigator.pop 返回泛型结果。
  Future<void> _openEnd() async {
    final result = await HyDrawer.show<String>(
      context,
      title: '选择工作空间',
      width: 320,
      builder: (drawerContext) => Column(
        children: [
          for (final label in const ['产品设计', '移动端', '文档站'])
            HyListTile(
              title: label,
              showChevron: true,
              onTap: () => Navigator.pop(drawerContext, label),
            ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _result = result);
  }

  /// 左侧抽屉：placement 指定起始侧，footerBuilder 提供固定底部操作区。
  Future<void> _openStart() async {
    await HyDrawer.show<void>(
      context,
      title: '筛选条件',
      placement: HyDrawerPlacement.start,
      width: 300,
      builder: (drawerContext) => Column(
        children: [
          HyListTile(
            title: '仅显示收藏',
            trailing: HyCheckbox(value: true, onChanged: (_) {}),
            onTap: () {},
          ),
          HyListTile(
            title: '包含已归档',
            trailing: const HyCheckbox(value: false, onChanged: null),
          ),
          HyListTile(
            title: '全部时间',
            trailing: const HyRadio<String>(
              value: 'all',
              groupValue: 'all',
              onChanged: null,
            ),
          ),
        ],
      ),
      footerBuilder: (footerContext) => HyButton.filled(
        label: '应用筛选',
        expanded: true,
        onPressed: () => Navigator.pop(footerContext),
      ),
    );
  }

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
        _label('右侧抽屉与返回值'),
        HyButton.filled(label: '打开抽屉', onPressed: _openEnd),
        const SizedBox(height: HyUiSpacing.sm),
        HyText('返回结果：$_result', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.lg),

        _label('左侧抽屉与底部操作区'),
        HyButton.tonal(label: '打开筛选抽屉', onPressed: _openStart),
      ],
    );
  }
}
// end-doc-region DrawerComponentExample

// doc-region SkeletonComponentExample
class SkeletonComponentExample extends StatelessWidget {
  const SkeletonComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('卡片骨架（card: true）'),
        const HySkeleton(card: true, rows: 3),
        const SizedBox(height: HyUiSpacing.lg),

        _label('列表骨架（rows: 2）'),
        const HySkeleton(rows: 2),
      ],
    );
  }
}
// end-doc-region SkeletonComponentExample

// doc-region DialogComponentExample
class DialogComponentExample extends StatelessWidget {
  const DialogComponentExample({super.key});

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
        _label('标准确认'),
        HyButton.filled(
          label: '保存确认',
          onPressed: () => HyDialog.confirm(
            context,
            title: '保存本次修改？',
            message: '保存后，新的设置会立即在所有设备生效。',
            confirmLabel: '保存',
          ),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('危险操作与自定义按钮'),
        HyButton.tonal(
          label: '删除确认（dangerous）',
          onPressed: () => HyDialog.confirm(
            context,
            title: '删除这个项目？',
            message: '删除后无法恢复，所有成员将失去访问权限。',
            confirmLabel: '删除',
            dangerous: true,
          ),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('仅确认按钮与自定义正文'),
        HyButton.tonal(
          label: '公告（showCancel: false）',
          onPressed: () => HyDialog.confirm(
            context,
            title: '版本更新',
            // content 插槽可放任意组件，优先于 message。
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('本次更新内容：'),
                SizedBox(height: 8),
                Text('· 新增 HyTextField 组件文档\n· 示例支持明暗主题切换'),
              ],
            ),
            confirmLabel: '知道了',
            showCancel: false,
          ),
        ),
      ],
    );
  }
}
// end-doc-region DialogComponentExample

// doc-region LoadingComponentExample
class LoadingComponentExample extends StatelessWidget {
  const LoadingComponentExample({super.key});

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
        _label('局部加载'),
        HySpace(
          direction: Axis.horizontal,
          alignment: CrossAxisAlignment.center,
          children: const [
            HyLoading(),
            SizedBox(width: HyUiSpacing.md),
            HyLoading(label: '同步中'),
            SizedBox(width: HyUiSpacing.md),
            HyLoading(label: '上传', size: 32),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('全局任务遮罩'),
        HyButton.tonal(
          label: '预览全局加载',
          onPressed: () => HyLoading.during<void>(
            context,
            () => Future<void>.delayed(const Duration(milliseconds: 900)),
            label: '正在保存',
          ),
        ),
      ],
    );
  }
}
// end-doc-region LoadingComponentExample

// doc-region AlertComponentExample
class AlertComponentExample extends StatefulWidget {
  const AlertComponentExample({super.key});

  @override
  State<AlertComponentExample> createState() => _AlertComponentExampleState();
}

class _AlertComponentExampleState extends State<AlertComponentExample> {
  bool _dismissibleVisible = true;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('语义色调（带标题）'),
        const HyAlert(
          title: '信息',
          message: '新的组件示例已经准备完成。',
          tone: HyUiTone.info,
        ),
        const SizedBox(height: HyUiSpacing.sm),
        const HyAlert(
          title: '成功',
          message: '配置已同步到所有设备。',
          tone: HyUiTone.success,
        ),
        const SizedBox(height: HyUiSpacing.sm),
        const HyAlert(
          title: '警告',
          message: '存储空间即将用完。',
          tone: HyUiTone.warning,
        ),
        const SizedBox(height: HyUiSpacing.sm),
        const HyAlert(title: '错误', message: '无法连接到同步服务。', tone: HyUiTone.error),
        const SizedBox(height: HyUiSpacing.lg),

        _label('无标题与可关闭'),
        if (_dismissibleVisible)
          HyAlert(
            message: '点击右侧关闭按钮可以移除这条通知。',
            tone: HyUiTone.info,
            onClose: () => setState(() => _dismissibleVisible = false),
          )
        else
          HyButton.ghost(
            label: '重新显示通知',
            onPressed: () => setState(() => _dismissibleVisible = true),
          ),
      ],
    );
  }
}
// end-doc-region AlertComponentExample

// doc-region BottomSheetComponentExample
class BottomSheetComponentExample extends StatelessWidget {
  const BottomSheetComponentExample({super.key});

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
        _label('基础弹层（点遮罩关闭）'),
        HyButton.tonal(
          label: '打开底部弹层',
          onPressed: () => HyBottomSheet.show<void>(
            context,
            title: '分享项目',
            builder: (sheetContext) => const Column(
              children: [
                HyListTile(
                  leadingIcon: Icons.link_rounded,
                  title: '复制链接',
                ),
                HyListTile(
                  leadingIcon: Icons.person_add_alt_1_outlined,
                  title: '邀请成员',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('强制操作（dismissible: false）'),
        HyButton.tonal(
          label: '打开强制阅读弹层',
          onPressed: () => HyBottomSheet.show<void>(
            context,
            title: '服务条款',
            dismissible: false,
            builder: (sheetContext) => Column(
              children: [
                const Text('点击遮罩无法关闭，只能通过按钮确认。'),
                const SizedBox(height: HyUiSpacing.md),
                HyButton.filled(
                  label: '同意并继续',
                  expanded: true,
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// end-doc-region BottomSheetComponentExample

// doc-region ActionSheetComponentExample
class ActionSheetComponentExample extends StatelessWidget {
  const ActionSheetComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyButton.tonal(
    label: '打开操作菜单',
    onPressed: () => HyActionSheet.show<String>(
      context,
      title: '项目操作',
      actions: const [
        HyAction(value: 'rename', label: '重命名', icon: Icons.edit_outlined),
        HyAction(value: 'share', label: '分享', icon: Icons.ios_share_outlined),
        // 禁用项：仅展示，不可点击。
        HyAction(
          value: 'move',
          label: '移动（无权限）',
          icon: Icons.drive_file_move_outlined,
          enabled: false,
        ),
        HyAction(
          value: 'delete',
          label: '删除',
          icon: Icons.delete_outline_rounded,
          destructive: true,
        ),
      ],
    ),
  );
}
// end-doc-region ActionSheetComponentExample

// doc-region PopoverComponentExample
class PopoverComponentExample extends StatelessWidget {
  const PopoverComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyPopover(
    content: Text('Popover 保持页面上下文，适合展示简短补充说明。'),
    child: Text('点击查看说明'),
  );
}
// end-doc-region PopoverComponentExample

// doc-region PopupMenuComponentExample
class PopupMenuComponentExample extends StatefulWidget {
  const PopupMenuComponentExample({super.key});

  @override
  State<PopupMenuComponentExample> createState() =>
      _PopupMenuComponentExampleState();
}

class _PopupMenuComponentExampleState extends State<PopupMenuComponentExample> {
  String _selected = '尚未选择';

  @override
  Widget build(BuildContext context) => Row(
    children: [
      HyPopupMenu<String>(
        onSelected: (value) => setState(() => _selected = value),
        actions: const [
          HyAction(value: '编辑', label: '编辑', icon: Icons.edit_outlined),
          HyAction(value: '复制', label: '复制', icon: Icons.copy_rounded),
          HyAction(
            value: '删除',
            label: '删除',
            icon: Icons.delete_outline_rounded,
            destructive: true,
          ),
        ],
      ),
      Text('选择结果：$_selected'),
    ],
  );
}
// end-doc-region PopupMenuComponentExample

// doc-region NoticeBarComponentExample
class NoticeBarComponentExample extends StatefulWidget {
  const NoticeBarComponentExample({super.key});

  @override
  State<NoticeBarComponentExample> createState() =>
      _NoticeBarComponentExampleState();
}

class _NoticeBarComponentExampleState extends State<NoticeBarComponentExample> {
  bool _visible = true;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return HyButton.ghost(
        label: '重新显示公告',
        onPressed: () => setState(() => _visible = true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('短公告（静止展示）'),
        const HyNoticeBar(message: '暂不支持离线编辑。'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('长公告（自动滚动，可关闭）'),
        HyNoticeBar(
          message: '组件文档已升级：每个组件现在都有独立、可交互的运行预览，支持明暗主题实时切换。',
          onClose: () => setState(() => _visible = false),
        ),
      ],
    );
  }
}
// end-doc-region NoticeBarComponentExample
