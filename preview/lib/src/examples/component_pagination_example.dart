import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region PaginationComponentExample
class PaginationComponentExample extends StatefulWidget {
  const PaginationComponentExample({super.key});

  @override
  State<PaginationComponentExample> createState() =>
      _PaginationComponentExampleState();
}

class _PaginationComponentExampleState
    extends State<PaginationComponentExample> {
  int _page = 7;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyperText('共 20 页，点击页码或前后箭头', size: 'small'),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperPagination(
          page: _page,
          pageCount: 20,
          onChanged: (page) => setState(() => _page = page),
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        const HyperText('空数据与禁用状态', size: 'small'),
        const SizedBox(height: HyperUiSpacing.xs),
        const HyperPagination(page: 0, pageCount: 0),
      ],
    );
  }
}
// end-doc-region PaginationComponentExample
