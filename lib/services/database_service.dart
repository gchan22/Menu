import 'package:cloud_firestore/cloud_firestore.dart';

/// DatabaseService handles operations related to Firestore database.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Saves user information (username and password) to Firestore.
  Future<void> saveUser(String uid, String username, String password) async {
    try {
      await _db.collection('users').doc(uid).set({
        'username': username,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Database error saving user: $e');
    }
  }

  /// Mock database logic
  Future<List<String>> fetchData() async {
    // Simulate data fetching
    await Future.delayed(const Duration(seconds: 1));
    return ['Item 1', 'Item 2', 'Item 3'];
  }

  Future<void> saveData(String data) async {
    // Simulate data saving
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
