part of 'hyper_update_dialog.dart';

/// 更新标识：柔光底色、细描边及沿用 Hyper 自绘的加载环。
class _UpdateEmblem extends StatelessWidget {
  const _UpdateEmblem({
    required this.icon,
    required this.color,
    required this.busy,
  });

  final IconData icon;
  final Color color;
  final bool busy;

  @override
  Widget build(BuildContext context) => Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(HyperUiRadii.md),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.alphaBlend(color.withAlpha(28), context.hyperGlass.surface),
          Color.alphaBlend(color.withAlpha(10), context.hyperGlass.surface),
        ],
      ),
      border: Border.all(color: color.withAlpha(35)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: color.withAlpha(18),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(icon, size: 26, color: color),
        if (busy)
          SizedBox.square(
            dimension: 48,
            child: HyperSpinner(
              color: color,
              strokeWidth: 1.5,
              backgroundColor: color.withAlpha(12),
            ),
          ),
      ],
    ),
  );
}

class _UpdateVersionInfo extends StatelessWidget {
  const _UpdateVersionInfo({
    required this.currentVersion,
    required this.release,
    required this.showRelease,
    required this.completed,
    required this.mandatory,
  });

  final String? currentVersion;
  final HyperUpdateRelease? release;
  final bool showRelease;
  final bool completed;
  final bool mandatory;

  @override
  Widget build(BuildContext context) {
    final tokens = context.hyperUi;
    return Container(
      padding: const EdgeInsets.all(HyperUiSpacing.sm),
      decoration: BoxDecoration(
        color: context.hyperGlass.surfaceSubtle,
        borderRadius: BorderRadius.circular(HyperUiRadii.sm),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: HyperUiSpacing.xs,
            runSpacing: HyperUiSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              if (currentVersion != null && !completed)
                Text(
                  '当前 $currentVersion',
                  style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
                ),
              if (showRelease && currentVersion != null && !completed)
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? LucideIcons.arrowLeft
                      : LucideIcons.arrowRight,
                  size: 14,
                  color: tokens.mutedForeground,
                ),
              if (showRelease)
                HyperBadge(
                  label: '${completed ? '已更新至' : '新版本'} ${release!.version}',
                  tone: completed ? HyperUiTone.success : HyperUiTone.primary,
                ),
              if (completed && !showRelease && currentVersion != null)
                Text('当前 $currentVersion'),
              if (mandatory)
                const HyperBadge(label: '必要更新', tone: HyperUiTone.warning),
            ],
          ),
          if (showRelease &&
              (release!.releaseDate != null ||
                  release!.sizeLabel != null)) ...<Widget>[
            const SizedBox(height: HyperUiSpacing.xs),
            Text(
              <String>[
                if (release!.releaseDate != null) release!.releaseDate!,
                if (release!.sizeLabel != null) release!.sizeLabel!,
              ].join(' · '),
              style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _UpdateHighlights extends StatelessWidget {
  const _UpdateHighlights({required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        '本次更新',
        style: TextStyle(
          color: context.hyperUi.foreground,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      for (final highlight in highlights)
        Padding(
          padding: const EdgeInsets.only(top: HyperUiSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  LucideIcons.check,
                  size: 14,
                  color: context.hyperUi.primary,
                ),
              ),
              const SizedBox(width: HyperUiSpacing.xs),
              Expanded(
                child: Text(
                  highlight,
                  style: TextStyle(
                    color: context.hyperUi.mutedForeground,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class _UpdateProgress extends StatelessWidget {
  const _UpdateProgress({
    required this.status,
    required this.progress,
    required this.downloadProgress,
    required this.detail,
  });

  final HyperUpdateStatus status;
  final double? progress;
  final HyperUpdateDownloadProgress? downloadProgress;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final installing = status == HyperUpdateStatus.installing;
    final tokens = context.hyperUi;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: <Widget>[
            HyperBadge(
              label: installing ? '下载完成' : '1 · 下载更新',
              icon: installing ? LucideIcons.check : LucideIcons.download,
              tone: installing ? HyperUiTone.success : HyperUiTone.primary,
            ),
            HyperBadge(
              label: '2 · 安装更新',
              tone: installing ? HyperUiTone.primary : HyperUiTone.neutral,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        Text(
          progress == null
              ? (installing ? '正在安装…' : '正在下载…')
              : '${hyperProgressPercentage(progress)}%',
          style: TextStyle(
            color: tokens.foreground,
            fontSize: 28,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperProgress(value: progress, showLabel: false),
        const SizedBox(height: HyperUiSpacing.xs),
        if (downloadProgress != null) ...<Widget>[
          Text(
            downloadProgress!.sizeLabel,
            style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
          ),
          if (downloadProgress!.speedLabel != null ||
              downloadProgress!.remainingLabel != null) ...<Widget>[
            const SizedBox(height: HyperUiSpacing.xxs),
            DefaultTextStyle(
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(color: tokens.mutedForeground, fontSize: 12),
              child: Wrap(
                spacing: HyperUiSpacing.sm,
                runSpacing: HyperUiSpacing.xxs,
                children: <Widget>[
                  if (downloadProgress!.speedLabel != null)
                    Text(downloadProgress!.speedLabel!),
                  if (downloadProgress!.remainingLabel != null)
                    Text(downloadProgress!.remainingLabel!),
                ],
              ),
            ),
          ],
        ],
        if (detail != null || downloadProgress == null)
          Text(
            detail ?? (installing ? '正在应用更新，请稍候' : '正在下载更新文件'),
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 12,
              height: 1.5,
            ),
          ),
      ],
    );
  }
}
