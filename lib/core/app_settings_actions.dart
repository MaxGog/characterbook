import 'package:flutter/foundation.dart';

enum SwipeAction {
  edit,
  delete,
  share,
  duplicate,
  settings,
}

abstract interface class SwipeActionSettingsActions implements Listenable {
  SwipeAction get leftAction;
  SwipeAction get rightAction;

  Future<void> setLeftAction(SwipeAction action);
  Future<void> setRightAction(SwipeAction action);
}
