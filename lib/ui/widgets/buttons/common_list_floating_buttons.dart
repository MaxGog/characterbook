import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class CommonListFloatingButtons extends StatefulWidget {
  final VoidCallback? onImport;
  final VoidCallback? onAdd;
  final bool showImportButton;
  final String? importTooltip;
  final String? addTooltip;
  final VoidCallback? onTemplate;
  final String? templateTooltip;
  final String? createFromScratchTooltip;
  final String heroTag;

  const CommonListFloatingButtons({
    super.key,
    this.onImport,
    this.onAdd,
    this.showImportButton = true,
    this.importTooltip,
    this.addTooltip,
    this.onTemplate,
    this.templateTooltip,
    this.createFromScratchTooltip,
    required this.heroTag,
  });

  @override
  State<CommonListFloatingButtons> createState() =>
      _CustomFloatingButtonsState();
}

class _CustomFloatingButtonsState extends State<CommonListFloatingButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  int get _actionCount {
    int count = 0;
    if (widget.onAdd != null) count++;
    if (widget.onImport != null && widget.showImportButton) count++;
    if (widget.onTemplate != null) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleAction(VoidCallback? action) {
    _toggleExpanded();
    if (action != null) {
      action();
    }
  }

  Widget _buildSingleActionButton() {
    final s = S.of(context);

    VoidCallback? onPressed;
    String tooltip = widget.addTooltip ?? s.create;

    if (widget.onAdd != null) {
      onPressed = widget.onAdd;
    } else if (widget.onImport != null && widget.showImportButton) {
      onPressed = widget.onImport;
      tooltip = widget.importTooltip ?? s.import;
    } else if (widget.onTemplate != null) {
      onPressed = widget.onTemplate;
      tooltip = widget.templateTooltip ?? s.template;
    }

    return FloatingActionButton(
      heroTag: '${widget.heroTag}_single',
      onPressed: onPressed,
      tooltip: tooltip,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.add_rounded),
    );
  }

  Widget _buildExpandedActions() {
    final s = S.of(context);

    final actions = <Widget>[];

    if (widget.onAdd != null) {
      actions.add(_buildActionItem(
        icon: Icons.create_rounded,
        label: widget.createFromScratchTooltip ?? s.create,
        tooltip: widget.createFromScratchTooltip ?? s.create,
        onTap: () => _handleAction(widget.onAdd),
        index: 0,
      ));
    }

    if (widget.showImportButton && widget.onImport != null) {
      actions.add(_buildActionItem(
        icon: Icons.download_rounded,
        label: widget.importTooltip ?? s.import,
        tooltip: widget.importTooltip ?? s.import_template_tooltip,
        onTap: () => _handleAction(widget.onImport),
        index: 1,
      ));
    }

    if (widget.onTemplate != null) {
      actions.add(_buildActionItem(
        icon: Icons.library_books_rounded,
        label: widget.templateTooltip ?? s.template,
        tooltip: widget.templateTooltip ?? s.create_from_template_tooltip,
        onTap: () => _handleAction(widget.onTemplate),
        index: 2,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: actions.reversed.toList(),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required String tooltip,
    required VoidCallback onTap,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.1 + (0.2 * index),
        1.0,
        curve: Curves.easeOut,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButton.small(
              heroTag: '${widget.heroTag}_action_$index',
              onPressed: onTap,
              tooltip: tooltip,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: Icon(icon),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FloatingActionButton(
      heroTag: '${widget.heroTag}_main',
      onPressed: _toggleExpanded,
      tooltip: widget.addTooltip ?? S.of(context).create,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor:
          _isExpanded ? colorScheme.secondary : colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: _isExpanded
            ? const Icon(Icons.close_rounded, key: ValueKey('close'))
            : const Icon(Icons.add_rounded, key: ValueKey('add')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_actionCount <= 1) {
      return _buildSingleActionButton();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildExpandedActions(),
        const SizedBox(height: 8),
        _buildMainButton(),
      ],
    );
  }
}
