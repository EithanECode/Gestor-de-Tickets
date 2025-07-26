import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_mikroitk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Tickets',
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF2196F3),
          background: const Color(0xFFF4F8FB),
          error: const Color(0xFFE53935),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MikrotikConfigScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _sections = [
    // Dashboard con tarjetas de dispositivos conectados
    Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dispositivos conectados',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                DeviceCard(
                  ip: '192.168.0.2',
                  mac: '00-0C-42-1F-65-3A',
                  user: 'user1',
                  time: '2:15',
                  data: '1.1',
                  quota: '5.0',
                  bandwidth: '100',
                ),
                DeviceCard(
                  ip: '192.168.0.3',
                  mac: '00-0C-42-1F-65-3B',
                  user: 'user2',
                  time: '1:10',
                  data: '0.8',
                  quota: '5.0',
                  bandwidth: '100',
                ),
                DeviceCard(
                  ip: '192.168.0.4',
                  mac: '00-0C-42-1F-65-3C',
                  user: 'user3',
                  time: '0:45',
                  data: '0.5',
                  quota: '5.0',
                  bandwidth: '100',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    // Tickets con Tabs, botón crear y búsqueda, lista de filas
    TicketsSection(),
    const Center(child: Text('Estadísticas', style: TextStyle(fontSize: 28))),
    const Center(child: Text('Configuración', style: TextStyle(fontSize: 28))),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      // Navegación inferior para móvil
      return Scaffold(
        body: _sections[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Estadísticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configuración',
            ),
          ],
        ),
      );
    } else {
      // NavigationRail para escritorio/tablet
      return Scaffold(
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Icono/nombre superior
                    const Icon(
                      Icons.confirmation_number,
                      color: Colors.white,
                      size: 36,
                    ),
                    const SizedBox(height: 32),
                    // Iconos principales centrados
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SidebarIcon(
                            icon: Icons.dashboard,
                            selected: _selectedIndex == 0,
                            onTap: () => setState(() => _selectedIndex = 0),
                          ),
                          const SizedBox(height: 16),
                          _SidebarIcon(
                            icon: Icons.confirmation_number,
                            selected: _selectedIndex == 1,
                            onTap: () => setState(() => _selectedIndex = 1),
                          ),
                          const SizedBox(height: 16),
                          _SidebarIcon(
                            icon: Icons.bar_chart,
                            selected: _selectedIndex == 2,
                            onTap: () => setState(() => _selectedIndex = 2),
                          ),
                          const SizedBox(height: 16),
                          _SidebarIcon(
                            icon: Icons.settings,
                            selected: _selectedIndex == 3,
                            onTap: () => setState(() => _selectedIndex = 3),
                          ),
                        ],
                      ),
                    ),
                    // Botón de cerrar sesión centrado en la parte inferior
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Center(
                        child: _SidebarIcon(
                          icon: Icons.logout,
                          selected: false,
                          onTap: () {
                            // Acción de cerrar sesión (puedes personalizarla)
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Contenido principal
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _sections[_selectedIndex],
                    ),
                  ),
                  // Barra de estado solo en el área de contenido
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: const Color(0xFF2196F3),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Accounts: 12',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.computer,
                                      color: const Color(0xFF2196F3),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Online: 3',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  static const List<IconData> _navIcons = [
    Icons.dashboard,
    Icons.confirmation_number,
    Icons.bar_chart,
    Icons.settings,
  ];
  static const List<String> _navLabels = [
    'Dashboard',
    'Tickets',
    'Estadísticas',
    'Configuración',
  ];
}

class _SidebarIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _SidebarIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: selected ? Colors.white : const Color(0xFF90CAF9),
            size: selected ? 28 : 24,
          ),
        ),
      ),
    );
  }
}

class _TicketSummary extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  const _TicketSummary({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String ip;
  final String mac;
  final String user;
  final String time;
  final String data;
  final String quota;
  final String bandwidth;
  const DeviceCard({
    required this.ip,
    required this.mac,
    required this.user,
    required this.time,
    required this.data,
    required this.quota,
    required this.bandwidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.computer, size: 32, color: Color(0xFF1976D2)),
                      const SizedBox(width: 12),
                      Text(
                        'IP: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(ip),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'MAC: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(mac),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Usuario: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(user),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tiempo: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(time),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Datos: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$data GB'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Cuota: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$quota GB'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Banda: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$bandwidth Mbps'),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(
                    Icons.computer,
                    size: 40,
                    color: Color(0xFF1976D2),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'IP: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(ip),
                            const SizedBox(width: 24),
                            Text(
                              'MAC: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(mac),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Usuario: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(user),
                            const SizedBox(width: 24),
                            Text(
                              'Tiempo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(time),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Datos: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$data GB'),
                            const SizedBox(width: 24),
                            Text(
                              'Cuota: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$quota GB'),
                            const SizedBox(width: 24),
                            Text(
                              'Banda: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$bandwidth Mbps'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// --- Tickets Section ---
class TicketsSection extends StatefulWidget {
  @override
  State<TicketsSection> createState() => _TicketsSectionState();
}

class _TicketsSectionState extends State<TicketsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';

  final List<Map<String, dynamic>> _allTickets = [
    {'nombre': 'Ticket 1', 'usado': false, 'fecha': '2024-06-01'},
    {'nombre': 'Ticket 2', 'usado': true, 'fecha': '2024-06-01'},
    {'nombre': 'Ticket 3', 'usado': false, 'fecha': '2024-06-02'},
    {'nombre': 'Ticket 4', 'usado': true, 'fecha': '2024-06-02'},
    {'nombre': 'Ticket 5', 'usado': false, 'fecha': '2024-06-03'},
  ];

  List<Map<String, dynamic>> _deletedTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTickets {
    List<Map<String, dynamic>> filtered = _allTickets
        .where((t) => t['nombre'].toLowerCase().contains(_search.toLowerCase()))
        .toList();
    if (_tabController.index == 1) {
      filtered = filtered.where((t) => t['usado'] == true).toList();
    } else if (_tabController.index == 2) {
      filtered = filtered.where((t) => t['usado'] == false).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Botón eliminado, solo campo de búsqueda
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) => setState(() => _search = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Todos'),
                Tab(text: 'Usados'),
                Tab(text: 'No usados'),
              ],
              onTap: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredTickets.isEmpty
                  ? const Center(child: Text('No hay tickets'))
                  : ListView.separated(
                      itemCount: _filteredTickets.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final t = _filteredTickets[i];
                        final ticketIndex = _allTickets.indexOf(t);
                        return Dismissible(
                          key: ValueKey(t['nombre'] + t['fecha'].toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              _deletedTickets.add(t);
                              _allTickets.removeAt(ticketIndex);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Ticket eliminado con éxito',
                                ),
                                action: SnackBarAction(
                                  label: 'Restaurar',
                                  onPressed: () {
                                    if (!mounted) return;
                                    setState(() {
                                      _allTickets.insert(ticketIndex, t);
                                      _deletedTickets.remove(t);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: SizedBox(
                              width: 44,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.ticket,
                                    color: Theme.of(context).primaryColor,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 4),
                                  Icon(
                                    t['usado']
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: t['usado']
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              t['nombre'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text('Fecha: ${t['fecha']}'),
                              ],
                            ),
                            trailing: Text(
                              t['usado'] ? 'Usado' : 'No usado',
                              style: TextStyle(
                                color: t['usado'] ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
