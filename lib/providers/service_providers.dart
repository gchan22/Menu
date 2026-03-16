import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

/// Provider for the authentication service.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider for the database service.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
