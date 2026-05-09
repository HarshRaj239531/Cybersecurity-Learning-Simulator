import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';

class LeaderboardRepository {
  Future<List<dynamic>> getLeaderboard({int limit = 10}) async {
    try {
      final response = await DioClient.instance.get(
        AppEndpoints.leaderboard,
        queryParameters: {'limit': limit},
      );
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Failed to load leaderboard');
    } catch (e) {
      rethrow;
    }
  }
}
