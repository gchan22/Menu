import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier class for managing the descriptions of food items.
class DescriptionNotifier extends Notifier<Map<String, List<String>>> {
  @override
  Map<String, List<String>> build() {
    // Initial state: empty mapping of item names to description lists
    return {};
  }

  /// Sets or updates the description rows for a specific item.
  void setDescriptionRows(String itemName, List<String> rows) {
    state = {...state, itemName: rows};
  }

  /// Adds a single description row for an item.
  void addDescriptionRow(String itemName, String row) {
    final currentRows = state[itemName] ?? [];
    state = {...state, itemName: [...currentRows, row]};
  }

  /// Removes a specific description row for an item.
  void removeDescriptionRow(String itemName, String row) {
    final currentRows = state[itemName] ?? [];
    state = {
      ...state,
      itemName: currentRows.where((r) => r != row).toList(),
    };
  }
}

/// Provider to manage and access the list of description lines for each food item.
final descriptionProvider = NotifierProvider<DescriptionNotifier, Map<String, List<String>>>(() {
  return DescriptionNotifier();
});
