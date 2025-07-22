import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';

class AcknowledgementsSection extends StatelessWidget {
  const AcknowledgementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.acknowledgements,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Данила Ганьков | Makoto🐼 | Максим Семенков | Артём Голубев | '
                'Евгений Стратий | Никита Жевнерович | KellSmiley | Участники EnA',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}