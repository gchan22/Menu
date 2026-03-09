import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
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
    final nameField = TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Restaurant Name',
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white70,
      ),
    );

    final sloganField = TextField(
      controller: _sloganController,
      decoration: const InputDecoration(
        labelText: 'Slogan',
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white70,
      ),
    );

    final actionButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
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
          child: const Text('Exit'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            _saveData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuScreen(),
              ),
            );
          },
          child: const Text('Menu'),
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
