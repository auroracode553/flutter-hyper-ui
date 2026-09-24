import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region NumberStepperComponentExample
class NumberStepperComponentExample extends StatefulWidget {
  const NumberStepperComponentExample({super.key});

  @override
  State<NumberStepperComponentExample> createState() =>
      _NumberStepperComponentExampleState();
}

class _NumberStepperComponentExampleState
    extends State<NumberStepperComponentExample> {
  int _quantity = 2;
  int _interval = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyText('数量（1–8）', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        HyNumberStepper(
          value: _quantity,
          min: 1,
          max: 8,
          semanticLabel: '数量',
          onChanged: (value) => setState(() => _quantity = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),
        const HyText('以 5 为步长', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        HyNumberStepper(
          value: _interval,
          min: 0,
          max: 20,
          step: 5,
          onChanged: (value) => setState(() => _interval = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),
        const HyText('只读状态', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        const HyNumberStepper(value: 3),
      ],
    );
  }
}
// end-doc-region NumberStepperComponentExample
