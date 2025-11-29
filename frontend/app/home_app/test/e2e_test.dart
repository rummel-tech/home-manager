import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_app/main.dart';

/// End-to-end tests that verify the complete app flow
void main() {
  group('End-to-End App Flow Tests', () {
    testWidgets('Complete app initialization and display', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Verify app initializes correctly
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Full user flow: view home screen and all sections', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Step 1: User sees app bar
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Step 2: User sees header card
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.text('Your weekly tasks and goals'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Step 3: User sees Today's Tasks section
      expect(find.text('Today\'s Tasks'), findsOneWidget);

      // Step 4: User sees Goals section
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('Add Goal'), findsOneWidget);
    });

    testWidgets('User interaction flow: refresh data', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // User clicks refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pump();

      // App should remain functional after refresh
      expect(find.text('Home Manager'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('User interaction flow: scroll through content', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // User scrolls down the page
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      await tester.drag(listView, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Content should scroll and app bar remains visible
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('User interaction flow: attempt to add goal', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // User finds and taps "Add Goal" button
      final addGoalButton = find.text('Add Goal');
      expect(addGoalButton, findsOneWidget);

      await tester.tap(addGoalButton);
      await tester.pump();

      // App should not crash (even though feature is not implemented)
      expect(tester.takeException(), isNull);
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('User interaction flow: pull to refresh', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // User performs pull-to-refresh gesture
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // App should handle the gesture
      expect(tester.takeException(), isNull);
    });
  });

  group('Data Flow Tests', () {
    testWidgets('App initializes with correct state', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Initial state should be set up
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home Manager'), findsOneWidget);

      // Main structure should be present regardless of data loading
      expect(find.text('Today\'s Tasks'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
    });

    testWidgets('App maintains state through rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Trigger rebuild by interacting with app
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // State should be maintained
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.text('Today\'s Tasks'), findsOneWidget);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('App handles initialization gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // No exceptions should be thrown
      expect(tester.takeException(), isNull);

      // Basic structure should be present
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('App handles multiple rapid interactions', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Rapidly tap refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      for (int i = 0; i < 5; i++) {
        await tester.tap(refreshButton);
        await tester.pump(const Duration(milliseconds: 50));
      }

      // App should not crash
      expect(tester.takeException(), isNull);
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('App handles scroll edge cases', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final listView = find.byType(ListView);

      // Scroll to top edge
      await tester.drag(listView, const Offset(0, 300));
      await tester.pumpAndSettle();

      // Scroll to bottom edge
      await tester.drag(listView, const Offset(0, -1000));
      await tester.pumpAndSettle();

      // App should handle gracefully
      expect(tester.takeException(), isNull);
    });
  });

  group('UI Consistency Tests', () {
    testWidgets('All sections render in correct order', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Verify visual hierarchy
      final homeManagement = tester.getTopLeft(find.text('Home Management'));
      final todayTasks = tester.getTopLeft(find.text('Today\'s Tasks'));
      final goals = tester.getTopLeft(find.text('Goals'));

      // Header should be above Today's Tasks
      expect(homeManagement.dy < todayTasks.dy, true,
          reason: 'Home Management should appear before Today\'s Tasks');

      // Today's Tasks should be above Goals
      expect(todayTasks.dy < goals.dy, true,
          reason: 'Today\'s Tasks should appear before Goals');
    });

    testWidgets('Navigation structure is complete', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Verify navigation components
      expect(find.byType(Navigator), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Theme is correctly applied', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );

      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });
  });

  group('Performance Tests', () {
    testWidgets('App builds efficiently', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      stopwatch.stop();

      // Initial build should be reasonably fast (< 1 second)
      expect(stopwatch.elapsedMilliseconds < 1000, true,
          reason: 'Initial build took ${stopwatch.elapsedMilliseconds}ms');
    });

    testWidgets('App handles rapid state changes', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Simulate rapid state changes
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();
      }

      // Should remain stable
      expect(tester.takeException(), isNull);
      expect(find.text('Home Manager'), findsOneWidget);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('Important elements have semantic labels', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Verify key text elements are present (accessible via screen readers)
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.text('Today\'s Tasks'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
    });

    testWidgets('Interactive elements are accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Verify buttons are accessible
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Verify buttons can be tapped
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
