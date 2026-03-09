import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'finalized_restaurant.dart';
import 'menu.dart';
import '../cart_state.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sloganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = CartState.restaurantName;
    _sloganController.text = CartState.slogan;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  void _saveData() {
    CartState.updateRestaurantInfo(_nameController.text, _sloganController.text);
  }

  @override
  Widget build(BuildContext context) {
    final nameField = CustomTextField(
      controller: _nameController,
      label: 'Restaurant Name',
    );

    final sloganField = CustomTextField(
      controller: _sloganController,
      label: 'Slogan',
    );

    final actionButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Exit',
          onPressed: () {
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
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Menu',
          onPressed: () {
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
