import 'dart:math';

import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/character_model.dart';
import 'dart:async';

class CharacterKeepCard extends StatefulWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onContextMenuTap;
  final String formattedDate;

  const CharacterKeepCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onContextMenuTap,
    required this.formattedDate,
  });

  @override
  State<CharacterKeepCard> createState() => _CharacterKeepCardState();
}

class _CharacterKeepCardState extends State<CharacterKeepCard>
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

  Widget _buildFrontSide(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, bool hasImage) {
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
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.memory(
                    widget.character.imageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.character.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),

                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.character.race != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_rounded,
                                  size: 12.0,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(
                                    widget.character.race!.name,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                          if (widget.character.age > 0)
                            Padding(
                              padding: EdgeInsets.only(
                                top: widget.character.race != null ? 4.0 : 0.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cake_rounded,
                                    size: 12.0,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Flexible(
                                    child: Text(
                                      '${widget.character.age}',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6.0),
                    Text(
                      widget.formattedDate,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            color: colorScheme.primaryContainer,
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
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    S.of(context).information,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              if (widget.character.tags.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).tags,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: widget.character.tags
                          .take(3)
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 3.0,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10.0,
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).last_updated,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.0,
                          color:
                              colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.formattedDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.0,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (widget.character.race != null) ...[
                        Text(
                          S.of(context).race,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10.0,
                            color:
                                colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          widget.character.race!.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.0,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
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
                  color: colorScheme.onPrimaryContainer.withOpacity(0.5),
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
    final hasImage = widget.character.imageBytes != null;

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
                      _buildFrontSide(context, theme, colorScheme, hasImage),
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
