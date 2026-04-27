import 'package:cloud_firestore/cloud_firestore.dart';

/// DatabaseService provides methods to interact with the Firestore database.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns a reference to the current user's document.
  DocumentReference<Map<String, dynamic>> _getUserDocRef(String uid) {
    return _db.collection('users').doc(uid);
  }

  /// Fetches all data for a given user.
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    final doc = await _getUserDocRef(uid).get();
    return doc.data();
  }

  /// Saves a specific field (e.g., 'restaurantInfo') for a user.
  /// This uses `SetOptions(merge: true)` to avoid overwriting other fields.
  Future<void> saveField(String uid, String field, dynamic value) async {
    await _getUserDocRef(uid).set({field: value}, SetOptions(merge: true));
  }

  /// Clears all data for a user by setting their document to an empty map.
  Future<void> clearUserData(String uid) async {
    await _getUserDocRef(uid).set({});
  }
}