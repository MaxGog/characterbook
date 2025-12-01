import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class FullscreenFieldPreview extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final int maxPreviewLines;

  const FullscreenFieldPreview({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.maxPreviewLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_full_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value.isEmpty ? '${s.edit}...' : value,
              maxLines: maxPreviewLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: value.isEmpty
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface,
                fontStyle: value.isEmpty ? FontStyle.italic : null,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (value.isNotEmpty && _getLineCount(value) > maxPreviewLines)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '...',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getLineCount(String text) {
    return text.split('\n').length;
  }
}