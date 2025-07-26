import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
