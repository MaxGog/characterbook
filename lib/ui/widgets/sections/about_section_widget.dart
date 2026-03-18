import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:characterbook/generated/l10n.dart';

class AboutSection extends StatelessWidget {

  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.title, color: colorScheme.onSurfaceVariant),
          title: Text(s.name),
          trailing: Text(s.app_name, style: theme.textTheme.bodyLarge),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage('assets/avatardeveloper.jpg'),
          ),
          title: Text(s.developer),
          trailing: Text('Максим Гоглов', style: theme.textTheme.bodyLarge),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
          title: Text(s.version),
          trailing: Text('1.8.0', style: theme.textTheme.bodyLarge),
        ),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: () =>
              _launchUrl('https://github.com/MaxGog/CharacterBook'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/github-mark.png', width: 24, height: 24),
              const SizedBox(width: 12),
              Text(s.githubRepo, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => _launchUrl('https://hipolink.net/maxupshur/'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
