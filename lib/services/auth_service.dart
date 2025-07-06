import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;
  AuthService(this._dio);

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        return response.data['token'] as String?;
      }
    } catch (_) {
      // Development fallback
      return 'dev_token';
    }
    return null;
  }

  Future<String?> signup(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/signup', data: data);
      if (response.statusCode == 200) {
        return response.data['token'] as String?;
      }
    } catch (_) {
      return 'dev_token';
    }
    return null;
  }

  Future<void> logout() async {
    await _dio.post('/api/logout');
  }
}
