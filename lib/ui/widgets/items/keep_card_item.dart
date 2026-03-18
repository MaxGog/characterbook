import 'package:flutter/material.dart';

class KeepCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final VoidCallback? onSecondaryTap;

  const KeepCard({
    super.key,
    required this.child,
    this.onTap,
    this.onEnter,
    this.onExit,
    this.onSecondaryTap,
  });

  @override
  State<KeepCard> createState() => _KeepCardState();
}

class _KeepCardState extends State<KeepCard> with TickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  void _handleTapDown(TapDownDetails details) => _tapController.forward();
  void _handleTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _tapController.reverse();
    });
  }

  void _handleTapCancel() {
    if (mounted) _tapController.reverse();
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => widget.onEnter?.call(),
      onExit: (_) => widget.onExit?.call(),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onSecondaryTap: widget.onSecondaryTap,
        child: AnimatedBuilder(
          animation: _tapController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              constraints: const BoxConstraints(
                minWidth: 160,
                minHeight: 160,
                maxWidth: 180,
                maxHeight: 180,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8.0 * _elevationAnimation.value,
                    offset: Offset(0, 2.0 * _elevationAnimation.value),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: widget.onTap,
                  onSecondaryTap: widget.onSecondaryTap,
                  splashColor: colorScheme.primary.withOpacity(0.2),
                  highlightColor: colorScheme.primary.withOpacity(0.1),
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
