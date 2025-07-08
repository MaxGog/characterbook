import 'package:flutter/material.dart';

void showLoadingDialog({
  required BuildContext context,
  required String message,
  bool barrierDismissible = false,
  Color? barrierColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Theme.of(context).colorScheme.scrim,
    builder: (BuildContext context) {
      return PopScope(
        canPop: barrierDismissible,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}