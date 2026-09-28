import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';
import 'hyper_tooltip.dart';

/// Hyper's own text field surface around Flutter's text editing engine.
class HyperTextField extends StatefulWidget {
  const HyperTextField({
    super.key,
    this.type = 'text',
    this.rows = 3,
    this.clearable = false,
    this.showPasswordToggle = false,
    this.showWordLimit = false,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.initialValue,
  }) : assert(
         type == 'text' ||
             type == 'search' ||
             type == 'password' ||
             type == 'textarea' ||
             type == 'email' ||
             type == 'url' ||
             type == 'number' ||
             type == 'tel',
         'type must be text, search, password, textarea, email, url, number, or tel.',
       ),
       assert(rows > 0),
       assert(maxLength == null || maxLength > 0);

  /// 输入形态；textarea 使用多行编辑，其余值使用单行编辑。
  final String type;
  final int rows;
  final bool clearable;
  final bool showPasswordToggle;
  final bool showWordLimit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? initialValue;

  bool get _isTextarea => type == 'textarea';
  bool get _isPassword => type == 'password';

  @override
  State<HyperTextField> createState() => _HyperTextFieldState();
}

class _HyperTextFieldState extends State<HyperTextField> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  bool _obscured = true;

  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;
  FocusNode get _focusNode => widget.focusNode ?? _ownedFocusNode!;

  @override
  void initState() {
    super.initState();
    _ownedController = widget.controller == null
        ? TextEditingController(text: widget.initialValue)
        : null;
    _ownedFocusNode = widget.focusNode == null ? FocusNode() : null;
    _controller.addListener(_refresh);
    _focusNode.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(HyperTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) _obscured = true;
    if (oldWidget.controller != widget.controller) {
      final previous = oldWidget.controller ?? _ownedController!;
      final value = previous.value;
      previous.removeListener(_refresh);
      _ownedController?.dispose();
      _ownedController = widget.controller == null
          ? TextEditingController.fromValue(value)
          : null;
      _controller.addListener(_refresh);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      final previous = oldWidget.focusNode ?? _ownedFocusNode!;
      previous.removeListener(_refresh);
      _ownedFocusNode?.dispose();
      _ownedFocusNode = widget.focusNode == null ? FocusNode() : null;
      _focusNode.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _focusNode.removeListener(_refresh);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      builder: (field) => _buildSurface(context, field),
    );
  }

  Widget _buildSurface(BuildContext context, FormFieldState<String> field) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final error = widget.errorText ?? field.errorText;
    final active = widget.enabled && !widget.readOnly;
    final multiline = widget._isTextarea;
    final password = widget._isPassword;
    final borderColor = error != null
        ? tokens.error
        : _focusNode.hasFocus
        ? tokens.primary
        : tokens.input;
    final radius = BorderRadius.circular(20);
    final editor = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: TextStyle(
        color: tokens.foreground,
        fontFamily: HyperUiTheme.of(context).fontFamily,
        fontSize: 16,
        height: 1.3,
      ),
      cursorColor: tokens.primary,
      backgroundCursorColor: tokens.mutedForeground,
      keyboardType: widget.keyboardType ?? _keyboardTypeFor(widget.type),
      textInputAction:
          widget.textInputAction ?? _textInputActionFor(widget.type),
      autofocus: widget.autofocus,
      readOnly: !active,
      obscureText: password && _obscured,
      autocorrect: !password,
      enableSuggestions: !password,
      maxLines: multiline ? widget.rows : 1,
      minLines: multiline ? widget.rows : 1,
      inputFormatters: widget.maxLength == null
          ? null
          : <TextInputFormatter>[
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
      onChanged: (value) {
        field.didChange(value);
        widget.onChanged?.call(value);
      },
      onSubmitted: widget.onSubmitted,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: widget.enabled ? glass.surfaceSubtle : glass.controlTrack,
            borderRadius: radius,
            border: Border.all(
              color: borderColor,
              width: _focusNode.hasFocus ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: multiline ? 12 : 9,
            ),
            child: Row(
              crossAxisAlignment: multiline
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.prefix != null) ...<Widget>[
                  IconTheme.merge(
                    data: IconThemeData(
                      color: tokens.mutedForeground,
                      size: 18,
                    ),
                    child: widget.prefix!,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      if (_controller.text.isEmpty && widget.hintText != null)
                        IgnorePointer(
                          child: Text(
                            widget.hintText!,
                            style: TextStyle(
                              color: tokens.mutedForeground,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      editor,
                    ],
                  ),
                ),
                if (widget.suffix != null) ...<Widget>[
                  const SizedBox(width: 8),
                  widget.suffix!,
                ],
                if (password && widget.showPasswordToggle)
                  _AffixButton(
                    icon: _obscured ? LucideIcons.eye : LucideIcons.eyeOff,
                    tooltip: _obscured ? '显示密码' : '隐藏密码',
                    color: tokens.mutedForeground,
                    onPressed: active
                        ? () => setState(() => _obscured = !_obscured)
                        : null,
                  ),
                if (widget.clearable)
                  Opacity(
                    opacity: active && _controller.text.isNotEmpty ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !active || _controller.text.isEmpty,
                      child: _AffixButton(
                        icon: LucideIcons.x,
                        tooltip: '清空',
                        color: tokens.mutedForeground,
                        onPressed: () {
                          _controller.clear();
                          field.didChange('');
                          widget.onChanged?.call('');
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: tokens.error, fontSize: 12),
            ),
          ),
        if (widget.showWordLimit && widget.maxLength != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.characters.length}/${widget.maxLength}',
              style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

TextInputType _keyboardTypeFor(String type) => switch (type) {
  'textarea' => TextInputType.multiline,
  'email' => TextInputType.emailAddress,
  'url' => TextInputType.url,
  'number' => TextInputType.number,
  'tel' => TextInputType.phone,
  _ => TextInputType.text,
};

TextInputAction _textInputActionFor(String type) => switch (type) {
  'textarea' => TextInputAction.newline,
  'search' => TextInputAction.search,
  _ => TextInputAction.done,
};

class _AffixButton extends StatelessWidget {
  const _AffixButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => HyperTooltip(
    message: tooltip,
    child: HyperPressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: color),
      ),
    ),
  );
}
