import 'package:characterbook/core/app_notification_actions.dart';
import 'package:flutter/material.dart';

class OverlayNotificationService implements AppNotificationActions {
  final GlobalKey<NavigatorState> navigatorKey;

  const OverlayNotificationService({required this.navigatorKey});

  @override
  void showNotification(
    String message, {
    AppNotificationType type = AppNotificationType.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final overlay = navigator.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _NotificationWidget(
        message: message,
        type: type,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }
}

class _NotificationWidget extends StatefulWidget {
  final String message;
  final AppNotificationType type;
  final VoidCallback onDismiss;

  const _NotificationWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor(ThemeData theme, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.success:
        return theme.colorScheme.primaryContainer;
      case AppNotificationType.error:
        return theme.colorScheme.errorContainer;
      case AppNotificationType.info:
        return theme.colorScheme.secondaryContainer;
    }
  }

  Color _textColor(ThemeData theme, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.success:
        return theme.colorScheme.onPrimaryContainer;
      case AppNotificationType.error:
        return theme.colorScheme.onErrorContainer;
      case AppNotificationType.info:
        return theme.colorScheme.onSecondaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onDismiss,
                ),
              ),
              Positioned(
                bottom: bottomPadding,
                left: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            color: _backgroundColor(theme, widget.type),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(left: 170, right: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: _textColor(theme, widget.type),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: -87,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset(
                            'assets/maxupshur.png',
                            height: 150,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.check_circle,
                              color: _textColor(theme, widget.type),
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
