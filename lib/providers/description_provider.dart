import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

/// Notifier class for managing the descriptions of food items.
class DescriptionNotifier extends Notifier<Map<String, List<String>>> {
  static const _key = 'descriptions';

  /// load saved preferences
  @override
  Map<String, List<String>> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_key);
    if (data != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return jsonMap.map((key, value) {
          final List<dynamic> list = value;
          return MapEntry(key, list.map((e) => e.toString()).toList());
        });
      } catch (e) {
        // Fallback
      }
    }
    // Initial state: empty mapping of item names to description lists
    return {};
  }

  /// Save current state to preferences
  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode(state));
  }

  /// Sets or updates the description rows for a specific item.
  void setDescriptionRows(String itemName, List<String> rows) {
    state = {...state, itemName: rows};
    _save();
  }

  /// Adds a single description row for an item.
  void addDescriptionRow(String itemName, String row) {
    final currentRows = state[itemName] ?? [];
    state = {...state, itemName: [...currentRows, row]};
    _save();
  }

  /// Removes a specific description row for an item.
  void removeDescriptionRow(String itemName, String row) {
    final currentRows = state[itemName] ?? [];
    state = {
      ...state,
      itemName: currentRows.where((r) => r != row).toList(),
    };
    _save();
  }

  /// Resets the descriptions mapping to its initial empty state.
  void reset() {
    state = {};
    _save();
  }
}

/// Provider to manage and access the list of description lines for each food item.
final descriptionProvider = NotifierProvider<DescriptionNotifier, Map<String, List<String>>>(() {
  return DescriptionNotifier();
});
