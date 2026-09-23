import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region ToastComponentExample
class ToastComponentExample extends StatelessWidget {
  const ToastComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton(
          onPressed: () => HyToast.show(
            context,
            '保存成功',
            tone: HyUiTone.success,
          ),
          child: const Text('成功提示'),
        ),
        FilledButton.tonal(
          onPressed: () => HyToast.show(
            context,
            '请检查输入内容',
            tone: HyUiTone.warning,
          ),
          child: const Text('警告提示'),
        ),
        OutlinedButton(
          onPressed: () => HyToast.show(
            context,
            '操作失败',
            tone: HyUiTone.error,
            actionLabel: '重试',
            onAction: () {},
          ),
          child: const Text('错误与操作'),
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
  State<DrawerComponentExample> createState() =>
      _DrawerComponentExampleState();
}

class _DrawerComponentExampleState extends State<DrawerComponentExample> {
  String _result = '尚未选择';

  Future<void> _open() async {
    final result = await HyDrawer.show<String>(
      context,
      title: '选择工作空间',
      width: 320,
      builder: (drawerContext) => Column(
        children: [
          for (final label in const ['产品设计', '移动端', '文档站'])
            ListTile(
              title: Text(label),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.pop(drawerContext, label),
            ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(onPressed: _open, child: const Text('打开抽屉')),
        const SizedBox(height: 16),
        Text('返回结果：$_result'),
      ],
    );
  }
}
// end-doc-region DrawerComponentExample

// doc-region SkeletonComponentExample
class SkeletonComponentExample extends StatelessWidget {
  const SkeletonComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const HySkeleton(card: true, rows: 3);
  }
}
// end-doc-region SkeletonComponentExample

// doc-region DialogComponentExample
class DialogComponentExample extends StatelessWidget {
  const DialogComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyButton.filled(
    label: '打开确认对话框',
    icon: Icons.open_in_new_rounded,
    onPressed: () => HyDialog.confirm(
      context,
      title: '保存本次修改？',
      message: '保存后，新的设置会立即在所有设备生效。',
      confirmLabel: '保存',
    ),
  );
}
// end-doc-region DialogComponentExample

// doc-region LoadingComponentExample
class LoadingComponentExample extends StatelessWidget {
  const LoadingComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HySpace(
    direction: Axis.horizontal,
    children: [
      const HyLoading(label: '同步中'),
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
// end-doc-region LoadingComponentExample

// doc-region AlertComponentExample
class AlertComponentExample extends StatefulWidget {
  const AlertComponentExample({super.key});

  @override
  State<AlertComponentExample> createState() => _AlertComponentExampleState();
}

class _AlertComponentExampleState extends State<AlertComponentExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) => _visible
      ? HyAlert(
          title: '版本已更新',
          message: '新的组件示例已经准备完成。',
          tone: HyUiTone.info,
          onClose: () => setState(() => _visible = false),
        )
      : HyButton.ghost(label: '重新显示通知', onPressed: () => setState(() => _visible = true));
}
// end-doc-region AlertComponentExample

// doc-region BottomSheetComponentExample
class BottomSheetComponentExample extends StatelessWidget {
  const BottomSheetComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyButton.tonal(
    label: '打开底部弹层',
    onPressed: () => HyBottomSheet.show<void>(
      context,
      title: '分享项目',
      builder: (sheetContext) => const Column(
        children: [
          ListTile(leading: Icon(Icons.link_rounded), title: Text('复制链接')),
          ListTile(leading: Icon(Icons.person_add_alt_1_outlined), title: Text('邀请成员')),
        ],
      ),
    ),
  );
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
        HyAction(value: 'delete', label: '删除', icon: Icons.delete_outline_rounded, destructive: true),
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
  State<PopupMenuComponentExample> createState() => _PopupMenuComponentExampleState();
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
          HyAction(value: '删除', label: '删除', icon: Icons.delete_outline_rounded, destructive: true),
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
  State<NoticeBarComponentExample> createState() => _NoticeBarComponentExampleState();
}

class _NoticeBarComponentExampleState extends State<NoticeBarComponentExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) => _visible
      ? HyNoticeBar(
          message: '组件文档已升级：每个组件现在都有独立、可交互的运行预览。',
          onClose: () => setState(() => _visible = false),
        )
      : HyButton.ghost(label: '重新显示公告', onPressed: () => setState(() => _visible = true));
}
// end-doc-region NoticeBarComponentExample
