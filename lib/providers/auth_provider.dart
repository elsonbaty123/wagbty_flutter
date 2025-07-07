import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/dio_provider.dart';

/// Stores JWT or session token; `null` means unauthenticated.
class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier(this._ref) : super(null) {
    _loadToken();
  }

  final Ref _ref;
  static const _kTokenKey = 'auth_token';

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kTokenKey);
    if (token != null) state = token;
  }

  Future<bool> login(String email, String password, {String userType = 'customer'}) async {
    final authService = AuthService(dio: _ref.read(dioProvider));
    final token = await authService.login(email, password, userType: userType);
    if (token != null) {
      state = token;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, token);
      return true;
    }
    return false;
  }

  Future<bool> signup(Map<String, dynamic> data) async {
    final authService = AuthService(dio: _ref.read(dioProvider));
    // Ensure userType is included in the data
    if (!data.containsKey('userType')) {
      data['userType'] = 'customer'; // Default to customer if not specified
    }
    final token = await authService.signup(data);
    if (token != null) {
      state = token;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final authService = AuthService(dio: _ref.read(dioProvider));
    await authService.sendPasswordResetEmail(email);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(ref);
});
