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

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2) , weight: 2),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 2),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).colorScheme.primary,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
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
      
      // Start animation
      _animationController.forward(from: 0);
      
      // Simulate "thinking" delay
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _generatedNumber = _minValue + Random().nextInt(_maxValue - _minValue + 1);
        });
      });
      
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Number Generator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'Select a range and generate random numbers within that range.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
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
              // Header
              Text(
                'Select Range',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose the minimum and maximum values for your random number',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Range selection cards
              Row(
                children: [
                  Expanded(
                    child: _RangeCard(
                      title: 'Minimum',
                      value: _minValue,
                      onChanged: (value) => setState(() => _minValue = value),
                      validator: (value) {
                        if (value == null) return 'Enter a number';
                        if (value >= _maxValue) {
                          return 'Must be less than maximum';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _RangeCard(
                      title: 'Maximum',
                      value: _maxValue,
                      onChanged: (value) => setState(() => _maxValue = value),
                      validator: (value) {
                        if (value == null) return 'Enter a number';
                        if (value <= _minValue) {
                          return 'Must be greater than minimum';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Generated number display
              Text(
                'Generated Number',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
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
                                    child: Text(
                                      '$_generatedNumber',
                                      style: textTheme.displayLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  '?',
                                  style: textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface.withOpacity(0.2),
                                  ),
                                ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Generate button
              FilledButton(
                onPressed: _generateRandomNumber,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
                child: const Text(
                  'Generate Random Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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

class _RangeCard extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;
  final FormFieldValidator<int?> validator;

  const _RangeCard({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: value.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  onChanged(int.parse(value));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter a number';
                return validator(int.tryParse(value));
              },
            ),
            const SizedBox(height: 8),
            Slider(
              value: value.toDouble(),
              min: title == 'Minimum' ? -1000 : _getMinMaxValue(context),
              max: title == 'Maximum' ? 1000 : _getMinMaxValue(context),
              divisions: 100,
              label: value.toString(),
              onChanged: (value) => onChanged(value.toInt()),
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.primary.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  double _getMinMaxValue(BuildContext context) {
    final state = context.findAncestorStateOfType<_RandomNumberPageState>();
    return title == 'Minimum'
        ? (state?._maxValue.toDouble() ?? 100) - 1
        : (state?._minValue.toDouble() ?? 0) + 1;
  }
}