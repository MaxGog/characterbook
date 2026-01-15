import 'package:flutter/material.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/generated/l10n.dart';
import 'dart:async';
import 'dart:math';

class RaceKeepCard extends StatefulWidget {
  final Race race;
  final int characterCount;
  final VoidCallback onTap;
  final VoidCallback onContextMenuTap;

  const RaceKeepCard({
    super.key,
    required this.race,
    required this.characterCount,
    required this.onTap,
    required this.onContextMenuTap,
  });

  @override
  State<RaceKeepCard> createState() => _RaceKeepCardState();
}

class _RaceKeepCardState extends State<RaceKeepCard>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late AnimationController _flipController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _flipAnimation;
  Timer? _flipTimer;
  bool _isFront = true;
  bool _isHovering = false;
  bool _isAnimating = false;

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

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    final random = Random();
    final initialDelay = Duration(seconds: random.nextInt(15) + 5);

    _flipTimer = Timer(initialDelay, () {
      if (mounted) {
        _startAutoFlip();
      }
    });
  }

  void _startAutoFlip() {
    _flipTimer?.cancel();
    _flipTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted && !_isHovering && !_isAnimating) {
        _flipCard();
      }
    });
  }

  void _flipCard() {
    if (_isAnimating) return;

    _isAnimating = true;

    if (_isFront) {
      _flipController.forward().then((_) {
        if (mounted) {
          Timer(const Duration(seconds: 5), () {
            if (mounted && !_isHovering) {
              _flipController.reverse().then((_) {
                if (mounted) {
                  _isAnimating = false;
                }
              });
            } else {
              _isAnimating = false;
            }
          });
        }
      });
    } else {
      _flipController.reverse().then((_) {
        if (mounted) {
          Timer(const Duration(seconds: 5), () {
            if (mounted && !_isHovering) {
              _flipController.forward().then((_) {
                if (mounted) {
                  _isAnimating = false;
                }
              });
            } else {
              _isAnimating = false;
            }
          });
        }
      });
    }

    setState(() {
      _isFront = !_isFront;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    _tapController.forward();
  }

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
    _flipTimer?.cancel();
    _tapController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  Widget _buildFrontSide(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AnimatedOpacity(
      opacity: _flipAnimation.value <= 0.5 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_flipAnimation.value * 3.14159),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: widget.race.logo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              widget.race.logo!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.people_rounded,
                              size: 32.0,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                  ),
                  Text(
                    widget.race.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 12.0,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          '${widget.characterCount}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          S.of(context).characters.toLowerCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSide(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AnimatedOpacity(
      opacity: _flipAnimation.value > 0.5 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY((_flipAnimation.value - 1) * 3.14159),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme
                .secondaryContainer,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.0,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    S.of(context).description,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.race.description.isNotEmpty
                            ? widget.race.description
                            : S.of(context).no_description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.0,
                          color:
                              colorScheme.onSecondaryContainer.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: 8,
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 12.0),
                      if (widget.race.tags.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).tags,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10.0,
                                color: colorScheme.onSecondaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: widget.race.tags
                                  .take(4)
                                  .map((tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondary
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: colorScheme.secondary
                                                .withOpacity(0.3),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            fontSize: 10.0,
                                            color: colorScheme
                                                .onSecondaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.flip_rounded,
                  size: 14.0,
                  color: colorScheme.onSecondaryContainer.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
          _startAutoFlip();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_tapController, _flipController]),
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
                borderRadius: BorderRadius.circular(4.0),
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
                borderRadius: BorderRadius.circular(4.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: widget.onTap,
                  splashColor: colorScheme.primary.withOpacity(0.2),
                  highlightColor: colorScheme.primary.withOpacity(0.1),
                  child: Stack(
                    children: [
                      _buildFrontSide(context, theme, colorScheme),
                      _buildBackSide(context, theme, colorScheme),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
