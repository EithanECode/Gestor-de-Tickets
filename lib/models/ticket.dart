enum TicketStatus { disponible, enUso, utilizado, anulado }

class Ticket {
  final String id;
  final String nombre;
  final TicketStatus status;
  final DateTime fechaCreacion;
  final DateTime? fechaUso;
  final String? cliente;
  final String? dispositivoMac;
  final String? dispositivoIp;
  final double? datosConsumidos;
  final Duration? tiempoUso;
  final bool isDeleted;

  const Ticket({
    required this.id,
    required this.nombre,
    required this.status,
    required this.fechaCreacion,
    this.fechaUso,
    this.cliente,
    this.dispositivoMac,
    this.dispositivoIp,
    this.datosConsumidos,
    this.tiempoUso,
    this.isDeleted = false,
  });

  Ticket copyWith({
    String? id,
    String? nombre,
    TicketStatus? status,
    DateTime? fechaCreacion,
    DateTime? fechaUso,
    String? cliente,
    String? dispositivoMac,
    String? dispositivoIp,
    double? datosConsumidos,
    Duration? tiempoUso,
    bool? isDeleted,
  }) {
    return Ticket(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      status: status ?? this.status,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaUso: fechaUso ?? this.fechaUso,
      cliente: cliente ?? this.cliente,
      dispositivoMac: dispositivoMac ?? this.dispositivoMac,
      dispositivoIp: dispositivoIp ?? this.dispositivoIp,
      datosConsumidos: datosConsumidos ?? this.datosConsumidos,
      tiempoUso: tiempoUso ?? this.tiempoUso,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'status': status.index,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaUso': fechaUso?.toIso8601String(),
      'cliente': cliente,
      'dispositivoMac': dispositivoMac,
      'dispositivoIp': dispositivoIp,
      'datosConsumidos': datosConsumidos,
      'tiempoUso': tiempoUso?.inSeconds,
      'isDeleted': isDeleted,
    };
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      nombre: json['nombre'],
      status: TicketStatus.values[json['status']],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaUso: json['fechaUso'] != null
          ? DateTime.parse(json['fechaUso'])
          : null,
      cliente: json['cliente'],
      dispositivoMac: json['dispositivoMac'],
      dispositivoIp: json['dispositivoIp'],
      datosConsumidos: json['datosConsumidos']?.toDouble(),
      tiempoUso: json['tiempoUso'] != null
          ? Duration(seconds: json['tiempoUso'])
          : null,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ticket && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Ticket(id: $id, nombre: $nombre, status: $status)';
  }
}
