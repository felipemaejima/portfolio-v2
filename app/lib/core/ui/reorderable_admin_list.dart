import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import 'admin_page.dart';
import 'failure_text.dart';

/// Lista do painel com arrastar-para-reordenar otimista (APP.md §6): reordena
/// na UI, chama `onReorder` com a lista completa de ids e reverte em erro.
class ReorderableAdminList<T> extends StatefulWidget {
  const ReorderableAdminList({
    required this.items,
    required this.idOf,
    required this.itemBuilder,
    required this.onReorder,
    this.emptyText,
    super.key,
  });

  final List<T> items;
  final String Function(T) idOf;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function(List<String> ids) onReorder;
  final String? emptyText;

  @override
  State<ReorderableAdminList<T>> createState() =>
      _ReorderableAdminListState<T>();
}

class _ReorderableAdminListState<T> extends State<ReorderableAdminList<T>> {
  late List<T> _items = [...widget.items];

  @override
  void didUpdateWidget(covariant ReorderableAdminList<T> old) {
    super.didUpdateWidget(old);
    if (!identical(old.items, widget.items)) _items = [...widget.items];
  }

  Future<void> _move(int oldIndex, int newIndex) async {
    final before = [..._items];
    setState(() {
      _items.insert(newIndex, _items.removeAt(oldIndex));
    });
    try {
      await widget.onReorder(_items.map(widget.idOf).toList());
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _items = before);
      notify(
        context,
        failureText(AppLocalizations.of(context), e),
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            widget.emptyText ?? AppLocalizations.of(context).emptyList,
          ),
        ),
      );
    }
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _items.length,
      onReorderItem: _move,
      itemBuilder: (context, i) {
        final item = _items[i];
        return Row(
          key: ValueKey(widget.idOf(item)),
          children: [
            ReorderableDragStartListener(
              index: i,
              child: const Icon(Icons.drag_indicator),
            ),
            const SizedBox(width: 8),
            Expanded(child: widget.itemBuilder(context, item)),
          ],
        );
      },
    );
  }
}
