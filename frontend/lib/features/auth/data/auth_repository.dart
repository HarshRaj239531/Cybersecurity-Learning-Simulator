import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/storage/storage_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data['status'] == 'success') {
        final token = data['data']['token'];
        final user = data['data']['user'];
        await StorageService.saveAccessToken(token);
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Connection error';
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data['status'] == 'success') {
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'Registration failed'};
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Connection error';
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<void> logout() async {
    await StorageService.clearTokens();
  }
}
