import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket.dart';

class TicketProvider extends ChangeNotifier {
  final List<Ticket> _tickets = [];
  final List<Ticket> _deletedTickets = [];
  final Uuid _uuid = Uuid();
  bool _isLoading = false;
  String _error = '';
  bool _isOnline = true;
  int _targetAvailableCount = 0;
  // Selection mode state
  final Set<String> _selectedIds = <String>{};
  bool _selectionMode = false;

  // Preference key
  static const String _kTargetAvailableKey = 'target_available_count';

  // Getters
  List<Ticket> get tickets => _tickets.where((t) => !t.isDeleted).toList();
  int get targetAvailableCount => _targetAvailableCount;
  List<Ticket> get deletedTickets => _deletedTickets;
  // Selection getters
  bool get isSelectionMode => _selectionMode;
  int get selectedCount => _selectedIds.length;
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isOnline => _isOnline;

  // Filtros
  List<Ticket> getTicketsByStatus(TicketStatus status) {
    return tickets.where((ticket) => ticket.status == status).toList();
  }

  List<Ticket> searchTickets(String query) {
    if (query.isEmpty) return tickets;
    return tickets
        .where(
          (ticket) =>
              ticket.nombre.toLowerCase().contains(query.toLowerCase()) ||
              (ticket.cliente?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              ticket.id.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Estadísticas
  int get totalTickets => tickets.length;
  int get ticketsDisponibles =>
      getTicketsByStatus(TicketStatus.disponible).length;
  int get ticketsEnUso => getTicketsByStatus(TicketStatus.enUso).length;
  int get ticketsUtilizados =>
      getTicketsByStatus(TicketStatus.utilizado).length;
  int get ticketsAnulados => getTicketsByStatus(TicketStatus.anulado).length;

  // CRUD Operations
  Future<void> addTicket(Ticket ticket) async {
    try {
      _setLoading(true);
      _tickets.add(ticket);
      await _saveToLocal();
      await _syncToCloud();
      _setError('');
  // Ensure available tickets if configured
  await ensureAvailable();
    } catch (e) {
      _setError('Error al agregar ticket: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTicket(Ticket ticket) async {
    try {
      _setLoading(true);
      final index = _tickets.indexWhere((t) => t.id == ticket.id);
      if (index != -1) {
        _tickets[index] = ticket;
        await _saveToLocal();
        await _syncToCloud();
        _setError('');
  await ensureAvailable();
      }
    } catch (e) {
      _setError('Error al actualizar ticket: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      _setLoading(true);
      final ticket = _tickets.firstWhere((t) => t.id == ticketId);
      final deletedTicket = ticket.copyWith(isDeleted: true);

      final index = _tickets.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        _tickets[index] = deletedTicket;
        _deletedTickets.add(ticket);
        await _saveToLocal();
        await _syncToCloud();
        _setError('');
  await ensureAvailable();
      }
    } catch (e) {
      _setError('Error al eliminar ticket: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restoreTicket(String ticketId) async {
    try {
      _setLoading(true);
      final ticket = _tickets.firstWhere((t) => t.id == ticketId);
      final restoredTicket = ticket.copyWith(isDeleted: false);

      final index = _tickets.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        _tickets[index] = restoredTicket;
        _deletedTickets.removeWhere((t) => t.id == ticketId);
        await _saveToLocal();
        await _syncToCloud();
        _setError('');
  await ensureAvailable();
      }
    } catch (e) {
      _setError('Error al restaurar ticket: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> changeTicketStatus(
    String ticketId,
    TicketStatus newStatus,
  ) async {
    try {
      _setLoading(true);
      final ticket = _tickets.firstWhere((t) => t.id == ticketId);
      final updatedTicket = ticket.copyWith(
        status: newStatus,
        fechaUso: newStatus == TicketStatus.enUso
            ? DateTime.now()
            : ticket.fechaUso,
      );

      await updateTicket(updatedTicket);
      _setError('');
  await ensureAvailable();
    } catch (e) {
      _setError('Error al cambiar estado del ticket: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sincronización
  Future<void> _saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kTargetAvailableKey, _targetAvailableCount);
      // TODO: persist tickets if desired
    } catch (e) {
      // ignore write errors for now
    }
    notifyListeners();
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _targetAvailableCount = prefs.getInt(_kTargetAvailableKey) ?? 0;
      // TODO: load tickets if persisted
      notifyListeners();
    } catch (e) {
      // ignore
    }
  }

  Future<void> _syncToCloud() async {
    if (!_isOnline) {
      // TODO: Agregar a cola de sincronización
      return;
    }

    try {
      // TODO: Implementar sincronización con Firebase/Supabase
      await Future.delayed(Duration(milliseconds: 500)); // Simulación
    } catch (e) {
      _setError('Error de sincronización: $e');
    }
  }

  Future<void> loadTickets() async {
    try {
      _setLoading(true);
      // TODO: Cargar desde persistencia local
      await Future.delayed(Duration(milliseconds: 1000)); // Simulación
  await _loadFromLocal();
      _setError('');
    } catch (e) {
      _setError('Error al cargar tickets: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> syncFromCloud() async {
    if (!_isOnline) return;

    try {
      _setLoading(true);
      // TODO: Implementar descarga desde la nube
      await Future.delayed(Duration(milliseconds: 800)); // Simulación
      _setError('');
    } catch (e) {
      _setError('Error al sincronizar desde la nube: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    if (error.isNotEmpty) {
      notifyListeners();
    }
  }

  void setOnlineStatus(bool online) {
    _isOnline = online;
    if (online) {
      syncFromCloud();
    }
    notifyListeners();
  }

  // Selection mode methods
  void enterSelectionMode(String id) {
    _selectionMode = true;
    _selectedIds.clear();
    _selectedIds.add(id);
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) _selectionMode = false;
    } else {
      _selectedIds.add(id);
      _selectionMode = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    _selectionMode = false;
    notifyListeners();
  }

  // Set the target available tickets count and persist
  Future<void> setTargetAvailableCount(int count) async {
    _targetAvailableCount = count;
    await _saveToLocal();
    await ensureAvailable();
    notifyListeners();
  }

  void clearError() {
    _setError('');
  }

           // Generar datos de prueba
         void generateSampleData() {
           final sampleTickets = [
             Ticket(
               id: 'TICKET-001',
               nombre: '12345', // Código de 5 dígitos
               status: TicketStatus.disponible,
               fechaCreacion: DateTime.now().subtract(Duration(days: 1)),
             ),
             Ticket(
               id: 'TICKET-002',
               nombre: '67890', // Código de 5 dígitos
               status: TicketStatus.enUso,
               fechaCreacion: DateTime.now().subtract(Duration(hours: 2)),
               fechaUso: DateTime.now().subtract(Duration(hours: 1)),
               cliente: 'Juan Pérez',
               dispositivoMac: '00:1B:44:11:3A:B7',
               dispositivoIp: '192.168.1.100',
               datosConsumidos: 1.5,
               tiempoUso: Duration(hours: 1, minutes: 30),
             ),
             Ticket(
               id: 'TICKET-003',
               nombre: '11111', // Código de 5 dígitos
               status: TicketStatus.utilizado,
               fechaCreacion: DateTime.now().subtract(Duration(days: 2)),
               fechaUso: DateTime.now().subtract(Duration(days: 1)),
               cliente: 'María García',
               datosConsumidos: 2.3,
               tiempoUso: Duration(hours: 2, minutes: 15),
             ),
           ];

           _tickets.addAll(sampleTickets);
           notifyListeners();
         }

  // Generar código único de 5 dígitos
  // ignore: unused_element
  String _generateUniqueCode() {
    final random = Random();
    String code;
    do {
      code = (10000 + random.nextInt(90000)).toString(); // 10000-99999
    } while (_tickets.any((ticket) => ticket.nombre == code));
    return code;
  }

  // Ensure there are at least _targetAvailableCount available tickets
  Future<void> ensureAvailable() async {
    if (_targetAvailableCount <= 0) return;
    final available = getTicketsByStatus(TicketStatus.disponible).length;
    final toCreate = _targetAvailableCount - available;
    if (toCreate <= 0) return;

    for (var i = 0; i < toCreate; i++) {
      final newTicket = Ticket(
        id: 'TICKET-${_uuid.v4().substring(0, 8).toUpperCase()}',
        nombre: _generateUniqueCode(),
        status: TicketStatus.disponible,
        fechaCreacion: DateTime.now(),
      );
      _tickets.add(newTicket);
    }
    await _saveToLocal();
    notifyListeners();
  }
}
