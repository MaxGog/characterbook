import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin ListPageMixin<T extends StatefulWidget> on State<T> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FilePickerService filePickerService = FilePickerService();

  bool isSearching = false;
  bool isImporting = false;
  bool isFabVisible = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    searchController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (scrollController.position.atEdge) {
      final isTop = scrollController.position.pixels == 0;
      if (isTop) {
        setState(() => isFabVisible = true);
      }
      return;
    }

    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && isFabVisible) {
      setState(() => isFabVisible = false);
    } else if (direction == ScrollDirection.forward && !isFabVisible) {
      setState(() => isFabVisible = true);
    }
  }


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
