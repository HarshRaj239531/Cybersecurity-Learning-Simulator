import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class LabsRepository {
  Future<List<dynamic>> getAllLabs() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.labs);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load labs');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLabById(String id) async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.labById(id));
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load lab');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeLab(String id, int score) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.completeLab(id),
        data: {'score': score},
      );
      final data = response.data;
      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Failed to complete lab');
      }
    } catch (e) {
      rethrow;
    }
  }
}
