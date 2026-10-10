import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_context.dart';
import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_spacing.dart';
import '../utils/hyper_progress_value.dart';
import 'hyper_badge.dart';
import 'hyper_button.dart';
import 'hyper_glass.dart';
import 'hyper_layout.dart';
import 'hyper_modal.dart';
import 'hyper_navigation.dart';
import 'hyper_progress_painters.dart';
import 'hyper_tone.dart';
import 'hyper_update_models.dart';

// 私有内容视图通过明确入参复用版本、日志和进度的布局。
part 'hyper_update_dialog_content.dart';

/// 受控的更新对话框；回调只通知业务层，不自动检查或安装更新。
class HyperUpdateDialog extends StatelessWidget {
  const HyperUpdateDialog({
    super.key,
    this.status = HyperUpdateStatus.idle,
    this.currentVersion,
    this.release,
    this.progress,
    this.downloadProgress,
    this.progressText,
    this.title,
    this.message,
    this.mandatory = false,
    this.primaryLabel,
    this.secondaryLabel,
    this.onCheck,
    this.onUpdate,
    this.onInstall,
    this.onRetry,
    this.onCancel,
    this.onLater,
    this.onClose,
    this.maxWidth = 420,
  }) : assert(maxWidth > 0 && maxWidth < double.infinity);

  final HyperUpdateStatus status;
  final String? currentVersion;
  final HyperUpdateRelease? release;

  /// 下载或安装进度：0–1；null 为不定进度，有限的越界值会被收敛。
  final double? progress;

  /// 下载阶段优先使用字节快照；安装阶段继续使用 [progress]。
  final HyperUpdateDownloadProgress? downloadProgress;

  /// 业务提供的下载量、速度或安装阶段文字。
  final String? progressText;
  final String? title;
  final String? message;
  final bool mandatory;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onCheck;
  final VoidCallback? onUpdate;
  final VoidCallback? onInstall;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final VoidCallback? onLater;
  final VoidCallback? onClose;
  final double maxWidth;

