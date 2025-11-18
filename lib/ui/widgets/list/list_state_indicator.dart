import 'package:flutter/material.dart';

class ListStateIndicator extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onErrorClose;

  const ListStateIndicator({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.onErrorClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) const _LoadingIndicator(),
        if (errorMessage != null)
          _ErrorMessage(
            message: errorMessage!,
            onClose: onErrorClose,
          ),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator();
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const _ErrorMessage({
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.error, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.onErrorContainer),
              onPressed: onClose,
              iconSize: 20,
            ),
        ],
      ),
    );
  }
}