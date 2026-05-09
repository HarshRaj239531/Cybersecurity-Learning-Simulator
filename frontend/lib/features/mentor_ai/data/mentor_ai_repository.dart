import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class MentorAiRepository {
  Future<String> sendMessage(String message) async {
    try {
      final response = await DioClient.instance.post(
        AppEndpoints.aiChat,
        data: {'message': message},
      );
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data']['response'];
      }
      throw Exception(data['message'] ?? 'Failed to get response');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getChatHistory() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.aiHistory);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load history');
    } catch (e) {
      rethrow;
    }
  }
}