  /// 打开弹层。builder 可返回 StatefulWidget 或 ValueListenableBuilder，
  /// 让业务状态在同一弹层内更新；关闭由回调中的 Navigator.pop 完成。
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) => showHyperModal<T>(
    context,
    dismissible: false,
    builder: (dialogContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          HyperUiSpacing.lg,
          HyperUiSpacing.lg,
          HyperUiSpacing.lg,
          HyperUiSpacing.lg + MediaQuery.viewInsetsOf(dialogContext).bottom,
        ),
        child: Builder(builder: builder),
      ),
    ),
  );

  bool get _locked =>
      status == HyperUpdateStatus.installing ||
      (mandatory &&
          status != HyperUpdateStatus.completed &&
          status != HyperUpdateStatus.upToDate);

  bool get _busy =>
      status == HyperUpdateStatus.checking ||
      status == HyperUpdateStatus.downloading ||
      status == HyperUpdateStatus.installing;

  bool get _hasProgress =>
      status == HyperUpdateStatus.downloading ||
      status == HyperUpdateStatus.installing;

  bool get _showRelease =>
      release != null &&
      status != HyperUpdateStatus.idle &&
      status != HyperUpdateStatus.checking &&
      status != HyperUpdateStatus.upToDate;

  HyperUiTone get _tone => switch (status) {
    HyperUpdateStatus.upToDate ||
    HyperUpdateStatus.completed => HyperUiTone.success,
    HyperUpdateStatus.error => HyperUiTone.error,
    _ => HyperUiTone.primary,
  };

  IconData get _icon => switch (status) {
    HyperUpdateStatus.idle ||
    HyperUpdateStatus.checking => LucideIcons.refreshCw,
    HyperUpdateStatus.available => LucideIcons.sparkles,
    HyperUpdateStatus.downloading => LucideIcons.download,
    HyperUpdateStatus.readyToInstall ||
    HyperUpdateStatus.installing => LucideIcons.packageCheck,
    HyperUpdateStatus.upToDate ||
    HyperUpdateStatus.completed => LucideIcons.check,
    HyperUpdateStatus.error => LucideIcons.circleAlert,
  };

  String get _title => switch (status) {
    HyperUpdateStatus.idle => '让体验保持最新',
    HyperUpdateStatus.checking => '正在检查更新',
    HyperUpdateStatus.available => '发现新版本',
    HyperUpdateStatus.upToDate => '已是最新版本',
    HyperUpdateStatus.downloading => '正在下载更新',
    HyperUpdateStatus.readyToInstall => '更新已准备就绪',
    HyperUpdateStatus.installing => '正在安装更新',
    HyperUpdateStatus.completed => '更新完成',
    HyperUpdateStatus.error => '更新遇到了一点问题',
  };

  String get _message => switch (status) {
    HyperUpdateStatus.idle => '检查新版本，获取最新功能与体验优化。',
    HyperUpdateStatus.checking => '正在获取版本信息，请稍候。',
    HyperUpdateStatus.available =>
      mandatory ? '此版本为必要更新，请更新后继续使用。' : '为你带来了新的功能与细节优化。',
    HyperUpdateStatus.upToDate => '所有新功能与体验优化，都已为你准备好。',
    HyperUpdateStatus.downloading => '新版本正在路上，请保持网络连接。',
    HyperUpdateStatus.readyToInstall => '下载已完成，你可以开始安装新版本。',
    HyperUpdateStatus.installing => '正在应用新版本，请保持应用开启。',
    HyperUpdateStatus.completed => '新版本已就绪，继续探索更好的体验。',
    HyperUpdateStatus.error => '请检查网络连接或稍后重试。',
  };

  (String, VoidCallback?, IconData) get _primary => switch (status) {
    HyperUpdateStatus.idle => ('检查更新', onCheck, LucideIcons.refreshCw),
    HyperUpdateStatus.upToDate => ('再次检查', onCheck, LucideIcons.refreshCw),
    HyperUpdateStatus.available => ('立即更新', onUpdate, LucideIcons.download),
    HyperUpdateStatus.readyToInstall => (
      '立即安装',
      onInstall,
      LucideIcons.packageCheck,
    ),
    HyperUpdateStatus.completed => ('开始使用', onClose, LucideIcons.check),
    HyperUpdateStatus.error => ('重试', onRetry, LucideIcons.refreshCw),
    _ => ('', null, LucideIcons.refreshCw),
  };

  (String, VoidCallback?) get _secondary {
    if (_locked) return ('', null);
    return switch (status) {
      HyperUpdateStatus.checking ||
      HyperUpdateStatus.downloading => ('取消', onCancel),
      HyperUpdateStatus.available ||
      HyperUpdateStatus.readyToInstall => ('稍后再说', onLater),
      HyperUpdateStatus.error => ('关闭', onClose),
      _ => ('', null),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.hyperUi;
    final color = _tone.color(tokens);
    final (actionLabel, action, actionIcon) = _primary;
    final (alternativeLabel, alternative) = _secondary;
    final downloading = status == HyperUpdateStatus.downloading;
    final amount = downloading && downloadProgress != null
        ? downloadProgress!.fraction
        : normalizeHyperProgress(progress);

    // 安装过程与必要更新不允许通过返回键绕过；完成后恢复关闭能力。
    return PopScope(
      canPop: !_locked,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: HyperGlass(
          type: 'prominent',
          radius: HyperUiRadii.lg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 日志与进度可以滚动，操作区固定在底部，长内容仍可直接更新。
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(HyperUiSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '软件更新',
                              style: TextStyle(
                                color: tokens.mutedForeground,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (!_locked && onClose != null)
                            HyperButton(
                              type: 'ghost',
                              size: 'small',
                              icon: LucideIcons.x,
                              tooltip: '关闭',
                              onPressed: onClose,
                            ),
                        ],
                      ),
                      const SizedBox(height: HyperUiSpacing.lg),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _UpdateEmblem(
                          icon: _icon,
                          color: color,
                          busy: _busy,
                        ),
                      ),
                      const SizedBox(height: HyperUiSpacing.lg),
                      Text(
                        title ?? _title,
                        style: TextStyle(
                          color: tokens.foreground,
                          fontSize: 24,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: HyperUiSpacing.xs),
                      Text(
                        message ?? _message,
                        style: TextStyle(
                          color: status == HyperUpdateStatus.error
                              ? color
                              : tokens.mutedForeground,
                          fontSize: 14,
                          height: 1.55,
                        ),
                      ),
                      if (currentVersion != null || _showRelease) ...<Widget>[
                        const SizedBox(height: HyperUiSpacing.lg),
                        _UpdateVersionInfo(
                          currentVersion: currentVersion,
                          release: release,
                          showRelease: _showRelease,
                          completed: status == HyperUpdateStatus.completed,
                          mandatory: mandatory && _locked,
                        ),
                      ],
                      if (status == HyperUpdateStatus.available &&
                          release != null &&
                          release!.highlights.isNotEmpty) ...<Widget>[
                        const SizedBox(height: HyperUiSpacing.lg),
                        _UpdateHighlights(highlights: release!.highlights),
                      ],
                      if (_hasProgress) ...<Widget>[
                        const SizedBox(height: HyperUiSpacing.lg),
                        RepaintBoundary(
                          child: _UpdateProgress(
                            status: status,
                            progress: amount,
                            downloadProgress: downloading
                                ? downloadProgress
                                : null,
                            detail: progressText,
                          ),
                        ),
                      ],
                      if (mandatory && _locked) ...<Widget>[
                        const SizedBox(height: HyperUiSpacing.md),
                        Text(
                          '完成本次更新后即可继续使用',
                          style: TextStyle(
                            color: tokens.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!_busy || alternative != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    HyperUiSpacing.xl,
                    0,
                    HyperUiSpacing.xl,
                    HyperUiSpacing.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const HyperDivider(),
                      const SizedBox(height: HyperUiSpacing.lg),
                      if (!_busy)
                        HyperButton(
                          label: primaryLabel ?? actionLabel,
                          icon: actionIcon,
                          expanded: true,
                          onPressed: action,
                        ),
                      if (alternative != null) ...<Widget>[
                        if (!_busy) const SizedBox(height: HyperUiSpacing.xs),
                        HyperButton(
                          type: 'ghost',
                          label: secondaryLabel ?? alternativeLabel,
                          expanded: true,
                          onPressed: alternative,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
