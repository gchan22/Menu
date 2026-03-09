import 'package:flutter/material.dart';
import 'models/menu_item.dart';
import 'models/category_item.dart';
import 'models/restaurant_info.dart';

class CartState {
  static final List<String> items = [];
  
  static RestaurantInfoModel restaurantInfo = RestaurantInfoModel(
    name: '',
    slogan: '',
  );

  static List<MenuItemModel> menuItems = [
    MenuItemModel(icon: Icons.restaurant, label: 'Chicken'),
    MenuItemModel(icon: Icons.restaurant, label: 'Beef'),
    MenuItemModel(icon: Icons.restaurant, label: 'Pork'),
    MenuItemModel(icon: Icons.local_drink, label: 'Soda'),
  ];
  static Map<String, List<CategoryItemModel>> itemsByCategory = {};
  static Map<String, List<String>> descriptionRowsByItem = {};

  static String get restaurantName => restaurantInfo.name;
  static String get slogan => restaurantInfo.slogan;

  static void addItem(String itemName) {
    items.add(itemName);
  }

  static void removeItem(String itemName) {
    items.remove(itemName);
  }

  static void updateRestaurantInfo(String name, String slg) {
    restaurantInfo = RestaurantInfoModel(name: name, slogan: slg);
  }

  static void updateMenuItems(List<MenuItemModel> itms) {
    menuItems = itms;
  }

  static void updateCategoryItems(String category, List<CategoryItemModel> itms) {
    itemsByCategory[category] = itms;
  }

  static void updateDescriptionRows(String itemName, List<String> rows) {
    descriptionRowsByItem[itemName] = rows;
  }
}
