import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: s.aboutApp,
      children: [
        ListTile(
          leading: const Icon(Icons.title),
          title: Text(s.name),
          trailing: Text(
            s.app_name,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.developer_mode),
          title: Text(s.developer),
          trailing: Text(
            'Максим Гоглов',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(s.version),
          trailing: Text(
            '1.6.8',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _launchUrl('https://github.com/MaxGog/CharacterBook'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset('assets/underdeveloped.png'),
                  const SizedBox(height: 8),
                  Text(
                    s.githubRepo,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
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