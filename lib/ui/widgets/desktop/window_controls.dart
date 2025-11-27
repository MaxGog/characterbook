import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

enum WindowAction { minimize, toggleMaximize, close }

class WindowControls extends StatelessWidget {
  const WindowControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        WindowControlButton(
          action: WindowAction.close,
        ),
        SizedBox(width: 10),
        WindowControlButton(
          action: WindowAction.minimize,
        ),
        SizedBox(width: 10),
        WindowControlButton(
          action: WindowAction.toggleMaximize,
        ),
      ],
    );
  }
}

class WindowControlButton extends StatefulWidget {
  const WindowControlButton({
    super.key,
    required this.action,
  });

  final WindowAction action;

  @override
  State<WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<WindowControlButton> {
  bool _isHovered = false;

  Future<void> _handleAction() async {
    try {
      switch (widget.action) {
        case WindowAction.minimize:
          await windowManager.minimize();
          break;
        case WindowAction.toggleMaximize:
          final isMaximized = await windowManager.isMaximized();
          if (isMaximized) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
          break;
        case WindowAction.close:
          await windowManager.close();
          break;
      }
    } catch (error) {
      debugPrint('Window action error: $error');
    }
  }

  Color _getColor(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    switch (widget.action) {
      case WindowAction.close:
        return _isHovered
            ? const Color(0xFF5C5C5C)
            : isDark
                ? const Color(0xFFE74C3C)
                : const Color(0xFFCFCFCF);
      case WindowAction.minimize:
        return _isHovered
            ? const Color(0xFF5C5C5C)
            : isDark
                ? const Color(0xFFF39C12)
                : const Color(0xFFCFCFCF);
      case WindowAction.toggleMaximize:
        return _isHovered
            ? const Color(0xFF5C5C5C)
            : isDark
                ? const Color(0xFF27AE60)
                : const Color(0xFFCFCFCF);
    }
  }

  Widget _getIcon(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = _isHovered
        ? Colors.white
        : isDark
            ? const Color(0xFF8E8E8E)
            : const Color(0xFF7A7A7A);

    switch (widget.action) {
      case WindowAction.close:
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
        );
      case WindowAction.minimize:
        return Container(
          width: 6,
          height: 2,
          color: iconColor,
        );
      case WindowAction.toggleMaximize:
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: iconColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleAction,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: _getColor(theme),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: _getIcon(theme),
          ),
        ),
      ),
    );
  }
}
