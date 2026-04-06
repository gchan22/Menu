import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';
import 'service_providers.dart';

enum AppTheme {
  defaultTheme,
  lightTheme,
  darkTheme,
  darkestTheme,
}

class ThemeNotifier extends Notifier<AppTheme> {
  static const _baseKey = 'app_theme';

  String _getUserKey() {
    final user = ref.read(authStateProvider).value;
    final uid = user?.uid ?? 'guest';
    return '${uid}_$_baseKey';
  }

  @override
  AppTheme build() {
    // Rebuild when user logs in/out
    ref.watch(authStateProvider);
    
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeName = prefs.getString(_getUserKey());
    
    if (themeName != null) {
      try {
        return AppTheme.values.firstWhere((e) => e.toString() == themeName);
      } catch (e) {
        // Fallback
      }
    }
    return AppTheme.defaultTheme;
  }

  void setTheme(AppTheme theme) {
    state = theme;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_getUserKey(), theme.toString());
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(() {
  return ThemeNotifier();
});
