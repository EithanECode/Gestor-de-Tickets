import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/ticket.dart';
import '../services/ticket_print_service.dart';

class TicketListView extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket) onDelete;

  const TicketListView({
    super.key,
    required this.tickets,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tickets.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Dismissible(
          key: Key(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar eliminación'),
                content: Text(
                  '¿Estás seguro de que quieres eliminar el ticket ${ticket.nombre}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) => onDelete(ticket),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: FaIcon(
                FontAwesomeIcons.ticket,
                color: Colors.blue,
                size: 20,
              ),
            ),
            title: Text(
              ticket.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('Creado: ${_formatDate(ticket.fechaCreacion)}'),
                  ],
                ),
                if (ticket.cliente != null && ticket.cliente!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Cliente: ${ticket.cliente}'),
                    ],
                  ),
                ],
                if (ticket.fechaUso != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text('Usado: ${_formatDate(ticket.fechaUso!)}'),
                    ],
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getStatusText(ticket.status),
                  style: TextStyle(
                    color: _getStatusColor(ticket.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                // Botón de imprimir
                IconButton(
                  onPressed: () => _printTicket(context, ticket),
                  icon: const Icon(Icons.print, size: 18),
                  color: Colors.blue,
                  tooltip: 'Imprimir ticket',
                ),
                // Botón de eliminar
                IconButton(
                  onPressed: () => onDelete(ticket),
                  icon: const Icon(Icons.delete, size: 18),
                  color: Colors.red,
                  tooltip: 'Eliminar ticket',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _printTicket(BuildContext context, Ticket ticket) async {
    try {
      await TicketPrintService.printTicket(ticket);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al imprimir: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.disponible:
        return 'Disponible';
      case TicketStatus.enUso:
        return 'En Uso';
      case TicketStatus.utilizado:
        return 'Utilizado';
      case TicketStatus.anulado:
        return 'Anulado';
    }
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.disponible:
        return Colors.green;
      case TicketStatus.enUso:
        return Colors.orange;
      case TicketStatus.utilizado:
        return Colors.grey;
      case TicketStatus.anulado:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
