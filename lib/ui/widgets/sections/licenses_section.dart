import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LicensesSection extends StatelessWidget {
  const LicensesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.licenses,
      children: [
        ListTile(
          leading: const Icon(Icons.code),
          title: Text(s.flutterLicense),
          onTap: () => _launchUrl('https://github.com/flutter/flutter/blob/master/LICENSE'),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.article),
          title: Text(s.characterbookLicense),
          onTap: () => _launchUrl('https://www.gnu.org/licenses/gpl-3.0.html'),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.list),
          title: Text(s.usedLibraries),
          onTap: () => showLicensePage(
            context: context,
            applicationName: s.app_name,
            applicationVersion: '1.6.7.1',
            applicationIcon: Image.asset(
              'assets/iconapp.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}