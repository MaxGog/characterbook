import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class UnsavedChangesDialog {
  final String? saveText;

  const UnsavedChangesDialog({this.saveText});

  Future<bool?> show(BuildContext context) async {
    final s = S.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(s.unsaved_changes_title),
        content: Text(s.unsaved_changes_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.discard_changes),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(saveText ?? s.save),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
        ],
      ),
    );
  }
}