import 'package:flutter/material.dart';

class OptimizedListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Future<void> Function(int, int) onReorder;
  final ScrollController scrollController;
  final bool enableReorder;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    required this.scrollController,
    this.enableReorder = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableReorder) {
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      onReorder: (oldIndex, newIndex) async {
        if (oldIndex < newIndex) newIndex -= 1;
        await onReorder(oldIndex, newIndex);
      },
      scrollController: scrollController,
    );
  }
}