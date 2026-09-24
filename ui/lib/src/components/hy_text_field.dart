import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';

/// 通用玻璃输入框：只负责文本输入本身，不内置标题、说明文案或业务图标。
///
/// 字段标题与说明应由表单层（FormItem）或外部组件提供；前缀、后缀通过
/// [prefix] / [suffix] 插槽注入；[clearable]、[showPasswordToggle]、
/// [showCounter] 等增强能力默认关闭，由调用方按需开启。
class HyTextField extends StatefulWidget {
  const HyTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.clearable = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.initialValue,
  });

  /// 文本编辑控制器；为空时组件内部依据 [initialValue] 自建并维护。
  final TextEditingController? controller;

  /// 外部焦点节点；为空时由 TextField 内部管理。
  final FocusNode? focusNode;

  /// 占位提示文字（placeholder）。
  final String? hintText;

  /// 错误提示文字；传入非空值即进入错误态（红色边框）。
  final String? errorText;

  /// 前缀插槽，可放置图标等任意组件；默认无。
  final Widget? prefix;

  /// 后缀插槽，可放置任意组件；与清空、密码切换按钮共存，默认无。
  final Widget? suffix;

  /// 是否启用输入，默认 true。
  final bool enabled;

  /// 是否只读，默认 false。
  final bool readOnly;

  /// 是否隐藏输入内容（密码模式），默认 false。
  final bool obscureText;

  /// 是否显示密码显隐切换按钮，需配合 [obscureText]，默认 false。
  final bool showPasswordToggle;

  /// 是否在内容非空时显示清空按钮，默认 false。
  final bool clearable;

  /// 最大行数，默认 1；密码模式下强制为 1。
  final int maxLines;

  /// 最小行数，用于多行输入。
  final int? minLines;

  /// 最大字符数，超出后阻止继续输入。
  final int? maxLength;

  /// 是否显示字符计数，需配合 [maxLength]，默认 false。
  final bool showCounter;

  /// 是否自动获取焦点，默认 false。
  final bool autofocus;

  /// 文本水平对齐方式，默认 [TextAlign.start]。
  final TextAlign textAlign;

  /// 唤起键盘的类型。
  final TextInputType? keyboardType;

  /// 键盘动作按钮类型。
  final TextInputAction? textInputAction;

  /// 文本大小写策略，默认 [TextCapitalization.none]。
  final TextCapitalization textCapitalization;

  /// 自动填充提示。
  final Iterable<String>? autofillHints;

  /// 内容变化回调。
  final ValueChanged<String>? onChanged;

  /// 键盘动作提交回调。
  final ValueChanged<String>? onSubmitted;

  /// 点击输入框回调。
  final VoidCallback? onTap;

  /// 表单校验函数，配合 [Form] 使用。
  final FormFieldValidator<String>? validator;

  /// 无外部 [controller] 时使用的初始值。
  final String? initialValue;

  @override
  State<HyTextField> createState() => _HyTextFieldState();
}

class _HyTextFieldState extends State<HyTextField> {
  TextEditingController? _ownedController;

  /// 密码模式下内容是否处于隐藏状态，默认隐藏。
  bool _obscured = true;

  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    _bindController();
  }

  void _bindController() {
    if (widget.controller == null) {
      _ownedController ??= TextEditingController(text: widget.initialValue);
    }
    _controller.addListener(_refresh);
  }

  /// 清空按钮的显隐依赖文本内容，内容变化时刷新。
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant HyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    final previous = oldWidget.controller ?? _ownedController!;
    final value = previous.value;
    previous.removeListener(_refresh);
    _ownedController?.dispose();
    _ownedController = null;
    if (widget.controller == null) {
      _ownedController = TextEditingController.fromValue(value);
    }
    _bindController();
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    // 圆角与 HySelect 等表单控件（HyGlass radius: 16）保持一致。
    final borderRadius = BorderRadius.circular(16);

    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      validator: widget.validator,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText && _obscured,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.obscureText ? 1 : widget.minLines,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      cursorColor: tokens.primary,
      style: TextStyle(color: tokens.foreground, fontSize: 14, height: 1.3),
      buildCounter: _buildCounter,
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        filled: true,
        fillColor: widget.enabled ? glass.surfaceSubtle : glass.controlTrack,
        hoverColor: glass.pressed,
        focusColor: glass.pressed,
        hintStyle: TextStyle(color: tokens.mutedForeground),
        errorStyle: TextStyle(color: tokens.error, fontSize: 12),
        prefixIcon: widget.prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 6),
                child: IconTheme.merge(
                  data: IconThemeData(color: tokens.mutedForeground, size: 18),
                  child: widget.prefix!,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: _buildSuffix(tokens),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        // 轮廓使用专用 input 令牌（浅色 #E5E7EB / 深色 #343B47），
        // 避免玻璃高光色 edgeHighlight 在浅色下白边贴白底导致轮廓不可见。
        enabledBorder: border(tokens.input),
        disabledBorder: border(tokens.input.withAlpha(110)),
        focusedBorder: border(tokens.primary.withAlpha(190), width: 1.5),
        errorBorder: border(tokens.error.withAlpha(180)),
        focusedErrorBorder: border(tokens.error, width: 1.5),
      ),
    );
  }

  /// 字符计数：未开启或未设置 [HyTextField.maxLength] 时返回 null，不占布局。
  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    if (!widget.showCounter || maxLength == null) return null;
    final tokens = HyUiThemeTokens.of(context);
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(
        color: tokens.mutedForeground,
        fontSize: 12,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
    );
  }

  Widget? _buildSuffix(HyUiThemeTokens tokens) {
    final bool interactive = widget.enabled && !widget.readOnly;

    final Widget? passwordButton =
        widget.showPasswordToggle && widget.obscureText
        ? _AffixButton(
            icon: _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            tooltip: _obscured ? '显示密码' : '隐藏密码',
            color: tokens.mutedForeground,
            onPressed: interactive
                ? () => setState(() => _obscured = !_obscured)
                : null,
          )
        : null;

    // 清空按钮始终保留位置，无内容时透明且不可点，避免布局跳动。
    final bool canClear =
        widget.clearable && interactive && _controller.text.isNotEmpty;
    final Widget? clearButton = widget.clearable
        ? Opacity(
            opacity: canClear ? 1 : 0,
            child: IgnorePointer(
              ignoring: !canClear,
              child: _AffixButton(
                icon: Icons.close_rounded,
                tooltip: '清空',
                color: tokens.mutedForeground,
                onPressed: canClear ? _clear : null,
              ),
            ),
          )
        : null;

    if (widget.suffix == null &&
        passwordButton == null &&
        clearButton == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.suffix != null)
            IconTheme.merge(
              data: IconThemeData(color: tokens.mutedForeground, size: 18),
              child: widget.suffix!,
            ),
          ?passwordButton,
          ?clearButton,
        ],
      ),
    );
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }
}

/// 输入框前后缀区域使用的轻量图标按钮，不强制 48px 点击盒尺寸。
class _AffixButton extends StatelessWidget {
  const _AffixButton({
    required this.icon,
    required this.color,
    this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String? tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 18, color: color),
    );

    return InkResponse(
      onTap: onPressed,
      radius: 18,
      child: tooltip == null
          ? content
          : Tooltip(message: tooltip!, child: content),
    );
  }
}
