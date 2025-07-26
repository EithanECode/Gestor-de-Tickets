import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/ticket.dart';

class TicketListView extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket) onEdit;
  final Function(Ticket) onDelete;

  const TicketListView({
    super.key,
    required this.tickets,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Dismissible(
          key: ValueKey(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => onDelete(ticket),
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
                    _getStatusIcon(ticket.status),
                    color: _getStatusColor(ticket.status),
                    size: 18,
                  ),
                ],
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
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('Fecha: ${_formatDate(ticket.fechaCreacion)}'),
                  ],
                ),
                if (ticket.cliente != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Cliente: ${ticket.cliente}'),
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
                IconButton(
                  onPressed: () => onEdit(ticket),
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Editar ticket',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(TicketStatus status) {
    switch (status) {
      case TicketStatus.disponible:
        return Icons.check_circle;
      case TicketStatus.enUso:
        return Icons.play_circle;
      case TicketStatus.utilizado:
        return Icons.done_all;
      case TicketStatus.anulado:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.disponible:
        return Colors.green;
      case TicketStatus.enUso:
        return Colors.orange;
      case TicketStatus.utilizado:
        return Colors.blue;
      case TicketStatus.anulado:
        return Colors.red;
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
