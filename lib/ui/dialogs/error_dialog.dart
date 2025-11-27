import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showErrorDialog({
  required BuildContext context,
  required String message,
  String? title,
  String buttonText = 'OK',
  String reportButtonText = 'Сообщить об ошибке',
  bool barrierDismissible = true,
  Color? barrierColor,
  VoidCallback? onConfirmed,
  String supportEmail = 'max.gog2005@outlook.com',
  String emailSubject = 'Сообщение об ошибке',
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
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
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 20),
              if (title != null) ...[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _sendErrorReport(
                  context: context,
                  email: supportEmail,
                  subject: emailSubject,
                  errorMessage: message,
                );
              },
              child: Text(reportButtonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed?.call();
              },
              child: Text(buttonText),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        ),
      );
    },
  );
}

Future<void> _sendErrorReport({
  required BuildContext context,
  required String email,
  required String subject,
  required String errorMessage,
}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': subject,
      'body': 'Ошибка: $errorMessage\n\nОписание проблемы: ',
    },
  );

  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showEmailError(context);
    }
  } catch (e) {
    _showEmailError(context);
  }
}

void _showEmailError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Не удалось открыть почтовое приложение'),
    ),
  );
}
