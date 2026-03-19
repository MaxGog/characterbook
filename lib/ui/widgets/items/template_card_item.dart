import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:flutter/material.dart';

import 'commod_card_item.dart';

class TemplateCardItem extends StatelessWidget {
  final QuestionnaireTemplate template;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMenuPressed;
  final bool enableDrag;
  final VoidCallback? onShare;
  final VoidCallback? onDuplicate;
  final VoidCallback? onSettings;

  const TemplateCardItem({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onMenuPressed,
    this.enableDrag = false,
    this.onShare,
    this.onDuplicate,
    this.onSettings
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final totalFields =
        template.standardFields.length + template.customFields.length;

    return CommonCardItem(
      id: template.key,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: enableDrag ? null : onLongPress,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTemplateIcon(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.of(context).fields_count(totalFields),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded,
                      color: colorScheme.onSurfaceVariant),
                  onPressed: onMenuPressed,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    Icons.checklist_rounded,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  label:
                      Text('${template.standardFields.length} ${s.standard}'),
                  backgroundColor: colorScheme.primaryContainer,
                ),
                Chip(
                  avatar: Icon(
                    Icons.edit_rounded,
                    size: 18,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  label: Text('${template.customFields.length} ${s.custom}'),
                  backgroundColor: colorScheme.tertiaryContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.library_books_rounded,
          color: colorScheme.primary, size: 24),
    );
  }
}
