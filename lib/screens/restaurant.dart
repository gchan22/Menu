import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'finalized_restaurant.dart';
import 'menu.dart';
import 'sign_in.dart';
import '../providers/restaurant_provider.dart';
import '../providers/theme_provider.dart';

/// RestaurantScreen allows the user to input the name and slogan of their restaurant.
class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // Controllers for managing text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sloganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to initialize controllers from the provider's state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final info = ref.read(restaurantInfoProvider);
      _nameController.text = info.name;
      _sloganController.text = info.slogan;
    });
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is destroyed
    _nameController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  /// Saves the current input values to the Riverpod provider.
  void _saveData() {
    try {
      ref.read(restaurantInfoProvider.notifier).updateInfo(
        _nameController.text,
        _sloganController.text,
      );
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  void _showThemeDialog() {
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
  Widget build(BuildContext context) {
    // Custom text field for the restaurant name
    final nameField = CustomTextField(
      controller: _nameController,
      label: 'Restaurant Name',
    );

    // Custom text field for the restaurant slogan
    final sloganField = CustomTextField(
      controller: _sloganController,
      label: 'Slogan',
    );

    // Layout for the main action buttons
    final actionButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Exit Editing',
          onPressed: () {
            _saveData();
            // Navigate to the finalized preview screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedRestaurantScreen(
                  restaurantName: _nameController.text,
                  slogan: _sloganController.text,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Edit Menu',
          onPressed: () {
            _saveData();
            // Navigate to the menu editing screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuScreen(),
              ),
            );
          },
        ),
      ],
    );

    // Prompt 65: Change 'Sign In' button to 'Sign Out' on restaurant screen
    final signOutButton = Positioned(
      top: 40,
      left: 16,
      child: CustomButton(
        label: 'Sign Out',
        onPressed: () {
          _saveData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        },
      ),
    );

    // Prompt 94: Add 'Change Theme' button to top right
    final changeThemeButton = Positioned(
      top: 40,
      right: 16,
      child: CustomButton(
        label: 'Change Theme',
        onPressed: _showThemeDialog,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(), // Background gradient widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nameField,
                const SizedBox(height: 20),
                sloganField,
                const SizedBox(height: 40),
                actionButtons,
              ],
            ),
          ),
          signOutButton, // Moved to bottom of stack children list to be on top
          changeThemeButton,
        ],
      ),
    );
  }
}
