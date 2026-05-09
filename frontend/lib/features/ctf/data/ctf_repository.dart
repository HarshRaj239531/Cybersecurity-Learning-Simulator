import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class CtfRepository {
  Future<List<dynamic>> getAllChallenges() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.ctfChallenges);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load challenges');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitFlag(String id, String flag) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.submitFlag(id),
        data: {'flag': flag},
      );
      final data = response.data;
      if (data['status'] == 'success') {
        return data;
      }
      throw Exception(data['message'] ?? 'Invalid flag');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getMyCtfProgress() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.myCtfProgress);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load progress');
    } catch (e) {
      rethrow;
    }
  }
}
