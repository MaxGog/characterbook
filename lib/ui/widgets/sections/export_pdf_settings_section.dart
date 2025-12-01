import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../pages/export_pdf_settings_page.dart';
import 'settings_section.dart';

class ExportPdfSettingsSection extends StatelessWidget {
  const ExportPdfSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.export_pdf_settings,
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            s.export_pdf_settings,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExportPdfSettingsPage(),
              ),
            );
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}