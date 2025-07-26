import 'package:flutter/material.dart';
import '../models/ticket.dart';

class TicketStatusDialog extends StatefulWidget {
  final Ticket ticket;

  const TicketStatusDialog({super.key, required this.ticket});

  @override
  State<TicketStatusDialog> createState() => _TicketStatusDialogState();
}

class _TicketStatusDialogState extends State<TicketStatusDialog> {
  late TicketStatus _selectedStatus;
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _macController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.ticket.status;
    _clienteController.text = widget.ticket.cliente ?? '';
    _macController.text = widget.ticket.dispositivoMac ?? '';
    _ipController.text = widget.ticket.dispositivoIp ?? '';
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _macController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar Estado del Ticket'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket: ${widget.ticket.nombre}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Selector de estado
            const Text(
              'Nuevo Estado:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TicketStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: TicketStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusText(status)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Campos adicionales para tickets en uso
            if (_selectedStatus == TicketStatus.enUso) ...[
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
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _macController,
                decoration: const InputDecoration(
                  labelText: 'MAC del Dispositivo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.computer),
                  hintText: '00:1B:44:11:3A:B7',
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'IP del Dispositivo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                  hintText: '192.168.1.100',
                ),
              ),
            ],

            // Información adicional para tickets utilizados
            if (_selectedStatus == TicketStatus.utilizado) ...[
              const SizedBox(height: 8),
              const Text(
                'El ticket será marcado como utilizado.',
                style: TextStyle(
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            // Información adicional para tickets anulados
            if (_selectedStatus == TicketStatus.anulado) ...[
              const SizedBox(height: 8),
              const Text(
                'El ticket será marcado como anulado.',
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTicket = widget.ticket.copyWith(
              status: _selectedStatus,
              cliente: _clienteController.text.isNotEmpty
                  ? _clienteController.text
                  : null,
              dispositivoMac: _macController.text.isNotEmpty
                  ? _macController.text
                  : null,
              dispositivoIp: _ipController.text.isNotEmpty
                  ? _ipController.text
                  : null,
              fechaUso: _selectedStatus == TicketStatus.enUso
                  ? DateTime.now()
                  : widget.ticket.fechaUso,
            );

            Navigator.of(context).pop(updatedTicket);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
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
