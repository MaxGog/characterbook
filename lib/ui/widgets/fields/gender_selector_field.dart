import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class GenderSelectorField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final List<String> genders;
  final bool isRequired;

  const GenderSelectorField({
    super.key,
    this.initialValue,
    this.onChanged,
    this.genders = const ["male", "female", "another"],
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final genderLocalizations = {
      "male": s.male,
      "female": s.female,
      "another": s.another,
    };

    String? currentValue;
    if (initialValue != null && initialValue!.isNotEmpty) {
      if (genders.contains(initialValue)) {
        currentValue = initialValue;
      } else {
        final matchingKey = genderLocalizations.entries
            .firstWhere(
              (entry) => entry.value == initialValue,
              orElse: () => const MapEntry('', ''),
            )
            .key;
        currentValue = matchingKey.isEmpty ? null : matchingKey;
      }
    }

    return DropdownButtonFormField<String>(
      value: currentValue,
      items: genders.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(genderLocalizations[gender] ?? gender),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: s.gender,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      icon: Icon(
        Icons.arrow_drop_down_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      validator: (value) => isRequired && (value == null || value.isEmpty)
          ? s.select_gender_error
          : null,
      onChanged: onChanged,
    );
  }
}