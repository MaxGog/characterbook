import 'package:characterbook/ui/dialogs/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

mixin UnsavedChangesHandler<T extends StatefulWidget> on State<T> {
  bool _hasUnsavedChanges = false;

  @protected
  void set hasUnsavedChanges(bool value) => _hasUnsavedChanges = value;

  @protected
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  Future<bool> handleUnsavedChanges(BuildContext context, {String? saveText}) async {
    if (!_hasUnsavedChanges) return true;
    
    final shouldSave = await UnsavedChangesDialog(saveText: saveText).show(context);
    if (shouldSave == null) return false;
    if (shouldSave) await saveChanges();
    return true;
  }

  @protected
  Future<void> saveChanges();
}