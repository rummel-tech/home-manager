import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_ui/ui_components/goal_card.dart';

void main() {
  group('GoalCard Widget Tests', () {
    testWidgets('renders goal card with all properties', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Test Goal',
              description: 'Test Description',
              category: 'cleaning',
              targetDate: '2025-12-31',
              progress: 75,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Goal'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Target: 2025-12-31'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders goal card without optional fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Simple Goal',
              category: 'organizing',
              progress: 50,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Simple Goal'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      // Should not find description or target date
      expect(find.textContaining('Target:'), findsNothing);
    });

    testWidgets('displays correct icon for each category', (WidgetTester tester) async {
      final categories = {
        'cleaning': Icons.cleaning_services,
        'organizing': Icons.folder_outlined,
        'cooking': Icons.restaurant,
        'outdoor': Icons.yard,
        'unknown': Icons.flag, // default case
      };

      for (var entry in categories.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GoalCard(
                title: 'Test Goal',
                category: entry.key,
                progress: 50,
              ),
            ),
          ),
        );

        expect(find.byIcon(entry.value), findsOneWidget,
            reason: 'Icon for ${entry.key} should be ${entry.value}');
      }
    });

    testWidgets('progress indicator shows correct value', (WidgetTester tester) async {
      // Test 0% progress
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Zero Progress',
              category: 'cleaning',
              progress: 0,
            ),
          ),
        ),
      );

      var indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.0);
      expect(find.text('0%'), findsOneWidget);

      // Test 50% progress
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Half Progress',
              category: 'cleaning',
              progress: 50,
            ),
          ),
        ),
      );

      indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.5);
      expect(find.text('50%'), findsOneWidget);

      // Test 100% progress
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Complete',
              category: 'cleaning',
              progress: 100,
            ),
          ),
        ),
      );

      indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 1.0);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      bool tapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Test Goal',
              category: 'cleaning',
              progress: 50,
              onTap: () {
                tapCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('displays target date when provided', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Goal with Date',
              category: 'cleaning',
              progress: 50,
              targetDate: '2025-06-15',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Target: 2025-06-15'), findsOneWidget);
    });

    testWidgets('does not display target date when not provided', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Goal without Date',
              category: 'cleaning',
              progress: 50,
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Target:'), findsNothing);
    });

    testWidgets('displays description when provided', (WidgetTester tester) async {
      // Arrange
      const description = 'This is a detailed goal description';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Goal with Description',
              category: 'cleaning',
              progress: 50,
              description: description,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(description), findsOneWidget);
    });

    testWidgets('does not display description when empty', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Goal',
              category: 'cleaning',
              progress: 50,
              description: '',
            ),
          ),
        ),
      );

      // Assert - only check for title and progress
      expect(find.text('Goal'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('card has correct elevation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Test Goal',
              category: 'cleaning',
              progress: 50,
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('handles various progress values correctly', (WidgetTester tester) async {
      final progressValues = [0, 25, 50, 75, 100];

      for (var progress in progressValues) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GoalCard(
                title: 'Test Goal',
                category: 'cleaning',
                progress: progress,
              ),
            ),
          ),
        );

        expect(find.text('$progress%'), findsOneWidget);
        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.value, progress / 100);
      }
    });

    testWidgets('CircleAvatar has correct category icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCard(
              title: 'Test Goal',
              category: 'outdoor',
              progress: 50,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.yard), findsOneWidget);
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.child, isA<Icon>());
    });
  });
}
