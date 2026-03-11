class AuthService {
  // Mock authentication logic
  Future<bool> login(String email, String password) async {
    // Simulate backend call
    await Future.delayed(const Duration(seconds: 1));
    return email == 'admin' && password == 'admin';
  }

  Future<void> logout() async {
    // Simulate logout
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
