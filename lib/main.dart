import 'package:flutter/material.dart';
import 'screens/restaurant.dart';

/// The entry point of the application.
void main() {
  runApp(const MyApp());
}

/// MyApp sets up the root Material application, including themes and the initial screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      // Application theme configuration
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // The application starts at the Restaurant setup screen
      home: const RestaurantScreen(),
    );
  }
}
