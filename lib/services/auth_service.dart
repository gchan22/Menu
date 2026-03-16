import 'package:firebase_auth/firebase_auth.dart';

/// AuthService handles Firebase authentication logic.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Logs in a user using email and password.
  /// Throws FirebaseAuthException for specific error handling.
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Creates a new user with email and password.
  /// Throws FirebaseAuthException for specific error handling.
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Logs out the current user.
  Future<void> logout() async {
    await _auth.signOut();
  }
}
