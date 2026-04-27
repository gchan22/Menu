import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_account_input_fields.dart';
import 'create_account_action_buttons.dart';
import 'create_account_header.dart';
import '../providers/service_providers.dart';
import '../screens/sign_in.dart';

/// A reusable form component for creating a new user account.
class CreateAccountForm extends ConsumerStatefulWidget {
  const CreateAccountForm({super.key});

  @override
  ConsumerState<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends ConsumerState<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  /// if user leaves screen delete characters in textboxes
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the input: at least 5 characters, alphanumeric/email symbols only, no spaces.
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email or username';
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length < 5) {
      return 'Must be at least 5 characters';
    }
    if (trimmedValue.contains(' ')) {
      return 'Cannot contain spaces';
    }
    // Allow alphanumeric characters and common email symbols (@, ., _, -)
    if (!RegExp(r'^[a-zA-Z0-9.@_-]+$').hasMatch(trimmedValue)) {
      return 'Only letters, numbers, and . @ _ - are allowed';
    }
    return null;
  }

  /// Validates the password: min 8 chars, 1 special, 1 lower, 1 upper, 1 number.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Handles user account creation logic using Firebase.
  Future<void> _handleCreateAccount() async {
    // 1. Client-side validation
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final input = _usernameController.text.trim();
    final email = input.contains('@') ? input : "$input@example.com";
    final password = _passwordController.text;

    try {
      // 2. Business logic validation
      if (input == password) {
        throw Exception('Username and password cannot be the same.');
      }
      
      final auth = ref.read(authServiceProvider);
      final db = ref.read(databaseServiceProvider);

      // 3. Create account in Firebase Auth
      final user = await auth.signUp(email: email, password: password);
      
      if (user == null) {
        throw Exception('Account creation failed. Please try again.');
      }

      // 4. Save to Database (non-blocking for the flow)
      /// if take to long then timeout
      try {
        await db.saveField(user.uid, 'username', input).timeout(const Duration(seconds: 5));
      } catch (e) {
        // Log error but don't stop the user flow if account was created
        debugPrint('Database save warning: $e');
      }

      // 5. Sign out (as Firebase auto-logs in on signup)
      await auth.signOut().catchError((_) => null);

      // 6. Navigation
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please sign in.')),
        );

        // Go back to sign in screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    } 
    ///cates errors like same username and password and throws a message
    catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CreateAccountHeader(),
            const SizedBox(height: 40),
            CreateAccountInputFields(
              usernameController: _usernameController,
              passwordController: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              onTogglePasswordVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              usernameValidator: _validateUsername,
              passwordValidator: _validatePassword,
            ),
            const SizedBox(height: 40),
            CreateAccountActionButtons(
              isLoading: _isLoading,
              onCreateAccount: _handleCreateAccount,
            ),
          ],
        ),
      ),
    );
  }
}