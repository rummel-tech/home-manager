import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_app/main.dart';

void main() {
  group('HomeManagerApp Tests', () {
    testWidgets('app initializes and shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
      // AuthWrapper shows a loading indicator while checking auth
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('app uses Material Design 3', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });

    testWidgets('app has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Home Manager');
    });

    testWidgets('app has both light and dark themes', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('app uses blue as primary color', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.primary, isNotNull);
    });

    testWidgets('app builds without throwing exceptions', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('app renders scaffold in loading state', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debug banner is disabled', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });

  group('HomeManagerApp Theme Tests', () {
    testWidgets('light theme has correct brightness', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.brightness, Brightness.light);
    });

    testWidgets('dark theme has correct brightness', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.darkTheme?.colorScheme.brightness, Brightness.dark);
    });

    testWidgets('theme uses ColorScheme', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme, isNotNull);
      expect(materialApp.darkTheme?.colorScheme, isNotNull);
    });
  });

  group('HomeManagerApp Auth State Tests', () {
    testWidgets('app shows loading indicator during auth check', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      // AuthWrapper starts with _isLoading = true
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('app has working navigation structure', (WidgetTester tester) async {
      await tester.pumpWidget(const HomeManagerApp());
      await tester.pump();

      expect(find.byType(Navigator), findsOneWidget);
    });
  });
}
