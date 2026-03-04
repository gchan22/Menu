class CartState {
  static final List<String> items = [];

  static void addItem(String itemName) {
    items.add(itemName);
  }

  static void removeItem(String itemName) {
    items.remove(itemName);
  }
}
