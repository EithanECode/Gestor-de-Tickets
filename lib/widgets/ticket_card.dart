import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChange;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onDelete,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                        Text(
                          ticket.id,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 12),

              // Nombre del ticket
              Text(
                ticket.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Información del cliente (si existe)
              if (ticket.cliente != null) ...[
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Cliente: ${ticket.cliente}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],

              // Fechas
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Creado: ${_formatDate(ticket.fechaCreacion)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),

              // Información adicional si está en uso
              if (ticket.status == TicketStatus.enUso) ...[
                const SizedBox(height: 8),
                _buildUsageInfo(context),
              ],

              // Acciones
              const SizedBox(height: 12),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (ticket.status) {
      case TicketStatus.disponible:
        color = Colors.green;
        text = 'Disponible';
        icon = Icons.check_circle;
        break;
      case TicketStatus.enUso:
        color = Colors.orange;
        text = 'En Uso';
        icon = Icons.play_circle;
        break;
      case TicketStatus.utilizado:
        color = Colors.blue;
        text = 'Utilizado';
        icon = Icons.done_all;
        break;
      case TicketStatus.anulado:
        color = Colors.red;
        text = 'Anulado';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
        if (onStatusChange != null) ...[
          TextButton.icon(
            onPressed: onStatusChange,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Cambiar Estado'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 8),
        ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
