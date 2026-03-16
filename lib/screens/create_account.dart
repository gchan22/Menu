import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../providers/service_providers.dart';
import 'sign_in.dart';

/// CreateAccountScreen provides an interface for users to register a new account.
class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
      try {
        await db.saveUser(user.uid, input, password).timeout(const Duration(seconds: 5));
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
    } catch (e) {
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
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Email or Username',
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 40),
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else
                    CustomButton(
                      label: 'Create Account',
                      onPressed: _handleCreateAccount,
                    ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
