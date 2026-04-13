import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/create_account_form.dart';

/// CreateAccountScreen provides an interface for users to register a new account.
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          const CreateAccountForm(),
        ],
      ),
    );
  }
}
