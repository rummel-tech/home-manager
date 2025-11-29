import 'package:shared_services/shared_services.dart';

class HomeApiService {
  final BaseApiClient _client;

  HomeApiService({BaseApiClient? client})
      : _client = client ?? BaseApiClient(config: AppConfigs.homeManager());

  Future<Map<String, dynamic>> getWeeklyTasks(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/tasks/weekly/$userId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getTodayTasks(String userId, {String? date}) async {
    return await _client.get<Map<String, dynamic>>(
      '/tasks/today/$userId',
      queryParameters: date != null ? {'date': date} : null,
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getGoals(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/goals/$userId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getStats(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/stats/$userId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getTasksByCategory(String userId, String category) async {
    return await _client.get<Map<String, dynamic>>(
      '/tasks/category/$userId/$category',
      fromJson: (json) => json,
    );
  }

  void dispose() {
    _client.dispose();
  }
}
