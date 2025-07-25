import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:characterbook/ui/widgets/sections/about_section.dart';
import 'package:characterbook/ui/widgets/sections/acknowledgements_section.dart';
import 'package:characterbook/ui/widgets/sections/backup_section.dart';
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
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
        centerTitle: false,
        scrolledUnderElevation: 1,
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
        AboutSection(),
        SizedBox(height: 8),
        AcknowledgementsSection(),
        SizedBox(height: 8),
        LicensesSection(),
        SizedBox(height: 8),
        _SecretUpdateButton(),
      ],
    );
  }
}

class _SecretUpdateButton extends StatefulWidget {
  const _SecretUpdateButton();

  @override
  State<_SecretUpdateButton> createState() => __SecretUpdateButtonState();
}

class __SecretUpdateButtonState extends State<_SecretUpdateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _bounceAnimation;

  final List<Color> _rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    _colorAnimation = ColorTween(
      begin: _rainbowColors.first,
      end: _rainbowColors.last,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const SawTooth(5),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const animationDuration = Duration(milliseconds: 300);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TweenAnimationBuilder<double>(
          duration: animationDuration,
          tween: Tween(begin: 1.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FilledButton.tonal(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RandomNumberPage()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _colorAnimation.value?.withOpacity(0.2),
                  foregroundColor: _colorAnimation.value,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  animationDuration: animationDuration,
                  enableFeedback: true,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: _colorAnimation.value,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Секреты следующего обновления',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: _colorAnimation.value,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: _colorAnimation.value,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}