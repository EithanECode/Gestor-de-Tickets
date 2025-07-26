import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/mobile_navigation.dart';
import '../dashboard.dart';
import '../tickets.dart';
import '../estadisticas.dart';
import '../configuracion.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _sections = [
    const DashboardSection(),
    TicketsSection(),
    const EstadisticasSection(),
    const ConfiguracionSection(),
  ];

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLogout() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Scaffold(
        body: _sections[_selectedIndex],
        bottomNavigationBar: MobileNavigation(
          selectedIndex: _selectedIndex,
          onIndexChanged: _onIndexChanged,
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            Sidebar(
              selectedIndex: _selectedIndex,
              onIndexChanged: _onIndexChanged,
              onLogout: _onLogout,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _sections[_selectedIndex],
                    ),
                  ),
                  if (_selectedIndex == 0) const StatusBar(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
