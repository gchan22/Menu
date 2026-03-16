import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'restaurant.dart';
import 'create_account.dart';
import '../providers/service_providers.dart';

/// SignInScreen provides a login interface with validation for username and password.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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

  /// Handles user login logic using Firebase.
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final auth = ref.read(authServiceProvider);
      
      final input = _usernameController.text.trim();
      // Use the input as-is if it's already an email, otherwise append default domain
      final email = input.contains('@') ? input : "$input@example.com";
      final password = _passwordController.text;

      try {
        await auth.signIn(email: email, password: password);
        
        if (mounted) {
          // If validation passes, navigate to the restaurant setup screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RestaurantScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
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
                    'Sign In',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          label: 'Sign In',
                          onPressed: _handleSignIn,
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          label: 'Create Account',
                          onPressed: () {
                            // Navigate to the create account screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
                            );
                          },
                        ),
                      ],
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
