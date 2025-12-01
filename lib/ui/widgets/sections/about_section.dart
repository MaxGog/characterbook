import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.developer_mode),
          title: Text(s.developer),
          trailing: Text(
            'Максим Гоглов',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(s.version),
          trailing: Text(
            '1.7.0',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: () => _launchUrl('https://github.com/MaxGog/CharacterBook'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/github-mark.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                s.githubRepo,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => _launchUrl('https://hipolink.net/maxupshur/'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: colorScheme.tertiaryContainer,
            foregroundColor: colorScheme.onTertiaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 24),
              const SizedBox(width: 12),
              Text(
                'Поддержать разработчика',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
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