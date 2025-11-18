import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class BaseListPage<T> extends StatefulWidget {
  final String boxName;
  final String titleKey;
  
  const BaseListPage({
    super.key,
    required this.boxName,
    required this.titleKey,
  });
}

abstract class BaseListPageState<T, W extends BaseListPage<T>> extends State<W> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  bool isSearching = false;
  bool isImporting = false;
  bool isFabVisible = true;
  String? errorMessage;
  String? selectedTag;
  
  List<T> filteredItems = [];
  
  List<String> getTags(List<T> items);
  bool matchesSearch(T item, String query);
  bool matchesTagFilter(T item, String? tag);
  Widget buildItemCard(T item, int index);
  Future<void> importItem();
  Future<void> deleteItem(T item);
  Future<void> reorderItems(int oldIndex, int newIndex);
  void navigateToEdit(T item);
  void navigateToCreate();
  
  void filterItems(String query, List<T> allItems) {
    setState(() {
      filteredItems = allItems.where((item) {
        var matchesSearch;
        matchesSearch = query.isEmpty || matchesSearch(item, query);
        final matchesTag = selectedTag == null || matchesTagFilter(item, selectedTag);
        return matchesSearch && matchesTag;
      }).toList();
    });
  }
  
  void onSearchChanged(String query, List<T> allItems) {
    filterItems(query, allItems);
  }
  
  void onTagSelected(String? tag, List<T> allItems) {
    setState(() => selectedTag = tag);
    filterItems(searchController.text, allItems);
  }
  
  Future<bool> showDeleteConfirmation(String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
  
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    final isScrollingDown = scrollController.position.userScrollDirection == 
        ScrollDirection.reverse;
    if (isScrollingDown && isFabVisible) {
      setState(() => isFabVisible = false);
    } else if (!isScrollingDown && !isFabVisible) {
      setState(() => isFabVisible = true);
    }
  }
}