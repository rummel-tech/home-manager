import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:home_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Manager Integration Tests', () {
    testWidgets('App loads and displays home screen', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app bar is displayed
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Verify main sections are present
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.text('Your weekly tasks and goals'), findsOneWidget);
    });

    testWidgets('Today\'s Tasks section displays', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));

      // Verify Today's Tasks section
      expect(find.text('Today\'s Tasks'), findsOneWidget);

      // Should display day name or tasks
      // Note: May show loading or error depending on backend availability
    });

    testWidgets('Goals section displays', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));

      // Verify Goals section
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('Add Goal'), findsOneWidget);
    });

    testWidgets('Refresh button triggers data reload', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap the refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pump();

      // Should trigger data reload without crashing
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // App should still be functional
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('App maintains scroll position', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the scrollable ListView
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      // Scroll down
      await tester.drag(listView, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Verify we can still see the app bar
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('Pull to refresh works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Perform pull to refresh gesture
      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // App should still be functional after refresh
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('App handles errors gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Even if API calls fail, app should display structure
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.text('Today\'s Tasks'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);

      // App should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('Navigation structure is present', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify Navigator exists
      expect(find.byType(Navigator), findsOneWidget);

      // Verify Scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Material Design 3 theme is applied', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find MaterialApp
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );

      // Verify Material Design 3 is enabled
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });

    testWidgets('App responds to multiple interactions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap refresh multiple times
      final refreshButton = find.byIcon(Icons.refresh);

      await tester.tap(refreshButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(refreshButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // App should remain stable
      expect(tester.takeException(), isNull);
      expect(find.text('Home Manager'), findsOneWidget);
    });
  });

  group('Backend Integration Tests', () {
    testWidgets('App attempts to load data from backend', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for API calls to complete
      await tester.pump(const Duration(seconds: 3));

      // App should have attempted to load data
      // (Will show either data, loading, or error state)
      expect(find.text('Home Manager'), findsOneWidget);

      // At minimum, the structure should be present
      expect(find.text('Today\'s Tasks'), findsOneWidget);
    });

    testWidgets('App displays loading or data state', (WidgetTester tester) async {
      app.main();

      // Initially might show loading
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Eventually should settle into a stable state
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should not be stuck in perpetual loading
      expect(find.text('Home Manager'), findsOneWidget);
    });
  });

  group('UI Component Integration Tests', () {
    testWidgets('All major UI sections render', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Header card
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Today's Tasks section
      expect(find.text('Today\'s Tasks'), findsOneWidget);

      // Goals section
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('Add Goal'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('App maintains visual hierarchy', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify vertical ordering of elements
      final homeManagement = tester.getTopLeft(find.text('Home Management'));
      final todayTasks = tester.getTopLeft(find.text('Today\'s Tasks'));
      final goals = tester.getTopLeft(find.text('Goals'));

      // Home Management should be above Today's Tasks
      expect(homeManagement.dy < todayTasks.dy, true);

      // Today's Tasks should be above Goals
      expect(todayTasks.dy < goals.dy, true);
    });
  });

  group('Stress Tests', () {
    testWidgets('App handles rapid refresh requests', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshButton = find.byIcon(Icons.refresh);

      // Rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(refreshButton);
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // App should still be functional
      expect(tester.takeException(), isNull);
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('App handles rapid scroll gestures', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final listView = find.byType(ListView);

      // Rapid scrolls
      await tester.drag(listView, const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.drag(listView, const Offset(0, 200));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.drag(listView, const Offset(0, -200));

      await tester.pumpAndSettle();

      // App should remain stable
      expect(tester.takeException(), isNull);
    });
  });
}
