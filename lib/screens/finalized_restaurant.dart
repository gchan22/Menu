import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_box.dart';
import 'finalized_menu.dart';
import 'sign_in.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/theme_provider.dart';

/// FinalizedRestaurantScreen displays a read-only preview of the restaurant name and slogan.
class FinalizedRestaurantScreen extends ConsumerWidget {
  final String restaurantName;
  final String slogan;

  const FinalizedRestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.slogan,
  });

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

  /// The screen layout
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(restaurantInfoProvider);
    final menuItems = ref.watch(menuProvider);

    // A special button to return to the setup screen and start over
    final newMenuButton = Positioned(
      top: 40,
      left: 16,
      child: CustomButton(
        label: 'Sign In',
        backgroundColor: const Color.fromARGB(255, 242, 109, 153),
        foregroundColor: Colors.black,
        onPressed: () {
          // Clears navigation stack and goes to the sign in screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        },
      ),
    );

    // Displays the restaurant name in a styled container
    final restaurantNameBox = InfoBox(
      text: info.name.isNotEmpty ? info.name : restaurantName,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // Displays the slogan in a styled container
    final sloganBox = InfoBox(
      text: info.slogan.isNotEmpty ? info.slogan : slogan,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    );

    // Button to proceed to the finalized menu viewing screen
    final startEatingButton = CustomButton(
      label: 'Start Eating',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizedMenuScreen(
              menuItems: menuItems,
            ),
          ),
        );
      },
    );

    // Prompt 94: Add 'Change Theme' button to top right
    final changeThemeButton = Positioned(
      top: 40,
      right: 16,
      child: CustomButton(
        label: 'Change Theme',
        onPressed: () => _showThemeDialog(context, ref),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                restaurantNameBox,
                const SizedBox(height: 20),
                sloganBox,
                const SizedBox(height: 40),
                startEatingButton,
              ],
            ),
          ),
          newMenuButton, // Move to bottom to be on top
          changeThemeButton,
        ],
      ),
    );
  }
}
