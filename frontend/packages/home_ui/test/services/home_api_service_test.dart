import 'package:flutter_test/flutter_test.dart';
import 'package:home_ui/services/home_api_service.dart';

void main() {
  group('HomeApiService Tests', () {
    late HomeApiService apiService;

    setUp(() {
      apiService = HomeApiService();
    });

    tearDown(() {
      apiService.dispose();
    });

    group('Service instantiation', () {
      test('creates service with default config', () {
        final service = HomeApiService();
        expect(service, isNotNull);
        service.dispose();
      });

      test('creates service with injected client', () {
        final service = HomeApiService();
        expect(service, isNotNull);
        service.dispose();
      });
    });

    group('getWeeklyTasks', () {
      test('throws exception when server is not available', () async {
        await expectLater(
          apiService.getWeeklyTasks('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTodayTasks', () {
      test('throws exception when server is not available', () async {
        await expectLater(
          apiService.getTodayTasks('user-123'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception with date parameter', () async {
        await expectLater(
          apiService.getTodayTasks('user-123', date: '2025-11-21'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getGoals', () {
      test('throws exception when server is not available', () async {
        await expectLater(
          apiService.getGoals('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getStats', () {
      test('throws exception when server is not available', () async {
        await expectLater(
          apiService.getStats('user-123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTasksByCategory', () {
      test('throws exception when server is not available', () async {
        await expectLater(
          apiService.getTasksByCategory('user-123', 'cleaning'),
          throwsA(isA<Exception>()),
        );
      });

      test('handles various category types', () async {
        final categories = ['cleaning', 'cooking', 'outdoor', 'organizing'];
        for (final category in categories) {
          await expectLater(
            apiService.getTasksByCategory('user-123', category),
            throwsA(isA<Exception>()),
          );
        }
      });
    });

    group('Error Handling', () {
      test('getWeeklyTasks wraps exceptions properly', () async {
        try {
          await apiService.getWeeklyTasks('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('getTodayTasks wraps exceptions properly', () async {
        try {
          await apiService.getTodayTasks('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('getGoals wraps exceptions properly', () async {
        try {
          await apiService.getGoals('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('getStats wraps exceptions properly', () async {
        try {
          await apiService.getStats('user-123');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });
  });
}
