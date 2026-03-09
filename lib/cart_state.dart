import 'package:flutter/material.dart';

class CartState {
  static final List<String> items = [];
  
  static String restaurantName = 'Default Restaurant';
  static String slogan = 'Default Slogan';
  static List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.restaurant, 'label': 'Chicken'},
    {'icon': Icons.restaurant, 'label': 'Beef'},
    {'icon': Icons.restaurant, 'label': 'Pork'},
    {'icon': Icons.local_drink, 'label': 'Soda'},
  ];
  static Map<String, List<Map<String, String>>> itemsByCategory = {};
  static Map<String, List<String>> descriptionRowsByItem = {};

  static void addItem(String itemName) {
    items.add(itemName);
  }

  static void removeItem(String itemName) {
    items.remove(itemName);
  }

  static void updateRestaurantInfo(String name, String slg) {
    restaurantName = name;
    slogan = slg;
  }

  static void updateMenuItems(List<Map<String, dynamic>> menuItms) {
    menuItems = menuItms;
  }

  static void updateCategoryItems(String category, List<Map<String, String>> itms) {
    itemsByCategory[category] = itms;
  }

  static void updateDescriptionRows(String itemName, List<String> rows) {
    descriptionRowsByItem[itemName] = rows;
  }
}
