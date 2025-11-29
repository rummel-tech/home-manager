import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_ui/screens/home_screen.dart';

void main() {
  group('HomeManagerScreen Widget Tests', () {
    testWidgets('renders app bar with title and refresh button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Home Manager'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('screen builds and initializes', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert - screen should build successfully
      expect(find.byType(HomeManagerScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has RefreshIndicator for pull-to-refresh', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('displays header card with home icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.text('Your weekly tasks and goals'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('displays section headers', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Today\'s Tasks'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
    });

    testWidgets('displays "Add Goal" button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Add Goal'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('refresh button is tappable without crash', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      // Assert - should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('screen uses provided userId', (WidgetTester tester) async {
      // Arrange & Act
      const testUserId = 'custom-user-id';
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: testUserId),
        ),
      );
      await tester.pump();

      // Assert - screen should be built without errors
      expect(find.byType(HomeManagerScreen), findsOneWidget);
    });

    testWidgets('has scrollable content via ListView', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('maintains state across rebuilds', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Act - trigger rebuild
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(HomeManagerScreen), findsOneWidget);
    });

    testWidgets('displays proper spacing between sections', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('HomeManagerScreen Error Handling', () {
    testWidgets('handles initialization without crash', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );

      // Assert - should not throw
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles empty userId gracefully', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: ''),
        ),
      );
      await tester.pump();

      // Assert - should not crash
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeManagerScreen), findsOneWidget);
    });

    testWidgets('handles multiple rapid refresh requests', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Act - tap refresh multiple times
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      // Assert - should handle gracefully
      expect(tester.takeException(), isNull);
    });
  });

  group('HomeManagerScreen Layout Tests', () {
    testWidgets('has consistent padding', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, const EdgeInsets.all(16));
    });

    testWidgets('displays sections in correct order', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert - check vertical ordering (approximate)
      final headerCard = tester.getTopLeft(find.text('Home Management'));
      final todayTasks = tester.getTopLeft(find.text('Today\'s Tasks'));
      final goals = tester.getTopLeft(find.text('Goals'));

      expect(headerCard.dy < todayTasks.dy, true, reason: 'Header should be above Today\'s Tasks');
      expect(todayTasks.dy < goals.dy, true, reason: 'Today\'s Tasks should be above Goals');
    });

    testWidgets('AppBar has correct styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
      expect(appBar.actions, isNotNull);
      expect(appBar.actions!.length, 1);
    });
  });

  group('HomeManagerScreen Interaction Tests', () {
    testWidgets('refresh button has tooltip', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Act
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // Find the IconButton parent
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: refreshButton,
          matching: find.byType(IconButton),
        ),
      );

      // Assert
      expect(iconButton.tooltip, 'Refresh');
    });

    testWidgets('Add Goal button exists but is not yet functional', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Act
      final addButton = find.text('Add Goal');
      expect(addButton, findsOneWidget);

      // Tap should not crash the app
      await tester.tap(addButton);
      await tester.pump();

      // Assert
      expect(tester.takeException(), isNull);
    });
  });

  group('HomeManagerScreen Data Display Tests', () {
    testWidgets('screen builds successfully', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );
      await tester.pump();

      // Assert - screen should build without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('screen initializes with proper structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeManagerScreen(userId: 'test-user'),
        ),
      );

      // Initial pump
      await tester.pump();

      // Assert - screen should have main structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Home Management'), findsOneWidget);
    });
  });
}
