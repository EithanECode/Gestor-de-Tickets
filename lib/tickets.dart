import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/ticket.dart';
import 'providers/ticket_provider.dart';
import 'widgets/ticket_card.dart';
import 'widgets/ticket_list_view.dart';
import 'widgets/ticket_edit_dialog.dart';

class TicketsSection extends StatefulWidget {
  const TicketsSection({super.key});
  @override
  State<TicketsSection> createState() => _TicketsSectionState();
}

class _TicketsSectionState extends State<TicketsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';
  bool _isCardView = true; // true = tarjetas, false = lista
  final Uuid _uuid = Uuid();
  static const String _viewModeKey = 'tickets_view_mode';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadViewMode();
    // Cargar datos de prueba al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ticketProvider = Provider.of<TicketProvider>(
        context,
        listen: false,
      );
      if (ticketProvider.tickets.isEmpty) {
        ticketProvider.generateSampleData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isCardView = prefs.getBool(_viewModeKey) ?? true;
    setState(() {
      _isCardView = isCardView;
    });
  }

  Future<void> _saveViewMode(bool isCardView) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_viewModeKey, isCardView);
  }

  void _toggleViewMode(bool isCardView) {
    setState(() {
      _isCardView = isCardView;
    });
    _saveViewMode(isCardView);
  }

  List<Ticket> _getFilteredTickets(TicketProvider ticketProvider) {
    List<Ticket> filteredTickets = ticketProvider.tickets.where((ticket) => !ticket.isDeleted).toList();

    // Filtrar por búsqueda
    if (_search.isNotEmpty) {
      filteredTickets = filteredTickets.where((ticket) {
        return ticket.nombre.toLowerCase().contains(_search.toLowerCase()) ||
               (ticket.cliente?.toLowerCase().contains(_search.toLowerCase()) ?? false);
      }).toList();
    }

    // Filtrar por tab
    switch (_tabController.index) {
      case 0: // Todos
        break;
      case 1: // Disponibles
        filteredTickets = filteredTickets.where((ticket) => ticket.status == TicketStatus.disponible).toList();
        break;
      case 2: // En Uso
        filteredTickets = filteredTickets.where((ticket) => ticket.status == TicketStatus.enUso).toList();
        break;
      case 3: // Utilizados
        filteredTickets = filteredTickets.where((ticket) => ticket.status == TicketStatus.utilizado).toList();
        break;
    }

    return filteredTickets;
  }

  void _showAddTicketDialog(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    final TextEditingController nombreController = TextEditingController();

    String generateCode() {
      final random = Random();
      String code;
      do {
        code = (10000 + random.nextInt(90000)).toString();
      } while (ticketProvider.tickets.any((ticket) => ticket.nombre == code));
      return code;
    }
    nombreController.text = generateCode();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Nuevo Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Código del Ticket (5 dígitos)',
                border: OutlineInputBorder(),
                helperText: 'Ingrese un código de 5 dígitos únicos',
              ),
              keyboardType: TextInputType.number,
              maxLength: 5,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingrese un código';
                if (value.length != 5) return 'El código debe tener 5 dígitos';
                if (!RegExp(r'^\d{5}$').hasMatch(value)) return 'Solo se permiten números';
                if (ticketProvider.tickets.any((ticket) => ticket.nombre == value)) return 'Este código ya existe';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () { nombreController.text = generateCode(); },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Generar Nuevo Código'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isNotEmpty &&
                  nombreController.text.length == 5 &&
                  RegExp(r'^\d{5}$').hasMatch(nombreController.text) &&
                  !ticketProvider.tickets.any((ticket) => ticket.nombre == nombreController.text)) {
                final newTicket = Ticket(
                  id: 'TICKET-${_uuid.v4().substring(0, 8).toUpperCase()}',
                  nombre: nombreController.text,
                  status: TicketStatus.disponible,
                  fechaCreacion: DateTime.now(),
                );
                ticketProvider.addTicket(newTicket);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Ticket ticket) async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    final result = await showDialog<Ticket>(
      context: context,
      builder: (context) => TicketEditDialog(ticket: ticket),
    );

    if (!mounted) return;

    if (result != null) {
      await ticketProvider.updateTicket(result);
    }
  }

  void _deleteTicket(BuildContext context, Ticket ticket) async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar el ticket ${ticket.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      await ticketProvider.deleteTicket(ticket.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        final filteredTickets = _getFilteredTickets(ticketProvider);
        
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTicketDialog(context),
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: EdgeInsets.all(isMobile ? 8 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selection mode AppBar replacement with animated appearance
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, anim) {
                      final offsetAnim = Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(anim);
                      return FadeTransition(opacity: anim, child: SlideTransition(position: offsetAnim, child: child));
                    },
                    child: ticketProvider.isSelectionMode
                        ? Container(
                            key: const ValueKey('selection_header'),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Cancel selection
                                    ticketProvider.clearSelection();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('${ticketProvider.selectedCount} seleccionados', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                IconButton(
                                  onPressed: ticketProvider.selectedCount > 0
                                      ? () async {
                                          final selected = ticketProvider.selectedIds;
                                          final tickets = ticketProvider.tickets.where((t) => selected.contains(t.id)).map((t) => t.nombre).join('\n');
                                          await SharePlus.instance.share(ShareParams(text: tickets));
                                          if (!mounted) return;
                                          ticketProvider.clearSelection();
                                        }
                                      : null,
                                  icon: const Icon(Icons.share),
                                  tooltip: 'Compartir',
                                ),
                                IconButton(
                                  onPressed: ticketProvider.selectedCount > 0
                                      ? () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Eliminar tickets seleccionados'),
                                              content: Text('¿Eliminar ${ticketProvider.selectedCount} tickets? Esta acción se puede deshacer.'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                                                ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Eliminar')),
                                              ],
                                            ),
                                          );
                                          if (confirmed == true) {
                                            final selected = ticketProvider.selectedIds.toList();
                                            for (final id in selected) {
                                              await ticketProvider.deleteTicket(id);
                                            }
                                            ticketProvider.clearSelection();
                                            if (!mounted) return;
                                            final count = selected.length;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('$count tickets eliminados'),
                                                action: SnackBarAction(
                                                  label: 'Deshacer',
                                                  onPressed: () async {
                                                    for (final id in selected) {
                                                      await ticketProvider.restoreTicket(id);
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  tooltip: 'Eliminar',
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                // Barra de búsqueda y toggle de vista
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Buscar tickets...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) => setState(() => _search = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                        // ... existing code ...
                    // Toggle de vista
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _toggleViewMode(false),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: !_isCardView ? Theme.of(context).primaryColor : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Icon(
                                Icons.view_list,
                                color: !_isCardView ? Colors.white : Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _toggleViewMode(true),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _isCardView ? Theme.of(context).primaryColor : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Icon(
                                Icons.view_module,
                                color: _isCardView ? Colors.white : Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'Todos'),
                    Tab(text: 'Disponibles'),
                    Tab(text: 'En Uso'),
                    Tab(text: 'Utilizados'),
                  ],
                  onTap: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                
                // Loading y error states
                if (ticketProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (ticketProvider.error.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ticketProvider.error)),
                        IconButton(
                          onPressed: () => ticketProvider.clearError(),
                          icon: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                  ),
                
                // Lista de tickets
                Expanded(
                  child: filteredTickets.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.confirmation_number, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No hay tickets', style: TextStyle(fontSize: 18, color: Colors.grey)),
                            ],
                          ),
                        )
                      : _isCardView
                          ? ListView.builder(
                              itemCount: filteredTickets.length,
                              itemBuilder: (context, index) {
                                final ticket = filteredTickets[index];
                                return TicketCard(
                                  ticket: ticket,
                                  onTap: () {
                                    if (ticketProvider.isSelectionMode) {
                                      ticketProvider.toggleSelection(ticket.id);
                                    } else {
                                      _showEditDialog(context, ticket);
                                    }
                                  },
                                  onLongPress: () => ticketProvider.enterSelectionMode(ticket.id),
                                  onDelete: () => _deleteTicket(context, ticket),
                                  isSelected: ticketProvider.selectedIds.contains(ticket.id),
                                  onSelectToggle: () => ticketProvider.toggleSelection(ticket.id),
                                );
                              },
                            )
                          : TicketListView(
                              tickets: filteredTickets,
                              onDelete: (ticket) => _deleteTicket(context, ticket),
                              onTap: (ticket) {
                                if (ticketProvider.isSelectionMode) {
                                  ticketProvider.toggleSelection(ticket.id);
                                } else {
                                  _showEditDialog(context, ticket);
                                }
                              },
                              onLongPress: (ticket) => ticketProvider.enterSelectionMode(ticket.id),
                              selectedIds: ticketProvider.selectedIds,
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
