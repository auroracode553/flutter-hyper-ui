import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'loading/hyper_loading_type.dart';
import 'loading/loading_painter.dart';

export 'loading/hyper_loading_type.dart';

/// 原生加载动画。通过 type 选择形态，业务负责显示和移除组件。
class HyperLoading extends StatefulWidget {
  const HyperLoading({super.key, this.type, this.label});

  /// 不指定时为每个组件实例随机选择一款，重建不重新抽取。
  final HyperLoadingType? type;
  final String? label;

  @override
  State<HyperLoading> createState() => _HyperLoadingState();
}

class _HyperLoadingState extends State<HyperLoading>
    with SingleTickerProviderStateMixin {
  late final _randomType = HyperLoadingType
      .values[math.Random().nextInt(HyperLoadingType.values.length)];
  HyperLoadingType get _resolvedType => widget.type ?? _randomType;

  final _seconds = ValueNotifier<double>(0);
  final _renderer = LoadingRenderer();
  late final Ticker _ticker = createTicker(_tick);
  Duration? _previousFrame;

  // 原始动画时间轴固定以 2× 推进。
  void _tick(Duration elapsed) {
    final previous = _previousFrame;
    _previousFrame = elapsed;
    if (previous != null) {
      _seconds.value +=
          (elapsed - previous).inMicroseconds /
          Duration.microsecondsPerSecond *
          2;
    }
  }

  void _syncClock() {
    // 读取宿主时钟开关，保持 Flutter 3.32 接入范围。
    // ignore: deprecated_member_use
    final tickerEnabled = TickerMode.of(context);
    final enabled =
        tickerEnabled &&
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    if (enabled && !_ticker.isActive) {
      _previousFrame = null;
      _ticker.start();
    } else if (!enabled && _ticker.isActive) {
      _ticker.stop();
      _previousFrame = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncClock();
  }

  @override
  void didUpdateWidget(HyperLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_resolvedType != (oldWidget.type ?? _randomType)) _seconds.value = 0;
    _syncClock();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = _resolvedType;
    final palette = loadingColors(type);
    final size = loadingSize(type);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: size,
            painter: LoadingPainter(
              time: _seconds,
              renderer: _renderer,
              type: type,
              primary: palette.$1,
              secondary: palette.$2,
            ),
          ),
        ),
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(widget.label!),
          ),
      ],
    );
  }
}
