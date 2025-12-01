import 'dart:math';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/appbar/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RandomNumberPage extends StatefulWidget {
  const RandomNumberPage({super.key});

  @override
  State<RandomNumberPage> createState() => _RandomNumberPageState();
}

class _RandomNumberPageState extends State<RandomNumberPage> {
  int _minValue = 0;
  int _maxValue = 100;
  int? _generatedNumber;
  bool _isGenerating = false;

  void _generateRandomNumber() {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generatedNumber = null;
    });

    HapticFeedback.mediumImpact();

    final random = Random();
    final delay = 300 + random.nextInt(700);

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          _generatedNumber =
              _minValue + random.nextInt(_maxValue - _minValue + 1);
          _isGenerating = false;
        });
      }
    });
  }

  void _updateMinValue(int value) {
    setState(() {
      _minValue = value;
      if (_minValue >= _maxValue) {
        _maxValue = _minValue + 1;
      }
    });
  }

  void _updateMaxValue(int value) {
    setState(() {
      _maxValue = value;
      if (_maxValue <= _minValue) {
        _minValue = _maxValue - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = S.of(context);

    return Scaffold(
      appBar: CommonAppBar.standard(
        context: context,
        title: l10n.randomNumberGenerator,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    l10n.selectRange,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _NumberSelector(
                          title: l10n.from,
                          value: _minValue,
                          min: -999,
                          max: 999,
                          onChanged: _updateMinValue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _NumberSelector(
                          title: l10n.to,
                          value: _maxValue,
                          min: -999,
                          max: 999,
                          onChanged: _updateMaxValue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_minValue > -999) {
                            _updateMinValue(_minValue - 1);
                          }
                        },
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller:
                              TextEditingController(text: _minValue.toString()),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (value) {
                            final intValue = int.tryParse(value);
                            if (intValue != null &&
                                intValue >= -999 &&
                                intValue < _maxValue) {
                              _updateMinValue(intValue);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '-',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller:
                              TextEditingController(text: _maxValue.toString()),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (value) {
                            final intValue = int.tryParse(value);
                            if (intValue != null &&
                                intValue <= 999 &&
                                intValue > _minValue) {
                              _updateMaxValue(intValue);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_maxValue < 999) {
                            _updateMaxValue(_maxValue + 1);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: _isGenerating
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimaryContainer,
                          ),
                          strokeWidth: 4,
                        ),
                      )
                    : _generatedNumber != null
                        ? Text(
                            '$_generatedNumber',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 64,
                            ),
                          )
                        : Text(
                            '?',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer.withOpacity(0.3),
                              fontSize: 64,
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _generateRandomNumber,
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.casino),
                  const SizedBox(width: 12),
                  Text(_isGenerating ? l10n.generating : l10n.generateNumber,),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _minValue = 0;
                  _maxValue = 100;
                  _generatedNumber = null;
                });
              },
              child: Text(l10n.default_settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberSelector extends StatefulWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberSelector({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_NumberSelector> createState() => __NumberSelectorState();
}

class __NumberSelectorState extends State<_NumberSelector> {
  late FixedExtentScrollController _controller;
  late List<int> _items;

  @override
  void initState() {
    super.initState();
    _items = List.generate(
      widget.max - widget.min + 1,
      (index) => widget.min + index,
    );
    final initialIndex =
        _items.indexOf(widget.value).clamp(0, _items.length - 1);
    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void didUpdateWidget(_NumberSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final index = _items.indexOf(widget.value);
      if (index >= 0 && index < _items.length) {
        _controller.animateToItem(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 40,
            diameterRatio: 1.8,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (index >= 0 && index < _items.length) {
                widget.onChanged(_items[index]);
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= _items.length) return null;
                final number = _items[index];
                final isSelected = number == widget.value;

                return Center(
                  child: Text(
                    number.toString(),
                    style: textTheme.titleLarge?.copyWith(
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: isSelected ? 24 : 20,
                    ),
                  ),
                );
              },
              childCount: _items.length,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: colorScheme.primary,
              ),
              onPressed: () {
                final currentIndex = _items.indexOf(widget.value);
                if (currentIndex > 0) {
                  widget.onChanged(_items[currentIndex - 1]);
                }
              },
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.value.toString(),
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: colorScheme.primary,
              ),
              onPressed: () {
                final currentIndex = _items.indexOf(widget.value);
                if (currentIndex < _items.length - 1) {
                  widget.onChanged(_items[currentIndex + 1]);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
