import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/restaurant.dart';

/// The entry point of the application.
void main() {
  runApp(
    // ProviderScope stores the state of all providers in the application
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
