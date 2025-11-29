import 'package:flutter_test/flutter_test.dart';
import 'package:home_ui/services/home_api_service.dart';

void main() {
  group('HomeApiService Tests', () {
    late HomeApiService apiService;

    setUp(() {
      apiService = HomeApiService(baseUrl: 'http://invalid-test-server-9999');
    });

    group('getWeeklyTasks', () {
      test('throws exception when server is not available', () async {
        // Act & Assert
        expect(
          () => apiService.getWeeklyTasks('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTodayTasks', () {
      test('throws exception when server is not available', () async {
        // Act & Assert
        expect(
          () => apiService.getTodayTasks('user-123'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception with date parameter', () async {
        // Act & Assert
        expect(
          () => apiService.getTodayTasks('user-123', date: '2025-11-21'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getGoals', () {
      test('throws exception when server is not available', () async {
        // Act & Assert
        expect(
          () => apiService.getGoals('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getStats', () {
      test('throws exception when server is not available', () async {
        // Act & Assert
        expect(
          () => apiService.getStats('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTasksByCategory', () {
      test('throws exception when server is not available', () async {
        // Act & Assert
        expect(
          () => apiService.getTasksByCategory('user-123', 'cleaning'),
          throwsA(isA<Exception>()),
        );
      });

      test('handles various category types', () async {
        final categories = ['cleaning', 'cooking', 'outdoor', 'organizing'];

        for (var category in categories) {
          expect(
            () => apiService.getTasksByCategory('user-123', category),
            throwsA(isA<Exception>()),
          );
        }
      });
    });

    group('BaseUrl Configuration', () {
      test('uses default baseUrl when not provided', () {
        final service = HomeApiService();
        expect(service.baseUrl, 'http://localhost:8020');
      });

      test('uses custom baseUrl when provided', () {
        final service = HomeApiService(baseUrl: 'https://custom-api.com');
        expect(service.baseUrl, 'https://custom-api.com');
      });
    });

    group('Error Handling', () {
      test('getWeeklyTasks wraps exceptions properly', () async {
        try {
          await apiService.getWeeklyTasks('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Exception'));
        }
      });

      test('getTodayTasks wraps exceptions properly', () async {
        try {
          await apiService.getTodayTasks('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Exception'));
        }
      });

      test('getGoals wraps exceptions properly', () async {
        try {
          await apiService.getGoals('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Exception'));
        }
      });

      test('getStats wraps exceptions properly', () async {
        try {
          await apiService.getStats('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Exception'));
        }
      });
    });
  });
}
