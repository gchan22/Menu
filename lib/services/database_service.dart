import 'package:cloud_firestore/cloud_firestore.dart';

/// DatabaseService handles operations related to Firestore database.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Saves user information (username) to Firestore.
  Future<void> saveUser(String uid, String username) async {
    try {
      await _db.collection('users').doc(uid).set({
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save user data to database: $e');
    }
  }

  /// Fetches data from the 'app_data' Firestore collection.
  Future<List<String>> fetchData() async {
    try {
      final snapshot = await _db.collection('app_data').orderBy('createdAt').get();
      return snapshot.docs.map((doc) => doc.data()['value'] as String).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  /// Saves a string to the 'app_data' Firestore collection.
  Future<void> saveData(String data) async {
    try {
      await _db.collection('app_data').add({
        'value': data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}
