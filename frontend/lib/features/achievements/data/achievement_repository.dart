import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class AchievementRepository {
  Future<List<dynamic>> getAllAchievements() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.allAchievements);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load achievements');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getMyAchievements() async {
    try {
      final response = await DioClient.instance.get(AppEndpoints.myAchievements);
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load your achievements');
    } catch (e) {
      rethrow;
    }
  }
}
