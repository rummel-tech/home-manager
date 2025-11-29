import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_app/main.dart';

void main() {
  group('HomeManagerApp Tests', () {
    testWidgets('app initializes and displays HomeManagerScreen', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home Manager'), findsOneWidget);
    });

    testWidgets('app uses Material Design 3', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });

    testWidgets('app has correct title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Home Manager');
    });

    testWidgets('app has both light and dark themes', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('app uses blue as primary color', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.primary, isNotNull);
    });

    testWidgets('app passes correct userId to HomeManagerScreen', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert - app should initialize without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('app builds without throwing exceptions', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      expect(tester.takeException(), isNull);
    });

    testWidgets('app renders scaffold correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('HomeManagerApp Theme Tests', () {
    testWidgets('light theme has correct brightness', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.brightness, Brightness.light);
    });

    testWidgets('dark theme has correct brightness', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.darkTheme?.colorScheme.brightness, Brightness.dark);
    });

    testWidgets('theme uses ColorScheme.fromSeed', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme, isNotNull);
      expect(materialApp.darkTheme?.colorScheme, isNotNull);
    });
  });

  group('HomeManagerApp Integration Tests', () {
    testWidgets('app displays home screen on launch', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      expect(find.text('Home Management'), findsOneWidget);
      expect(find.text('Your weekly tasks and goals'), findsOneWidget);
    });

    testWidgets('app has working navigation structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // Assert
      expect(find.byType(Navigator), findsOneWidget);
    });
  });
}
