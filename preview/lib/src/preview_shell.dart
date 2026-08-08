import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

import 'preview_catalog.dart';

class PreviewShell extends StatelessWidget {
  final String componentId;
  final bool embedded;

  const PreviewShell({
    super.key,
    required this.componentId,
    required this.embedded,
  });

  @override
  Widget build(BuildContext context) {
    final item = PreviewCatalog.byId(componentId);

    if (embedded) {
      return _EmbeddedPreview(item: item);
    }

    return _StandalonePreview(initialSelected: item);
  }
}

class _EmbeddedPreview extends StatelessWidget {
  final PreviewItem item;

  const _EmbeddedPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DocUiSpacing.pagePadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: item.builder(context),
          ),
        ),
      ),
    );
  }
}

class _StandalonePreview extends StatefulWidget {
  final PreviewItem initialSelected;

  const _StandalonePreview({required this.initialSelected});

  @override
  State<_StandalonePreview> createState() => _StandalonePreviewState();
}

class _StandalonePreviewState extends State<_StandalonePreview> {
  late String _selectedId = widget.initialSelected.id;

  PreviewItem get _selected => PreviewCatalog.byId(_selectedId);

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final selected = _selected;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            DocTopBar(
              title: 'Flutter Hyper UI Preview',
              subtitle: selected.description,
              safeArea: false,
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: DocUiSpacing.pagePadding,
                  vertical: DocUiSpacing.xs,
                ),
                itemCount: PreviewCatalog.items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: DocUiSpacing.xs),
                itemBuilder: (context, index) {
                  final item = PreviewCatalog.items[index];
                  return DocTag(
                    label: item.title,
                    selected: item.id == selected.id,
                    onTap: () => setState(() => _selectedId = item.id),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DocUiSpacing.pagePadding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: selected.builder(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
