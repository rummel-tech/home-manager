import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_app/main.dart';

/// End-to-end tests for the app entry point flow.
/// These tests cover the initial app state (auth check loading).
/// Tests requiring authenticated state are in integration_test/app_test.dart.
void main() {
  group('App Initialization Tests', () {
    testWidgets('app starts and renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('app shows loading indicator while checking auth', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // AuthWrapper shows CircularProgressIndicator while isAuthenticated() resolves
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('app renders a Scaffold during loading', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('app has Navigator', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(Navigator), findsOneWidget);
    });
  });

  group('Theme and Configuration Tests', () {
    testWidgets('Material Design 3 theme is applied', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });

    testWidgets('app title is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.title, 'Home Manager');
    });

    testWidgets('app builds efficiently', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds < 1000, true,
          reason: 'Initial build took ${stopwatch.elapsedMilliseconds}ms');
    });
  });

  group('Error Handling Tests', () {
    testWidgets('app handles initialization gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('app handles rapid widget rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());

      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
    });
  });
}
