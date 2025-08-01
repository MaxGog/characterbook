import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RandomNumberPage extends StatefulWidget {
  const RandomNumberPage({super.key});

  @override
  State<RandomNumberPage> createState() => _RandomNumberPageState();
}

class _RandomNumberPageState extends State<RandomNumberPage>
    with SingleTickerProviderStateMixin {
  int _minValue = 0;
  int _maxValue = 100;
  int? _generatedNumber;
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.3), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeInOutCubic),
      ),
    );
    
    _shakeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 1),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.surfaceContainerHighest,
      end: Theme.of(context).colorScheme.primaryContainer,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateRandomNumber() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _generatedNumber = null;
      });
      
      _animationController.forward(from: 0);
      
      final delay = 300 + Random().nextInt(700);
      Future.delayed(Duration(milliseconds: delay), () {
        setState(() {
          _generatedNumber = _minValue + Random().nextInt(_maxValue - _minValue + 1);
        });
      });
      
      HapticFeedback.mediumImpact();
    }
  }

  void _validateRange() {
    if (_minValue >= _maxValue) {
      if (_minValue > 0) {
        setState(() => _maxValue = _minValue + 1);
      } else {
        setState(() => _minValue = _maxValue - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Random Number Generator',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Play',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '1. Set your number range using the wheels\n'
                        '2. Press the "Generate" button\n'
                        '3. Get your random number with fun animation!\n\n'
                        'Try to guess the number before it appears!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Got it!'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s Play!',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Spin the wheels to set your range',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'SELECT RANGE',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberWheel(
                            key: ValueKey('min_wheel'),
                            title: 'From',
                            initialValue: _minValue,
                            min: -999,
                            max: _maxValue - 1,
                            onChanged: (value) {
                              setState(() => _minValue = value);
                              _validateRange();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NumberWheel(
                            key: ValueKey('max_wheel'),
                            title: 'To',
                            initialValue: _maxValue,
                            min: _minValue + 1,
                            max: 9999,
                            onChanged: (value) {
                              setState(() => _maxValue = value);
                              _validateRange();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value * 50, 0),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _generatedNumber == null && _animationController.isAnimating
                            ? AnimatedNumberPlaceholder(
                                animation: _animationController,
                                colorAnimation: _colorAnimation,
                              )
                            : _generatedNumber != null
                                ? ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Your number is',
                                            style: textTheme.titleLarge?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            '$_generatedNumber',
                                            style: textTheme.displayLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onPrimaryContainer,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        'Ready to play?',
                                        style: textTheme.titleLarge?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '?',
                                        style: textTheme.displayLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface.withOpacity(0.1),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              FilledButton.tonal(
                onPressed: _generateRandomNumber,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.casino,
                      size: 24,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Generate Random Number',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Try to guess the number before it appears!',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedNumberPlaceholder extends StatelessWidget {
  final Animation<double> animation;
  final Animation<Color?> colorAnimation;

  const AnimatedNumberPlaceholder({
    super.key,
    required this.animation,
    required this.colorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                Colors.grey.shade300,
                colorAnimation.value ?? Colors.grey,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(rect);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            '•••',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
          ),
        );
      },
    );
  }
}

class _NumberWheel extends StatefulWidget {
  final String title;
  final int initialValue;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberWheel({
    super.key,
    required this.title,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<_NumberWheel> {
  late FixedExtentScrollController _scrollController;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.min, widget.max);
    _scrollController = FixedExtentScrollController(
      initialItem: _currentValue - widget.min,
    );
  }

  @override
  void didUpdateWidget(covariant _NumberWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.min != oldWidget.min || widget.max != oldWidget.max) {
      _currentValue = _currentValue.clamp(widget.min, widget.max);
      _scrollController.jumpToItem(_currentValue - widget.min);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemCount = widget.max - widget.min + 1;
    final items = List.generate(itemCount, (index) => widget.min + index);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.2),
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.primaryContainer.withOpacity(0.4),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: colorScheme.primaryContainer.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ListWheelScrollView(
                controller: _scrollController,
                itemExtent: 48,
                perspective: 0.01,
                diameterRatio: 1.8,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  final value = items[index];
                  setState(() => _currentValue = value);
                  widget.onChanged(value);
                },
                children: items.map((number) {
                  final isSelected = number == _currentValue;
                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: isSelected
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: isSelected ? 26 : 22,
                          ),
                      child: Text(number.toString()),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}