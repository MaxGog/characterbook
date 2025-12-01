import 'package:characterbook/ui/widgets/sections/about_section.dart';
import 'package:characterbook/ui/widgets/sections/acknowledgements_section.dart';
import 'package:characterbook/ui/widgets/sections/backup_section.dart';
import 'package:characterbook/ui/widgets/sections/calendar_section.dart';
import 'package:characterbook/ui/widgets/sections/export_pdf_settings_section.dart';
import 'package:characterbook/ui/widgets/sections/import_section.dart';
import 'package:characterbook/ui/widgets/sections/language_section.dart';
import 'package:characterbook/ui/widgets/sections/licenses_section.dart';
import 'package:characterbook/ui/widgets/sections/theme_section.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.settings,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        titleSpacing: 24,
        scrolledUnderElevation: 3,
        shadowColor: theme.colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        toolbarHeight: 80,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: const [
        LanguageSection(),
        SizedBox(height: 8),
        ThemeSection(),
        SizedBox(height: 8),
        ImportSection(),
        SizedBox(height: 8),
        BackupSection(),
        SizedBox(height: 8),
        CalendarSection(),
        SizedBox(height: 8),
        ExportPdfSettingsSection(),
        SizedBox(height: 8),
        AboutSection(),
        SizedBox(height: 8),
        AcknowledgementsSection(),
        SizedBox(height: 8),
        LicensesSection(),
      ],
    );
  }
}