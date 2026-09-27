import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';
import 'hyper_tooltip.dart';

/// Hyper's own text field surface around Flutter's text editing engine.
class HyperTextField extends StatefulWidget {
  const HyperTextField({
    super.key,
    this.type = 'text',
    this.rows = 3,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.showPasswordToggle = false,
    this.clearable = false,
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

  final String type;
  final int rows;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final bool showPasswordToggle;
  final bool clearable;
  final int? maxLength;
  final bool showCounter;
  final bool autofocus;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final String? initialValue;

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
    assert(
      const <String>{
        'text',
        'search',
        'password',
        'textarea',
      }.contains(widget.type),
    );
    assert(widget.rows > 0);
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
    final multiline = widget.type == 'textarea';
    final password = widget.type == 'password';
    final borderColor = error != null
        ? tokens.error
        : _focusNode.hasFocus
        ? tokens.primary
        : tokens.input;
    final radius = BorderRadius.circular(20);
    final editor = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: TextStyle(color: tokens.foreground, fontSize: 16, height: 1.3),
      cursorColor: tokens.primary,
      backgroundCursorColor: tokens.mutedForeground,
      keyboardType:
          widget.keyboardType ??
          (multiline ? TextInputType.multiline : TextInputType.text),
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      readOnly: !active,
      obscureText: password && _obscured,
      maxLines: password ? 1 : (multiline ? widget.rows : 1),
      minLines: password ? 1 : (multiline ? widget.rows : 1),
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
        GestureDetector(
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.enabled ? glass.surfaceSubtle : glass.controlTrack,
              borderRadius: radius,
              border: Border.all(
                color: borderColor,
                width: _focusNode.hasFocus ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
        ),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: tokens.error, fontSize: 12),
            ),
          ),
        if (widget.showCounter && widget.maxLength != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.length}/${widget.maxLength}',
              style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

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
