import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_mikroitk.dart';
import 'screens/dashboard_screen.dart';
import 'providers/theme_provider.dart';
import './providers/ticket_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TicketProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Gestor de Tickets',
          theme: themeProvider.currentTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => MikrotikConfigScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
