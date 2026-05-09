import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.profile);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load profile');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await DioClient.instance.patch(
        AppEndpoints.updateProfile,
        data: updateData,
      );
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to update profile');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      final data = response.data;
      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to change password');
    }
  }
}
