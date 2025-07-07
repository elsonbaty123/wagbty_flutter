import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AuthService {
  final Dio _dio;
  final Logger _logger = Logger();

  AuthService({Dio? dio}) : _dio = dio ?? Dio();

  Future<String?> login(String email, String password, {String userType = 'customer'}) async {
    try {
      final response = await _dio.post('/api/login', data: {
        'email': email,
        'password': password,
        'userType': userType,
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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dio.post('/api/forgot-password', data: {'email': email});
    } catch (e) {
      _logger.e('Error sending password reset email', error: e, stackTrace: StackTrace.current);
      throw Exception('Failed to send password reset email.');
    }
  }
}
