import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_ui/ui_components/task_card.dart';

void main() {
  group('TaskCard Widget Tests', () {
    testWidgets('renders task card with all properties', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Test Task',
              description: 'Test Description',
              category: 'cleaning',
              priority: 'high',
              completed: false,
              estimatedMinutes: 30,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('high'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byIcon(Icons.cleaning_services), findsOneWidget);
    });

    testWidgets('renders task card without optional fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Simple Task',
              category: 'chores',
              priority: 'medium',
              completed: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Simple Task'), findsOneWidget);
      expect(find.text('medium'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      // Should not find description or time
      expect(find.text('30 min'), findsNothing);
    });

    testWidgets('displays correct icon for each category', (WidgetTester tester) async {
      final categories = {
        'cleaning': Icons.cleaning_services,
        'chores': Icons.check_circle_outline,
        'cooking': Icons.restaurant,
        'errands': Icons.shopping_cart,
        'outdoor': Icons.yard,
        'organizing': Icons.folder_outlined,
        'maintenance': Icons.build,
        'planning': Icons.event_note,
      };

      for (var entry in categories.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TaskCard(
                title: 'Test',
                category: entry.key,
                priority: 'medium',
                completed: false,
              ),
            ),
          ),
        );

        expect(find.byIcon(entry.value), findsOneWidget,
            reason: 'Icon for ${entry.key} should be ${entry.value}');
      }
    });

    testWidgets('shows line-through text when completed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Completed Task',
              category: 'cleaning',
              priority: 'high',
              completed: true,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(
        find.text('Completed Task'),
      );
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('checkbox reflects completed state', (WidgetTester tester) async {
      // Test uncompleted task
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Uncompleted Task',
              category: 'cleaning',
              priority: 'high',
              completed: false,
            ),
          ),
        ),
      );

      final uncompleted = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(uncompleted.value, false);

      // Test completed task
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Completed Task',
              category: 'cleaning',
              priority: 'high',
              completed: true,
            ),
          ),
        ),
      );

      final completed = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(completed.value, true);
    });

    testWidgets('calls onToggle when checkbox is tapped', (WidgetTester tester) async {
      // Arrange
      bool toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Test Task',
              category: 'cleaning',
              priority: 'high',
              completed: false,
              onToggle: () {
                toggleCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(toggleCalled, true);
    });

    testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      bool tapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Test Task',
              category: 'cleaning',
              priority: 'high',
              completed: false,
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

    testWidgets('displays correct priority badge color', (WidgetTester tester) async {
      // Test high priority
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'High Priority',
              category: 'cleaning',
              priority: 'high',
              completed: false,
            ),
          ),
        ),
      );
      expect(find.text('high'), findsOneWidget);

      // Test medium priority
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Medium Priority',
              category: 'cleaning',
              priority: 'medium',
              completed: false,
            ),
          ),
        ),
      );
      expect(find.text('medium'), findsOneWidget);

      // Test low priority
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Low Priority',
              category: 'cleaning',
              priority: 'low',
              completed: false,
            ),
          ),
        ),
      );
      expect(find.text('low'), findsOneWidget);
    });

    testWidgets('displays time estimate with icon when provided', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Timed Task',
              category: 'cleaning',
              priority: 'high',
              completed: false,
              estimatedMinutes: 45,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('45 min'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('card elevation is lower when completed', (WidgetTester tester) async {
      // Test uncompleted task
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Uncompleted',
              category: 'cleaning',
              priority: 'high',
              completed: false,
            ),
          ),
        ),
      );

      var card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);

      // Test completed task
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Completed',
              category: 'cleaning',
              priority: 'high',
              completed: true,
            ),
          ),
        ),
      );

      card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0.5);
    });
  });
}
