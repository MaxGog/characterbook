import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:characterbook/data/models/swipe_action.dart';

class SwipeActionSettingsProvider extends ChangeNotifier {
  static const String _leftActionKey = 'swipe_left_action';
  static const String _rightActionKey = 'swipe_right_action';

  SwipeAction _leftAction = SwipeAction.edit;
  SwipeAction _rightAction = SwipeAction.settings;

  SwipeAction get leftAction => _leftAction;
  SwipeAction get rightAction => _rightAction;

  SwipeActionSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final leftIndex = prefs.getInt(_leftActionKey);
    final rightIndex = prefs.getInt(_rightActionKey);
    if (leftIndex != null &&
        leftIndex >= 0 &&
        leftIndex < SwipeAction.values.length) {
      _leftAction = SwipeAction.values[leftIndex];
    }
    if (rightIndex != null &&
        rightIndex >= 0 &&
        rightIndex < SwipeAction.values.length) {
      _rightAction = SwipeAction.values[rightIndex];
    }
    notifyListeners();
  }

  Future<void> setLeftAction(SwipeAction action) async {
    if (_leftAction == action) return;
    _leftAction = action;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_leftActionKey, action.index);
    notifyListeners();
  }

  Future<void> setRightAction(SwipeAction action) async {
    if (_rightAction == action) return;
    _rightAction = action;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_rightActionKey, action.index);
    notifyListeners();
  }
}
