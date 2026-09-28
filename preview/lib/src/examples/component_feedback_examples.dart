import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region ToastComponentExample
class ToastComponentExample extends StatelessWidget {
  const ToastComponentExample({super.key});

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
        _label('语义色调'),
        Wrap(
          spacing: HyperUiSpacing.sm,
          runSpacing: HyperUiSpacing.sm,
          children: [
            HyperButton(
              type: 'tonal',
              label: '默认',
              onPressed: () => HyperToast.show(context, '已复制到剪贴板'),
            ),
            HyperButton(
              type: 'tonal',
              label: '成功',
              onPressed: () =>
                  HyperToast.show(context, '保存成功', type: 'success'),
            ),
            HyperButton(
              type: 'tonal',
              label: '警告',
              onPressed: () =>
                  HyperToast.show(context, '请检查输入内容', type: 'warning'),
            ),
            HyperButton(
              type: 'tonal',
              label: '错误',
              onPressed: () =>
                  HyperToast.show(context, '网络连接失败', type: 'error'),
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('操作按钮与时长'),
        HyperButton(
          type: 'tonal',
          label: '可撤销（4 秒）',
          onPressed: () => HyperToast.show(
            context,
            '已删除 3 个文件',
            type: 'warning',
            duration: const Duration(seconds: 4),
            actionLabel: '撤销',
            onAction: () => HyperToast.show(context, '已恢复删除', type: 'success'),
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
    final result = await HyperDrawer.show<String>(
      context,
      title: '选择工作空间',
      width: 320,
      builder: (drawerContext) => Column(
        children: [
          for (final label in const ['产品设计', '移动端', '文档站'])
            HyperListTile(
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
    await HyperDrawer.show<void>(
      context,
      title: '筛选条件',
      placement: HyperDrawerPlacement.start,
      width: 300,
      builder: (drawerContext) => Column(
        children: [
          HyperListTile(
            title: '仅显示收藏',
            trailing: HyperCheckbox(value: true, onChanged: (_) {}),
            onTap: () {},
          ),
          HyperListTile(
            title: '包含已归档',
            trailing: const HyperCheckbox(value: false, onChanged: null),
          ),
          HyperListTile(
            title: '全部时间',
            trailing: const HyperRadio<String>(
              value: 'all',
              groupValue: 'all',
              onChanged: null,
            ),
          ),
        ],
      ),
      footerBuilder: (footerContext) => HyperButton(
        label: '应用筛选',
        expanded: true,
        onPressed: () => Navigator.pop(footerContext),
      ),
    );
  }

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
        _label('右侧抽屉与返回值'),
        HyperButton(label: '打开抽屉', onPressed: _openEnd),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperText('返回结果：$_result', size: 'small'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('左侧抽屉与底部操作区'),
        HyperButton(type: 'tonal', label: '打开筛选抽屉', onPressed: _openStart),
      ],
    );
  }
}
// end-doc-region DrawerComponentExample

// doc-region SkeletonComponentExample
class SkeletonComponentExample extends StatelessWidget {
  const SkeletonComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('卡片骨架（card: true）'),
        const HyperSkeleton(type: 'card', rows: 3),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('列表骨架（rows: 2）'),
        const HyperSkeleton(rows: 2),
      ],
    );
  }
}
// end-doc-region SkeletonComponentExample

// doc-region DialogComponentExample
class DialogComponentExample extends StatelessWidget {
  const DialogComponentExample({super.key});

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
        _label('标准确认'),
        HyperButton(
          label: '保存确认',
          onPressed: () => HyperDialog.confirm(
            context,
            title: '保存本次修改？',
            message: '保存后，新的设置会立即在所有设备生效。',
            confirmLabel: '保存',
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('危险操作与自定义按钮'),
        HyperButton(
          type: 'tonal',
          label: '删除确认（danger）',
          onPressed: () => HyperDialog.confirm(
            context,
            title: '删除这个项目？',
            message: '删除后无法恢复，所有成员将失去访问权限。',
            confirmLabel: '删除',
            type: 'danger',
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('仅确认按钮与自定义正文'),
        HyperButton(
          type: 'tonal',
          label: '公告（showCancel: false）',
          onPressed: () => HyperDialog.confirm(
            context,
            title: '版本更新',
            // content 插槽可放任意组件，优先于 message。
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('本次更新内容：'),
                SizedBox(height: 8),
                Text('· 新增 HyperTextField 组件文档\n· 示例支持明暗主题切换'),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('局部加载'),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            HyperLoading(),
            SizedBox(width: HyperUiSpacing.md),
            HyperLoading(label: '同步中'),
            SizedBox(width: HyperUiSpacing.md),
            HyperLoading(label: '上传', size: 'large'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('全局任务遮罩'),
        HyperButton(
          type: 'tonal',
          label: '预览全局加载',
          onPressed: () => HyperLoading.during<void>(
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

// doc-region ActionSheetComponentExample
class ActionSheetComponentExample extends StatelessWidget {
  const ActionSheetComponentExample({super.key});

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
        _label('自定义内容'),
        HyperButton(
          type: 'tonal',
          label: '打开底部弹层',
          onPressed: () => HyperActionSheet.show<void>(
            context,
            title: '分享项目',
            builder: (sheetContext) => const Column(
              children: [
                HyperListTile(leadingIcon: LucideIcons.link, title: '复制链接'),
                HyperListTile(leadingIcon: LucideIcons.userPlus, title: '邀请成员'),
              ],
            ),
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('操作列表'),
        HyperButton(
          type: 'tonal',
          label: '打开操作菜单',
          onPressed: () => HyperActionSheet.choose<String>(
            context,
            title: '项目操作',
            actions: const [
              HyperAction(
                value: 'rename',
                label: '重命名',
                icon: LucideIcons.pencil,
              ),
              HyperAction(
                value: 'share',
                label: '分享',
                icon: LucideIcons.share2,
              ),
              HyperAction(
                value: 'move',
                label: '移动（无权限）',
                icon: LucideIcons.folderInput,
                enabled: false,
              ),
              HyperAction(
                value: 'delete',
                label: '删除',
                icon: LucideIcons.trash,
                type: 'danger',
              ),
            ],
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('强制操作（dismissible: false）'),
        HyperButton(
          type: 'tonal',
          label: '打开强制阅读弹层',
          onPressed: () => HyperActionSheet.show<void>(
            context,
            title: '服务条款',
            dismissible: false,
            builder: (sheetContext) => Column(
              children: [
                const Text('点击遮罩无法关闭，只能通过按钮确认。'),
                const SizedBox(height: HyperUiSpacing.md),
                HyperButton(
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
// end-doc-region ActionSheetComponentExample

// doc-region PopoverComponentExample
class PopoverComponentExample extends StatelessWidget {
  const PopoverComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyperPopover(
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
      HyperPopupMenu<String>(
        onSelected: (value) => setState(() => _selected = value),
        actions: const [
          HyperAction(value: '编辑', label: '编辑', icon: LucideIcons.pencil),
          HyperAction(value: '复制', label: '复制', icon: LucideIcons.copy),
          HyperAction(
            value: '删除',
            label: '删除',
            icon: LucideIcons.trash,
            type: 'danger',
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return HyperButton(
        type: 'ghost',
        label: '重新显示公告',
        onPressed: () => setState(() => _visible = true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('短公告（静止展示）'),
        const HyperNoticeBar(message: '暂不支持离线编辑。'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('长公告（自动滚动，可关闭）'),
        HyperNoticeBar(
          message: '组件文档已升级：每个组件现在都有独立、可交互的运行预览，支持明暗主题实时切换。',
          onClose: () => setState(() => _visible = false),
        ),
      ],
    );
  }
}
// end-doc-region NoticeBarComponentExample
