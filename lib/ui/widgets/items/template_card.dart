import 'dart:math';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/characters/template_model.dart';
import 'package:flutter/material.dart';

class TemplateCard extends StatelessWidget {
  final QuestionnaireTemplate template;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMenuPressed;
  final bool enableDrag;

  const TemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onMenuPressed,
    this.enableDrag = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final random = Random(template.name.hashCode);
    
    final borderRadius = 20.0 + random.nextInt(4);
    final elevation = isSelected ? 4.0 : 2.0;
    final colorVariation = random.nextDouble() * 0.05;

    final backgroundColor = isSelected 
        ? colorScheme.secondaryContainer.withOpacity(0.9 + colorVariation)
        : colorScheme.surfaceContainerHigh.withOpacity(0.95 + colorVariation);

    final totalFields = template.standardFields.length + template.customFields.length;
    final hasManyFields = totalFields > 8;

    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: elevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        onLongPress: enableDrag ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTemplateIcon(context, random),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
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
              
              const SizedBox(height: 16),
              
              _buildQuickStats(context, totalFields),
              
              const SizedBox(height: 12),
              
              _buildFieldsPreview(context, hasManyFields),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateIcon(BuildContext context, Random random) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconOptions = [
      Icons.library_books_rounded,
      Icons.description_rounded,
      Icons.format_list_bulleted_rounded,
      Icons.auto_awesome_mosaic_rounded,
      Icons.dashboard_rounded,
      Icons.view_quilt_rounded,
    ];
    
    final colorOptions = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
    ];

    final icon = iconOptions[random.nextInt(iconOptions.length)];
    final color = colorOptions[random.nextInt(colorOptions.length)];

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildQuickStats(BuildContext context, int totalFields) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Row(
      children: [
        _buildStatChip(
          context,
          icon: Icons.checklist_rounded,
          value: template.standardFields.length,
          label: s.standard,
          color: colorScheme.primaryContainer,
          iconColor: colorScheme.onPrimaryContainer,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          context,
          icon: Icons.edit_rounded,
          value: template.customFields.length,
          label: s.custom,
          color: colorScheme.tertiaryContainer,
          iconColor: colorScheme.onTertiaryContainer,
        ),
        const Spacer(),
        if (totalFields > 15)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.star_rounded, 
                  size: 16, 
                  color: colorScheme.onSecondaryContainer),
                const SizedBox(width: 4),
                Text(
                  s.detailed,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required int value,
    required String label,
    required Color color,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsPreview(BuildContext context, bool hasManyFields) {
    Theme.of(context);
    final allFieldNames = [
      ...template.standardFields,
      ...template.customFields.map((f) => f.key),
    ];

    final displayFields = hasManyFields 
        ? allFieldNames.take(6).toList()
        : allFieldNames;

    return Container(
      height: 40,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: displayFields.length + (hasManyFields ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (hasManyFields && index == displayFields.length) {
              return _buildMoreIndicator(context, allFieldNames.length - 6);
            }
            
            final fieldName = displayFields[index];
            final isStandard = index < template.standardFields.length;
            
            return _buildFieldTag(
              context,
              fieldName,
              isStandard: isStandard,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldTag(BuildContext context, String fieldName, {bool isStandard = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isStandard 
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStandard 
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.tertiary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isStandard ? Icons.check_circle_rounded : Icons.add_circle_rounded,
            size: 14,
            color: isStandard 
                ? colorScheme.primary 
                : colorScheme.tertiary,
          ),
          const SizedBox(width: 6),
          Text(
            fieldName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreIndicator(BuildContext context, int remainingCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.more_horiz_rounded, 
            size: 14, 
            color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            s.more_fields(remainingCount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}