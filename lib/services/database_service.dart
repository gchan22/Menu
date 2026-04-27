import 'package:cloud_firestore/cloud_firestore.dart';

/// DatabaseService provides methods to interact with the Firestore database.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// The currently active menu ID. If null, a new menu will be created on the next save.
  String? currentMenuId;

  /// Returns a reference to a specific menu document.
  DocumentReference<Map<String, dynamic>> _getMenuDocRef(String uid, String menuId) {
    return _db.collection('users').doc(uid).collection('menus').doc(menuId);
  }

  /// Fetches all menus for a given user.
  Future<List<Map<String, dynamic>>> fetchUserMenus(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('menus').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  /// Fetches all data for a specific menu.
  Future<Map<String, dynamic>?> fetchMenuData(String uid, String menuId) async {
    final doc = await _getMenuDocRef(uid, menuId).get();
    return doc.data();
  }

  /// Fetches all data for the current menu.
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    if (currentMenuId != null) {
      return await fetchMenuData(uid, currentMenuId!);
    }
    return null;
  }

  /// Saves a specific field for a user's current menu.
  Future<void> saveField(String uid, String field, dynamic value) async {
    currentMenuId ??= _db.collection('users').doc(uid).collection('menus').doc().id;
    await _getMenuDocRef(uid, currentMenuId!).set({field: value}, SetOptions(merge: true));
    await _db.collection('users').doc(uid).set({'lastModified': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  /// Clears all data for the current menu by setting its document to an empty map.
  Future<void> clearUserData(String uid) async {
    if (currentMenuId != null) {
      await _getMenuDocRef(uid, currentMenuId!).set({});
    }
  }
}