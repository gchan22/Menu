import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
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
    ref.read(restaurantInfoProvider.notifier).updateInfo(
      _nameController.text,
      _sloganController.text,
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
          label: 'Exit',
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
          label: 'Menu',
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
        ],
      ),
    );
  }
}
