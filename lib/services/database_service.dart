class DatabaseService {
  // Mock database logic
  Future<List<String>> fetchData() async {
    // Simulate data fetching
    await Future.delayed(const Duration(seconds: 1));
    return ['Item 1', 'Item 2', 'Item 3'];
  }

  Future<void> saveData(String data) async {
    // Simulate data saving
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
