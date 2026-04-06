import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import 'light_backdrop.dart';
import 'dark_backdrop.dart';
import 'darkest_backdrop.dart';

/// Backdrop provides a consistent background for all screens in the application.
/// It dynamically changes based on the user's selected theme.
class Backdrop extends ConsumerWidget {
  const Backdrop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    switch (theme) {
      case AppTheme.lightTheme:
        return const LightBackdrop();
      case AppTheme.darkTheme:
        return const DarkBackdrop();
      case AppTheme.darkestTheme:
        return const DarkestBackdrop();
      case AppTheme.defaultTheme:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 33, 222, 243),
                Color.fromARGB(255, 79, 252, 142),
              ],
            ),
          ),
        );
    }
  }
}
