import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import 'custom_button.dart';

class ThemeSelectionButton extends ConsumerWidget {
  const ThemeSelectionButton({super.key});

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Default'),
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(AppTheme.defaultTheme);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(AppTheme.lightTheme);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(AppTheme.darkTheme);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Darkest'),
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(AppTheme.darkestTheme);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      label: 'Change Theme',
      onPressed: () => _showThemeDialog(context, ref),
    );
  }
}