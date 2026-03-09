import 'package:flutter/material.dart';
import 'models/menu_item.dart';
import 'models/category_item.dart';
import 'models/restaurant_info.dart';

/// CartState is a central store for application data, acting as a simple state manager.
/// It holds information about the restaurant, menu items, and the user's shopping cart.
class CartState {
  /// The list of item names currently in the user's shopping cart.
  static final List<String> items = [];
  
  /// Holds basic restaurant information like name and slogan.
  static RestaurantInfoModel restaurantInfo = RestaurantInfoModel(
    name: '',
    slogan: '',
  );

  /// Default categories shown on the main menu.
  static List<MenuItemModel> menuItems = [
    MenuItemModel(icon: Icons.restaurant, label: 'Chicken'),
    MenuItemModel(icon: Icons.restaurant, label: 'Beef'),
    MenuItemModel(icon: Icons.restaurant, label: 'Pork'),
    MenuItemModel(icon: Icons.local_drink, label: 'Soda'),
  ];

  /// Stores a list of specific food items for each menu category.
  static Map<String, List<CategoryItemModel>> itemsByCategory = {};

  /// Stores multiple description rows for each food item.
  static Map<String, List<String>> descriptionRowsByItem = {};

  /// Getters for restaurant name and slogan for easier access.
  static String get restaurantName => restaurantInfo.name;
  static String get slogan => restaurantInfo.slogan;

  /// Adds an item name to the global cart.
  static void addItem(String itemName) {
    items.add(itemName);
  }

  /// Removes an item name from the global cart.
  static void removeItem(String itemName) {
    items.remove(itemName);
  }

  /// Updates the global restaurant name and slogan.
  static void updateRestaurantInfo(String name, String slg) {
    restaurantInfo = RestaurantInfoModel(name: name, slogan: slg);
  }

  /// Updates the list of main menu categories.
  static void updateMenuItems(List<MenuItemModel> itms) {
    menuItems = itms;
  }

  /// Updates the specific items belonging to a particular category.
  static void updateCategoryItems(String category, List<CategoryItemModel> itms) {
    itemsByCategory[category] = itms;
  }

  /// Updates the list of descriptions for a specific item.
  static void updateDescriptionRows(String itemName, List<String> rows) {
    descriptionRowsByItem[itemName] = rows;
  }
}
