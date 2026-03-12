import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

extension DateTimeFormatting on DateTime {
  String toRelativeString(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(this);
    final s = S.of(context);

    if (difference.inDays == 0) {
      return s.just_now;
    } else if (difference.inDays == 1) {
      return s.days_ago(1);
    } else if (difference.inDays < 7) {
      return s.days_ago(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${s.week}';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${s.month}';
    }
  }
}
