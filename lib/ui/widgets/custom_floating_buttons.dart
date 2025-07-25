import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class CustomFloatingButtons extends StatefulWidget {
  final VoidCallback? onImport;
  final VoidCallback? onAdd;
  final bool showImportButton;
  final String? importTooltip;
  final String? addTooltip;
  final VoidCallback? onTemplate;
  final String? templateTooltip;
  final String? createFromScratchTooltip;

  const CustomFloatingButtons({
    super.key,
    this.onImport,
    this.onAdd,
    this.showImportButton = true,
    this.importTooltip,
    this.addTooltip,
    this.onTemplate,
    this.templateTooltip,
    this.createFromScratchTooltip,
  });

  @override
  State<CustomFloatingButtons> createState() => _CustomFloatingButtonsState();
}

class _CustomFloatingButtonsState extends State<CustomFloatingButtons> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _translateAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<Color?> _fabColorAnimation;

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
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _translateAnimation = Tween<double>(begin: 80, end: 0).animate(curvedAnimation);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(curvedAnimation);
    _fabScaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(curvedAnimation);
    
    _fabColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    _fabColorAnimation = ColorTween(
      begin: theme.colorScheme.primaryContainer,
      end: theme.colorScheme.secondaryContainer,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
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

  Widget _buildActionButton({
    required String heroTag,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required String tooltip,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_translateAnimation.value * (index + 1)),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isExpanded) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16),
                      right: Radius.circular(32)),
                  ),
                  shadows: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            FloatingActionButton(
              heroTag: heroTag,
              onPressed: () {
                _toggleExpanded();
                onPressed();
              },
              mini: true,
              tooltip: tooltip,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
              elevation: 3,
              highlightElevation: 6,
              backgroundColor: colorScheme.tertiaryContainer,
              foregroundColor: colorScheme.onTertiaryContainer,
              child: Icon(icon, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_actionCount <= 1) {
      return FloatingActionButton(
        heroTag: 'single_action_btn',
        tooltip: widget.addTooltip ?? s.create,
        onPressed: () {
          if (widget.onAdd != null) {
            widget.onAdd!();
          } else if (widget.onImport != null && widget.showImportButton) {
            widget.onImport!();
          } else if (widget.onTemplate != null) {
            widget.onTemplate!();
          }
        },
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
        elevation: 4,
        highlightElevation: 8,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        child: const Icon(Icons.add_rounded, size: 28),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isExpanded && widget.onAdd != null)
          _buildActionButton(
            heroTag: 'create_btn',
            onPressed: widget.onAdd!,
            icon: Icons.create_rounded,
            label: widget.createFromScratchTooltip ?? s.create,
            tooltip: widget.createFromScratchTooltip ?? s.create,
            index: 0,
          ),
        if (_isExpanded && widget.showImportButton && widget.onImport != null)
          _buildActionButton(
            heroTag: 'import_btn',
            onPressed: widget.onImport!,
            icon: Icons.download_rounded,
            label: widget.importTooltip ?? s.import,
            tooltip: widget.importTooltip ?? s.import_template_tooltip,
            index: 1,
          ),
        if (_isExpanded && widget.onTemplate != null)
          _buildActionButton(
            heroTag: 'template_btn',
            onPressed: widget.onTemplate!,
            icon: Icons.library_books_rounded,
            label: widget.templateTooltip ?? s.template,
            tooltip: widget.templateTooltip ?? s.create_from_template_tooltip,
            index: 2,
          ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _fabScaleAnimation.value,
              child: FloatingActionButton(
                heroTag: 'main_btn',
                tooltip: widget.addTooltip ?? s.create,
                onPressed: _toggleExpanded,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
                elevation: 4,
                highlightElevation: 8,
                backgroundColor: _fabColorAnimation.value,
                foregroundColor: colorScheme.onSecondaryContainer,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeInOutCubicEmphasized,
                  switchOutCurve: Curves.easeInOutCubicEmphasized,
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                      child: ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _isExpanded
                      ? Icon(Icons.close_rounded, 
                          key: const ValueKey('close'), size: 28)
                      : Icon(Icons.add_rounded, 
                          key: const ValueKey('add'), size: 28),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}