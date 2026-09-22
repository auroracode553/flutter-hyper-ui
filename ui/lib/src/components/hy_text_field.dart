import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';

/// 适用于表单、搜索和多行输入的通用玻璃输入框。
class HyTextField extends StatefulWidget {
  const HyTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.clearable = true,
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

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool clearable;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  @override
  State<HyTextField> createState() => _HyTextFieldState();
}

class _HyTextFieldState extends State<HyTextField> {
  TextEditingController? _ownedController;
  bool _revealPassword = false;

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
    final radius = BorderRadius.circular(17);
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      validator: widget.validator,
      obscureText: widget.obscureText && !_revealPassword,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.obscureText ? 1 : widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      cursorColor: tokens.primary,
      style: TextStyle(color: tokens.foreground, fontSize: 15, height: 1.3),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        filled: true,
        fillColor: widget.enabled ? glass.surfaceSubtle : glass.controlTrack,
        hoverColor: glass.pressed,
        focusColor: glass.pressed,
        labelStyle: TextStyle(color: tokens.mutedForeground),
        floatingLabelStyle: TextStyle(
          color: tokens.primary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(color: tokens.mutedForeground),
        helperStyle: TextStyle(color: tokens.mutedForeground),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: tokens.mutedForeground, size: 20),
        suffixIcon: _buildSuffix(tokens),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: border(glass.edgeHighlight),
        disabledBorder: border(glass.edgeShade),
        focusedBorder: border(tokens.primary.withAlpha(190), width: 1.5),
        errorBorder: border(tokens.error.withAlpha(180)),
        focusedErrorBorder: border(tokens.error, width: 1.5),
      ),
    );
  }

  Widget? _buildSuffix(HyUiThemeTokens tokens) {
    if (widget.suffix != null) return widget.suffix;
    final canClear =
        widget.clearable &&
        widget.enabled &&
        !widget.readOnly &&
        _controller.text.isNotEmpty;
    if (!canClear && !widget.obscureText) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (canClear)
          IconButton(
            tooltip: '清除',
            icon: Icon(
              Icons.cancel_rounded,
              size: 19,
              color: tokens.mutedForeground,
            ),
            onPressed: () {
              _controller.clear();
              widget.onChanged?.call('');
            },
          ),
        if (widget.obscureText)
          IconButton(
            tooltip: _revealPassword ? '隐藏密码' : '显示密码',
            onPressed: widget.enabled && !widget.readOnly
                ? () => setState(() => _revealPassword = !_revealPassword)
                : null,
            icon: Icon(
              _revealPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: tokens.mutedForeground,
            ),
          ),
      ],
    );
  }
}
