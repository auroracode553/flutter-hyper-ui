import 'package:flutter/material.dart';

class HyTextField extends StatefulWidget {
  const HyTextField({super.key, this.controller, this.focusNode, this.label,
    this.hintText, this.helperText, this.errorText, this.prefixIcon, this.suffix,
    this.enabled = true, this.obscureText = false, this.maxLines = 1,
    this.maxLength, this.clearable = true, this.keyboardType, this.onChanged,
    this.onSubmitted, this.validator, this.initialValue});
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label, hintText, helperText, errorText, initialValue;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled, obscureText, clearable;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged, onSubmitted;
  final FormFieldValidator<String>? validator;
  @override
  State<HyTextField> createState() => _HyTextFieldState();
}

class _HyTextFieldState extends State<HyTextField> {
  TextEditingController? _owned;
  TextEditingController get _controller => widget.controller ?? _owned!;
  bool _reveal = false;
  @override
  void initState() { super.initState(); _bind(); }
  void _bind() {
    if (widget.controller == null) _owned ??= TextEditingController(text: widget.initialValue);
    _controller.addListener(_refresh);
  }
  void _refresh() { if (mounted) setState(() {}); }
  @override
  void didUpdateWidget(covariant HyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final previous = oldWidget.controller ?? _owned!;
      final value = previous.value;
      previous.removeListener(_refresh);
      _owned?.dispose(); _owned = null;
      if (widget.controller == null) _owned = TextEditingController.fromValue(value);
      _bind();
    }
  }
  @override
  void dispose() { _controller.removeListener(_refresh); _owned?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => TextFormField(controller: _controller,
    focusNode: widget.focusNode, enabled: widget.enabled, validator: widget.validator,
    obscureText: widget.obscureText && !_reveal,
    maxLines: widget.obscureText ? 1 : widget.maxLines, maxLength: widget.maxLength,
    keyboardType: widget.keyboardType, onChanged: widget.onChanged,
    onFieldSubmitted: widget.onSubmitted,
    decoration: InputDecoration(labelText: widget.label, hintText: widget.hintText,
      helperText: widget.helperText, errorText: widget.errorText,
      prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
      suffixIcon: widget.suffix ?? (!widget.obscureText &&
        (!widget.clearable || !widget.enabled || _controller.text.isEmpty) ? null :
        Row(mainAxisSize: MainAxisSize.min, children: [
        if (widget.clearable && widget.enabled && _controller.text.isNotEmpty)
          IconButton(tooltip: '清除', icon: const Icon(Icons.cancel_outlined, size: 20),
            onPressed: () { _controller.clear(); widget.onChanged?.call(''); }),
        if (widget.obscureText) IconButton(tooltip: _reveal ? '隐藏密码' : '显示密码',
          onPressed: widget.enabled ? () => setState(() => _reveal = !_reveal) : null,
          icon: Icon(_reveal ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20)),
      ]))));
}
