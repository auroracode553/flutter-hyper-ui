import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region FormFieldComponentExample
class FormFieldComponentExample extends StatefulWidget {
  const FormFieldComponentExample({super.key});

  @override
  State<FormFieldComponentExample> createState() =>
      _FormFieldComponentExampleState();
}

class _FormFieldComponentExampleState extends State<FormFieldComponentExample> {
  String _name = '';
  int _quantity = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HyFormField(
          label: '项目名称',
          isRequired: true,
          helperText: '最多填写 30 个字符',
          errorText: _name.isEmpty ? '请输入项目名称' : null,
          child: HyTextField(
            hintText: '例如：组件设计',
            maxLength: 30,
            onChanged: (value) => setState(() => _name = value),
          ),
        ),
        const SizedBox(height: HyUiSpacing.lg),
        HyFormField(
          label: '数量',
          helperText: '可选择 1–8 个',
          child: Align(
            alignment: Alignment.centerLeft,
            child: HyNumberStepper(
              value: _quantity,
              min: 1,
              max: 8,
              onChanged: (value) => setState(() => _quantity = value),
            ),
          ),
        ),
      ],
    );
  }
}
// end-doc-region FormFieldComponentExample
