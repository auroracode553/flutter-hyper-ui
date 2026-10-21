import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

import 'update_demo_controller.dart';

// doc-region UpdateDialogComponentExample
class UpdateDialogComponentExample extends StatefulWidget {
  const UpdateDialogComponentExample({super.key});

  @override
  State<UpdateDialogComponentExample> createState() =>
      _UpdateDialogComponentExampleState();
}

class _UpdateDialogComponentExampleState
    extends State<UpdateDialogComponentExample> {
  final _controller = UpdateDemoController();
  bool _mandatory = false;
  bool _dialogOpen = false;

  Future<void> _open({bool latest = false, bool fail = false}) async {
    if (_dialogOpen) return;
    // 关闭后重新打开已有下载，不重新检查、不创建第二个任务。
    if (!_controller.busy &&
        (latest ||
            fail ||
            _controller.status != HyperUpdateStatus.readyToInstall)) {
      _controller.check(latest: latest, fail: fail);
    }
    setState(() => _dialogOpen = true);
    try {
      await HyperUpdateDialog.show<void>(
        context,
        builder: (dialogContext) => ListenableBuilder(
          listenable: _controller,
          builder: (_, _) =>
              _dialog(onClose: () => Navigator.of(dialogContext).pop()),
        ),
      );
    } finally {
      if (mounted) setState(() => _dialogOpen = false);
    }
  }

  HyperUpdateDialog _dialog({VoidCallback? onClose}) => HyperUpdateDialog(
    status: _controller.status,
    currentVersion: _controller.currentVersion,
    release: UpdateDemoController.release,
    progress: _controller.installProgress,
    downloadProgress: _controller.status == HyperUpdateStatus.downloading
        ? _controller.downloadProgress
        : null,
    mandatory: _mandatory,
    onCheck: _controller.check,
    onDownload: _controller.download,
    onInstall: _controller.install,
    onRetry: _controller.retry,
    onCancel: () {
      _controller.cancel();
      if (_controller.status == HyperUpdateStatus.idle) onClose?.call();
    },
    onLater: onClose,
    onClose: onClose,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const HyperText('更新流程', size: 'small'),
        const SizedBox(height: HyperUiSpacing.xs),
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: <Widget>[
            HyperButton(
              label:
                  _controller.busy ||
                      _controller.status == HyperUpdateStatus.readyToInstall
                  ? '查看更新进度'
                  : '检查更新',
              onPressed: _dialogOpen ? null : _open,
              colorStyle: 'primary',
              type: 'filled',
            ),
            HyperButton(
              label: '已是最新',
              onPressed: _controller.busy || _dialogOpen
                  ? null
                  : () => _open(latest: true),
            ),
            HyperButton(
              label: '失败与重试',
              onPressed: _controller.busy || _dialogOpen
                  ? null
                  : () => _open(fail: true),
            ),
          ],
        ),
        if (_controller.status == HyperUpdateStatus.downloading) ...<Widget>[
          const SizedBox(height: HyperUiSpacing.sm),
          HyperProgress(value: _controller.downloadProgress.fraction),
          const SizedBox(height: HyperUiSpacing.xs),
          HyperText(_controller.downloadProgress.sizeLabel, size: 'small'),
        ],
        const SizedBox(height: HyperUiSpacing.lg),
        const HyperText('状态预览', size: 'small'),
        const HyperText(
          '检查中隐藏版本；其他版本信息不套卡片。标识块 40、图标 20、加载环 30；错误仅保留原因与操作，次操作使用默认描边按钮。',
          size: 'small',
        ),
        const SizedBox(height: HyperUiSpacing.xs),
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: <Widget>[
            for (final status in HyperUpdateStatus.values)
              HyperBadge(
                type: 'tag',
                label: _label(status),
                selected: _controller.status == status,
                onPressed: () => _controller.preview(status),
              ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperListTile(
          title: '强制更新',
          subtitle: '隐藏稍后与取消入口，安装完成后恢复关闭',
          trailing: HyperSwitch(
            value: _mandatory,
            onChanged: _controller.busy || _dialogOpen
                ? null
                : (value) => setState(() => _mandatory = value),
          ),
        ),
        HyperListTile(
          title: '总大小未知',
          subtitle: '保留下载量与速度，使用不定进度',
          trailing: HyperSwitch(
            value: _controller.unknownTotal,
            onChanged: _controller.setUnknownTotal,
          ),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        Align(alignment: Alignment.topCenter, child: _dialog()),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperText(
          '示例任务由页面持有。关闭弹窗后下载继续，重新打开可查看进度；取消按钮终止下载。',
          size: 'small',
        ),
      ],
    ),
  );

  String _label(HyperUpdateStatus status) => switch (status) {
    HyperUpdateStatus.idle => '待检查',
    HyperUpdateStatus.checking => '检查中',
    HyperUpdateStatus.available => '新版本',
    HyperUpdateStatus.upToDate => '已是最新',
    HyperUpdateStatus.downloadQueued => '系统排队',
    HyperUpdateStatus.downloading => '下载中',
    HyperUpdateStatus.readyToInstall => '待安装',
    HyperUpdateStatus.installing => '安装中',
    HyperUpdateStatus.completed => '已完成',
    HyperUpdateStatus.error => '失败',
  };
}
// end-doc-region UpdateDialogComponentExample
