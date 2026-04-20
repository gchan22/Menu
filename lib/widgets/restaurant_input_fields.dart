import 'package:flutter/material.dart';
import 'custom_text_field.dart';

/// A reusable widget that holds the restaurant name and slogan input fields.
class RestaurantInputFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController sloganController;

  const RestaurantInputFields({
    super.key,
    required this.nameController,
    required this.sloganController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          label: 'Restaurant Name',
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: sloganController,
          label: 'Slogan',
        ),
      ],
    );
  }
}