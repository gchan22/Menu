import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_providers.dart';

/// Notifier class for managing the descriptions of food items.
class DescriptionNotifier extends AsyncNotifier<Map<String, List<String>>> {
  /// load saved descriptions from Firestore
  @override
  Future<Map<String, List<String>>> build() async {
    // Watch for authentication state changes
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return {};
    }

    final db = ref.read(databaseServiceProvider);
    final userData = await db.fetchUserData(user.uid);

    if (userData != null && userData.containsKey('descriptions')) {
      final Map<String, dynamic> jsonMap = userData['descriptions'];
      return jsonMap.map((key, value) {
        final List<dynamic> list = value;
        return MapEntry(key, list.map((e) => e.toString()).toList());
      });
    }

    // Initial state: empty mapping of item names to description lists
    return {};
  }

  /// Save current state to Firestore
  Future<void> _save() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    await db.saveField(user.uid, 'descriptions', state.value ?? {});
  }

  /// Sets or updates the description rows for a specific item.
  Future<void> setDescriptionRows(String itemName, List<String> rows) async {
    final current = state.value ?? {};
    state = AsyncData({...current, itemName: rows});
    await _save();
  }

  /// Adds a single description row for an item.
  Future<void> addDescriptionRow(String itemName, String row) async {
    final current = state.value ?? {};
    final currentRows = current[itemName] ?? [];
    state = AsyncData({...current, itemName: [...currentRows, row]});
    await _save();
  }

  /// Removes a specific description row for an item.
  Future<void> removeDescriptionRow(String itemName, String row) async {
    final current = state.value ?? {};
    final currentRows = current[itemName] ?? [];
    state = AsyncData({
      ...current,
      itemName: currentRows.where((r) => r != row).toList(),
    });
    await _save();
  }

  /// Resets the descriptions mapping to its initial empty state.
  Future<void> reset() async {
    state = const AsyncData({});
    await _save();
  }
}

/// Provider to manage and access the list of description lines for each food item.
final descriptionProvider = AsyncNotifierProvider<DescriptionNotifier, Map<String, List<String>>>(() {
  return DescriptionNotifier();
});
