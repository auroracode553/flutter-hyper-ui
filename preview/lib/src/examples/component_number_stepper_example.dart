import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

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
        const HyperText('数量（1–8）', type: 'h5'),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperNumberStepper(
          value: _quantity,
          min: 1,
          max: 8,
          onChanged: (value) => setState(() => _quantity = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        const HyperText('以 5 为步长', type: 'h5'),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperNumberStepper(
          value: _interval,
          min: 0,
          max: 20,
          step: 5,
          onChanged: (value) => setState(() => _interval = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        const HyperText('只读状态', type: 'h5'),
        const SizedBox(height: HyperUiSpacing.xs),
        const HyperNumberStepper(value: 3),
      ],
    );
  }
}
// end-doc-region NumberStepperComponentExample
