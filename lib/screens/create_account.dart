import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../providers/service_providers.dart';

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

  /// Validates the username: at least 5 characters and no spaces.
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 5) {
      return 'Username must be at least 5 characters';
    }
    if (value.contains(' ')) {
      return 'Username cannot contain spaces';
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
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final auth = ref.read(authServiceProvider);
      final db = ref.read(databaseServiceProvider);
      
      // Using a mock email format for username-based auth in Firebase
      final email = "${_usernameController.text}@example.com";
      final password = _passwordController.text;

      try {
        final credential = await auth.signUp(email, password);
        
        if (credential.user != null) {
          // Save the username and password to Firestore
          await db.saveUser(credential.user!.uid, _usernameController.text, password);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully! Please sign in.')),
            );
            // Go back to sign in screen
            Navigator.pop(context);
          }
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred during account creation.';
        if (e.code == 'email-already-in-use') {
          message = 'An account already exists for this username.';
        } else if (e.code == 'invalid-email') {
          message = 'The username format is invalid.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
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
                    label: 'Username',
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
