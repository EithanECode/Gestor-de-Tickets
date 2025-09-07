// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestor_tickets/main.dart';
import 'package:provider/provider.dart';
import 'package:gestor_tickets/providers/theme_provider.dart';
import 'package:gestor_tickets/providers/ticket_provider.dart';

void main() {
  testWidgets('Smoke test: app builds and shows Mikrotik config title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => TicketProvider()),
        ],
        child: const MyApp(),
      ),
    );

  // Verify the initial screen shows the Mikrotik configuration title
  await tester.pumpAndSettle();
  expect(find.text('Configuración de Mikrotik'), findsOneWidget);
  });
}
