import 'package:flutter/material.dart';
import '../models/ticket.dart';

class TicketEditDialog extends StatefulWidget {
  final Ticket ticket;

  const TicketEditDialog({super.key, required this.ticket});

  @override
  State<TicketEditDialog> createState() => _TicketEditDialogState();
}

class _TicketEditDialogState extends State<TicketEditDialog> {
  late TextEditingController _clienteController;

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController(
      text: widget.ticket.cliente ?? '',
    );
  }

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Ticket'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostrar código del ticket (no editable)
          Row(
            children: [
              const Icon(Icons.confirmation_number, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Código: ${widget.ticket.nombre}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mostrar estado actual (no editable)
          Row(
            children: [
              Icon(
                _getStatusIcon(widget.ticket.status),
                color: _getStatusColor(widget.ticket.status),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Estado: ${_getStatusText(widget.ticket.status)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(widget.ticket.status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Campo para editar cliente
          const Text(
            'Información del Cliente:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _clienteController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Cliente',
              border: OutlineInputBorder(),
              hintText: 'Ej: Juan Pérez',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el nombre del cliente';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Nota: El estado se actualiza automáticamente según el uso del ticket.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
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
            if (_clienteController.text.isNotEmpty) {
              final updatedTicket = widget.ticket.copyWith(
                cliente: _clienteController.text,
              );
              Navigator.of(context).pop(updatedTicket);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
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
}
