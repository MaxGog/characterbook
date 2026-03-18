import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'keep_card_item.dart';

typedef FlipSideBuilder = Widget Function(
  BuildContext context,
  ThemeData theme,
  ColorScheme colorScheme,
  double flipValue,
  bool isFrontSide,
);

class FlipKeepCard extends StatefulWidget {
  final FlipSideBuilder frontBuilder;
  final FlipSideBuilder backBuilder;
  final VoidCallback? onTap;
  final VoidCallback? onContextMenuTap;
  final bool autoFlipEnabled;
  final Duration autoFlipInterval;

  const FlipKeepCard({
    super.key,
    required this.frontBuilder,
    required this.backBuilder,
    this.onTap,
    this.onContextMenuTap,
    this.autoFlipEnabled = true,
    this.autoFlipInterval = const Duration(seconds: 10),
  });

  @override
  State<FlipKeepCard> createState() => _FlipKeepCardState();
}

class _FlipKeepCardState extends State<FlipKeepCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  Timer? _flipTimer;
  bool _isFront = true;
  bool _isHovering = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    if (widget.autoFlipEnabled) _startAutoFlip();
  }

  void _startAutoFlip() {
    _flipTimer?.cancel();
    final random = Random();
    final initialDelay = Duration(seconds: random.nextInt(15) + 5);
    _flipTimer = Timer(initialDelay, () {
      if (mounted) _scheduleNextFlip();
    });
  }

  void _scheduleNextFlip() {
    _flipTimer?.cancel();
    _flipTimer = Timer.periodic(widget.autoFlipInterval, (timer) {
      if (mounted && !_isHovering && !_isAnimating) _flipCard();
    });
  }

  void _flipCard() {
    if (_isAnimating) return;
    _isAnimating = true;
    final target = !_isFront;

    (target ? _flipController.forward() : _flipController.reverse()).then((_) {
      if (mounted) _scheduleAutoReverse();
    });

    setState(() => _isFront = target);
  }

  void _scheduleAutoReverse() {
    Timer(const Duration(seconds: 5), () {
      if (mounted && !_isHovering && !_isAnimating) {
        _flipCard();
      } else {
        _isAnimating = false;
      }
    });
  }

  void _onEnter() {
    setState(() => _isHovering = true);
    _flipTimer?.cancel();
  }

  void _onExit() {
    setState(() => _isHovering = false);
    if (widget.autoFlipEnabled) _scheduleNextFlip();
  }

  @override
  void dispose() {
    _flipTimer?.cancel();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeepCard(
      onTap: widget.onTap,
      onEnter: _onEnter,
      onExit: _onExit,
      onSecondaryTap: widget.onContextMenuTap,
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, _) {
          return Stack(
            children: [
              Opacity(
                opacity: _flipAnimation.value <= 0.5 ? 1.0 : 0.0,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * 3.14159),
                  alignment: Alignment.center,
                  child: _buildSide(isFront: true),
                ),
              ),
              Opacity(
                opacity: _flipAnimation.value > 0.5 ? 1.0 : 0.0,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY((_flipAnimation.value - 1) * 3.14159),
                  alignment: Alignment.center,
                  child: _buildSide(isFront: false),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSide({required bool isFront}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return isFront
            ? widget.frontBuilder(
                context, theme, colorScheme, _flipAnimation.value, true)
            : widget.backBuilder(
                context, theme, colorScheme, _flipAnimation.value, false);
      },
    );
  }
}
