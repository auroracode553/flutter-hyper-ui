import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

import 'preview_catalog.dart';

class PreviewShell extends StatelessWidget {
  final String componentId;
  final bool embedded;
  final VoidCallback? onToggleTheme;

  const PreviewShell({
    super.key,
    required this.componentId,
    required this.embedded,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final item = PreviewCatalog.byId(componentId);

    if (embedded) {
      return _EmbeddedPreview(item: item);
    }

    return _StandalonePreview(initialSelected: item, onToggleTheme: onToggleTheme);
  }
}

class _EmbeddedPreview extends StatelessWidget {
  final PreviewItem item;

  const _EmbeddedPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: HySoftBackground(child: SingleChildScrollView(
        padding: const EdgeInsets.all(HyUiSpacing.pagePadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: item.builder(context),
          ),
        ),
      )),
    );
  }
}

class _StandalonePreview extends StatefulWidget {
  final PreviewItem initialSelected;
  final VoidCallback? onToggleTheme;

  const _StandalonePreview({required this.initialSelected, this.onToggleTheme});

  @override
  State<_StandalonePreview> createState() => _StandalonePreviewState();
}

class _StandalonePreviewState extends State<_StandalonePreview> {
  late String _selectedId = widget.initialSelected.id;

  PreviewItem get _selected => PreviewCatalog.byId(_selectedId);

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final selected = _selected;

    return Scaffold(
      backgroundColor: tokens.background,
      body: HySoftBackground(child: SafeArea(
        child: Column(
          children: [
            HyTopBar(
              title: 'Flutter Hyper UI Preview',
              subtitle: selected.description,
              safeArea: false,
              actions: [IconButton(tooltip: '切换明暗主题', onPressed: widget.onToggleTheme,
                icon: const Icon(Icons.brightness_6_outlined))],
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: HyUiSpacing.pagePadding,
                  vertical: HyUiSpacing.xs,
                ),
                itemCount: PreviewCatalog.items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: HyUiSpacing.xs),
                itemBuilder: (context, index) {
                  final item = PreviewCatalog.items[index];
                  return HyTag(
                    label: item.title,
                    selected: item.id == selected.id,
                    onTap: () => setState(() => _selectedId = item.id),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(HyUiSpacing.pagePadding),
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
      )),
    );
  }
}
