import 'dart:math';

import 'package:characterbook/generated/l10n.dart';
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
      appBar: AppBar(
        title: Text(l10n.randomNumberGenerator),
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
                        child: _NumberWheel(
                          title: l10n.from,
                          value: _minValue,
                          min: -999,
                          max: _maxValue - 1,
                          onChanged: _updateMinValue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _NumberWheel(
                          title: l10n.to,
                          value: _maxValue,
                          min: _minValue + 1,
                          max: 9999,
                          onChanged: _updateMaxValue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Number Display
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: _isGenerating
                    ? Text(
                        '...',
                        style: textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      )
                    : _generatedNumber != null
                        ? Text(
                            '$_generatedNumber',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          )
                        : Text(
                            '?',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer
                                  .withOpacity(0.3),
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 32),

            // Generate Button
            FilledButton(
              onPressed: _generateRandomNumber,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.casino),
                  const SizedBox(width: 12),
                  Text(_isGenerating ? l10n.generating : l10n.generateNumber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberWheel extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberWheel({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = List.generate(max - min + 1, (index) => min + index);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListWheelScrollView(
            itemExtent: 40,
            diameterRatio: 1.8,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) => onChanged(items[index]),
            children: items.map((number) {
              final isSelected = number == value;
              return Center(
                child: Text(
                  number.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withOpacity(0.6),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 22 : 18,
                      ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
