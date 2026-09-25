import 'package:flutter_hyper_ui/hy_ui_preview_core.dart';
import 'package:flutter/material.dart';

import 'preview_catalog.dart';
import 'preview_deferred_content.dart';

class PreviewShell extends StatelessWidget {
  final String componentId;
  final bool embedded;
  final VoidCallback? onToggleTheme;
  final VoidCallback? onComponentReady;
  final ValueChanged<String>? onComponentError;

  const PreviewShell({
    super.key,
    required this.componentId,
    required this.embedded,
    this.onToggleTheme,
    this.onComponentReady,
    this.onComponentError,
  });

  @override
  Widget build(BuildContext context) {
    final item = PreviewCatalog.byId(componentId);

    if (embedded) {
      return _EmbeddedPreview(
        key: ValueKey(item.id),
        item: item,
        onReady: onComponentReady,
        onError: onComponentError,
      );
    }

    return _StandalonePreview(
      initialSelected: item,
      onToggleTheme: onToggleTheme,
      onComponentReady: onComponentReady,
      onComponentError: onComponentError,
    );
  }
}

class _EmbeddedPreview extends StatelessWidget {
  final PreviewItem item;
  final VoidCallback? onReady;
  final ValueChanged<String>? onError;

  const _EmbeddedPreview({super.key, required this.item, this.onReady, this.onError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HyUiSpacing.pagePadding),
        child: PreviewDeferredContent(item: item, onReady: onReady, onError: onError),
      ),
    );
  }
}

class _StandalonePreview extends StatefulWidget {
  final PreviewItem initialSelected;
  final VoidCallback? onToggleTheme;
  final VoidCallback? onComponentReady;
  final ValueChanged<String>? onComponentError;

  const _StandalonePreview({
    required this.initialSelected,
    this.onToggleTheme,
    this.onComponentReady,
    this.onComponentError,
  });

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
      body: HySoftBackground(
        child: SafeArea(
          child: Column(
            children: [
              HyTopBar(
                title: 'Flutter Hyper UI Preview',
                subtitle: selected.description,
                safeArea: false,
                actions: [
                  HyIconButton(
                    icon: Icons.brightness_6_outlined,
                    tooltip: '切换明暗主题',
                    onPressed: widget.onToggleTheme,
                  ),
                ],
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
                  separatorBuilder: (_, _) =>
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
                      child: PreviewDeferredContent(
                        key: ValueKey(selected.id),
                        item: selected,
                        onReady: widget.onComponentReady,
                        onError: widget.onComponentError,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
