import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region PaginationComponentExample
class PaginationComponentExample extends StatefulWidget {
  const PaginationComponentExample({super.key});

  @override
  State<PaginationComponentExample> createState() =>
      _PaginationComponentExampleState();
}

class _PaginationComponentExampleState extends State<PaginationComponentExample> {
  int _page = 7;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const HyText('共 20 页，点击页码或前后箭头', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        HyPagination(
          page: _page,
          pageCount: 20,
          onChanged: (page) => setState(() => _page = page),
        ),
        const SizedBox(height: HyUiSpacing.lg),
        const HyText('空数据与禁用状态', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.xs),
        const HyPagination(page: 0, pageCount: 0),
      ],
    );
  }
}
// end-doc-region PaginationComponentExample
