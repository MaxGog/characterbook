import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';

class BuildSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const BuildSection({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context),
        if (isExpanded) ...[
          _buildSelectableContent(context),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onToggleExpand,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableContent(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        content.isNotEmpty ? content : S.of(context).no_information,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}