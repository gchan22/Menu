import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/restaurant_input_fields.dart';
import '../widgets/restaurant_action_buttons.dart';
import '../widgets/restaurant_sign_out_button.dart';
import '../widgets/restaurant_theme_button.dart';
import 'finalized_restaurant.dart';
import 'menu.dart';
import '../providers/restaurant_provider.dart';

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
      final asyncInfo = ref.read(restaurantInfoProvider);
      _nameController.text = asyncInfo.value?.name ?? '';
      _sloganController.text = asyncInfo.value?.slogan ?? '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(), // Background gradient widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RestaurantInputFields(
                  nameController: _nameController,
                  sloganController: _sloganController,
                ),
                const SizedBox(height: 40),
                RestaurantActionButtons(
                  onExitEditing: () {
                    _saveData();
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
                  onEditMenu: () {
                    _saveData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MenuScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          RestaurantSignOutButton(onSignOut: _saveData),
          const RestaurantThemeButton(),
        ],
      ),
    );
  }
}
