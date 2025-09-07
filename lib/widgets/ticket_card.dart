import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/ticket.dart';
import '../services/ticket_print_service.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final VoidCallback? onSelectToggle;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onDelete,
    this.onLongPress,
    this.isSelected = false,
    this.onSelectToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.06)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.9))
                    : Border.all(color: Colors.transparent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header con ID y estado
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.ticket,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ticket.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 8),

              // Información del ticket
              if (ticket.cliente != null && ticket.cliente!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cliente: ${ticket.cliente}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],

              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Creado: ${_formatDate(ticket.fechaCreacion)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),

              if (ticket.fechaUso != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Usado: ${_formatDate(ticket.fechaUso!)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],

              // Información adicional si está en uso
              if (ticket.status == TicketStatus.enUso) ...[
                const SizedBox(height: 8),
                _buildUsageInfo(context),
              ],

              const SizedBox(height: 12),

                  // Acciones
                  _buildActions(context),
                ],
              ),
            ),
            // Fixed check badge in corner when selected
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 4)],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ticket.dispositivoIp != null)
            Row(
              children: [
                Icon(Icons.computer, size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  'IP: ${ticket.dispositivoIp}',
                  style: TextStyle(color: Colors.blue[700], fontSize: 12),
                ),
              ],
            ),
          if (ticket.datosConsumidos != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.data_usage, size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  'Datos: ${ticket.datosConsumidos!.toStringAsFixed(1)} GB',
                  style: TextStyle(color: Colors.blue[700], fontSize: 12),
                ),
              ],
            ),
          ],
          if (ticket.tiempoUso != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  'Tiempo: ${_formatDuration(ticket.tiempoUso!)}',
                  style: TextStyle(color: Colors.blue[700], fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón de imprimir
        IconButton(
          onPressed: () => _printTicket(context),
          icon: const Icon(Icons.print, size: 20),
          color: Colors.blue,
          tooltip: 'Imprimir ticket',
        ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            tooltip: 'Eliminar ticket',
          ),
      ],
    );
  }

  Future<void> _printTicket(BuildContext context) async {
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

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String text;

    switch (ticket.status) {
      case TicketStatus.disponible:
        color = Colors.green;
        text = 'Disponible';
        break;
      case TicketStatus.enUso:
        color = Colors.orange;
        text = 'En Uso';
        break;
      case TicketStatus.utilizado:
        color = Colors.grey;
        text = 'Utilizado';
        break;
      case TicketStatus.anulado:
        color = Colors.red;
        text = 'Anulado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
