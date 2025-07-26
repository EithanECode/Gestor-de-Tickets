import 'package:flutter/material.dart';
import '../models/ticket.dart';

class StatisticsService {
  // Precio por ticket (configurable)
  static const double ticketPrice = 5.0; // $5 por ticket

  // Métricas financieras
  static double calculateDailyRevenue(List<Ticket> tickets) {
    final today = DateTime.now();
    final todayTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == today.year &&
              ticket.fechaCreacion.month == today.month &&
              ticket.fechaCreacion.day == today.day,
        )
        .toList();

    return todayTickets.length * ticketPrice;
  }

  static double calculateMonthlyRevenue(List<Ticket> tickets) {
    final now = DateTime.now();
    final monthTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == now.year &&
              ticket.fechaCreacion.month == now.month,
        )
        .toList();

    return monthTickets.length * ticketPrice;
  }

  static double calculateYearlyRevenue(List<Ticket> tickets) {
    final now = DateTime.now();
    final yearTickets = tickets
        .where((ticket) => ticket.fechaCreacion.year == now.year)
        .toList();

    return yearTickets.length * ticketPrice;
  }

  static double calculateAverageTicketRevenue(List<Ticket> tickets) {
    if (tickets.isEmpty) return 0.0;
    return ticketPrice; // Por ahora es fijo, pero se puede hacer dinámico
  }

  // NUEVAS MÉTRICAS DE VENTAS ESPECÍFICAS
  static int calculateTicketsSoldToday(List<Ticket> tickets) {
    final today = DateTime.now();
    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == today.year &&
              ticket.fechaCreacion.month == today.month &&
              ticket.fechaCreacion.day == today.day,
        )
        .length;
  }

  static int calculateTicketsSoldYesterday(List<Ticket> tickets) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == yesterday.year &&
              ticket.fechaCreacion.month == yesterday.month &&
              ticket.fechaCreacion.day == yesterday.day,
        )
        .length;
  }

  static int calculateTicketsSoldThisWeek(List<Ticket> tickets) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ) &&
              ticket.fechaCreacion.isBefore(
                endOfWeek.add(const Duration(days: 1)),
              ),
        )
        .length;
  }

  static int calculateTicketsSoldLastWeek(List<Ticket> tickets) {
    final now = DateTime.now();
    final startOfLastWeek = now.subtract(Duration(days: now.weekday + 6));
    final endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));

    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.isAfter(
                startOfLastWeek.subtract(const Duration(days: 1)),
              ) &&
              ticket.fechaCreacion.isBefore(
                endOfLastWeek.add(const Duration(days: 1)),
              ),
        )
        .length;
  }

  static int calculateTicketsSoldThisMonth(List<Ticket> tickets) {
    final now = DateTime.now();
    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == now.year &&
              ticket.fechaCreacion.month == now.month,
        )
        .length;
  }

  static int calculateTicketsSoldLastMonth(List<Ticket> tickets) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == lastMonth.year &&
              ticket.fechaCreacion.month == lastMonth.month,
        )
        .length;
  }

  static int calculateTicketsSoldThisYear(List<Ticket> tickets) {
    final now = DateTime.now();
    return tickets
        .where((ticket) => ticket.fechaCreacion.year == now.year)
        .length;
  }

  static int calculateTicketsSoldLastYear(List<Ticket> tickets) {
    final now = DateTime.now();
    return tickets
        .where((ticket) => ticket.fechaCreacion.year == now.year - 1)
        .length;
  }

  // REVENUE ESPECÍFICO POR PERÍODOS
  static double calculateRevenueYesterday(List<Ticket> tickets) {
    return calculateTicketsSoldYesterday(tickets) * ticketPrice;
  }

  static double calculateRevenueThisWeek(List<Ticket> tickets) {
    return calculateTicketsSoldThisWeek(tickets) * ticketPrice;
  }

  static double calculateRevenueLastWeek(List<Ticket> tickets) {
    return calculateTicketsSoldLastWeek(tickets) * ticketPrice;
  }

  static double calculateRevenueThisMonth(List<Ticket> tickets) {
    return calculateTicketsSoldThisMonth(tickets) * ticketPrice;
  }

  static double calculateRevenueLastMonth(List<Ticket> tickets) {
    return calculateTicketsSoldLastMonth(tickets) * ticketPrice;
  }

  static double calculateRevenueThisYear(List<Ticket> tickets) {
    return calculateTicketsSoldThisYear(tickets) * ticketPrice;
  }

  static double calculateRevenueLastYear(List<Ticket> tickets) {
    return calculateTicketsSoldLastYear(tickets) * ticketPrice;
  }

  // COMPARACIONES Y TENDENCIAS
  static double calculateGrowthRate(List<Ticket> tickets, String period) {
    switch (period) {
      case 'week':
        final thisWeek = calculateTicketsSoldThisWeek(tickets);
        final lastWeek = calculateTicketsSoldLastWeek(tickets);
        if (lastWeek == 0) return thisWeek > 0 ? 100.0 : 0.0;
        return ((thisWeek - lastWeek) / lastWeek) * 100;
      case 'month':
        final thisMonth = calculateTicketsSoldThisMonth(tickets);
        final lastMonth = calculateTicketsSoldLastMonth(tickets);
        if (lastMonth == 0) return thisMonth > 0 ? 100.0 : 0.0;
        return ((thisMonth - lastMonth) / lastMonth) * 100;
      case 'year':
        final thisYear = calculateTicketsSoldThisYear(tickets);
        final lastYear = calculateTicketsSoldLastYear(tickets);
        if (lastYear == 0) return thisYear > 0 ? 100.0 : 0.0;
        return ((thisYear - lastYear) / lastYear) * 100;
      default:
        return 0.0;
    }
  }

  static String getGrowthIcon(double growthRate) {
    if (growthRate > 0) return '📈';
    if (growthRate < 0) return '📉';
    return '➡️';
  }

  static Color getGrowthColor(double growthRate) {
    if (growthRate > 0) return Colors.green;
    if (growthRate < 0) return Colors.red;
    return Colors.grey;
  }

  // Métricas de uso de datos
  static double calculateTotalDataUsage(List<Ticket> tickets) {
    return tickets
        .where((ticket) => ticket.datosConsumidos != null)
        .fold(0.0, (sum, ticket) => sum + ticket.datosConsumidos!);
  }

  static double calculateAverageDataPerTicket(List<Ticket> tickets) {
    final ticketsWithData = tickets
        .where((ticket) => ticket.datosConsumidos != null)
        .toList();
    if (ticketsWithData.isEmpty) return 0.0;

    final totalData = ticketsWithData.fold(
      0.0,
      (sum, ticket) => sum + ticket.datosConsumidos!,
    );
    return totalData / ticketsWithData.length;
  }

  static double calculatePeakDataUsage(List<Ticket> tickets) {
    if (tickets.isEmpty) return 0.0;

    return tickets
        .where((ticket) => ticket.datosConsumidos != null)
        .map((ticket) => ticket.datosConsumidos!)
        .reduce((max, current) => current > max ? current : max);
  }

  // Métricas de tiempo de uso
  static Duration calculateTotalUsageTime(List<Ticket> tickets) {
    return tickets
        .where((ticket) => ticket.tiempoUso != null)
        .fold(Duration.zero, (sum, ticket) => sum + ticket.tiempoUso!);
  }

  static Duration calculateAverageUsageTime(List<Ticket> tickets) {
    final ticketsWithTime = tickets
        .where((ticket) => ticket.tiempoUso != null)
        .toList();
    if (ticketsWithTime.isEmpty) return Duration.zero;

    final totalTime = ticketsWithTime.fold(
      Duration.zero,
      (sum, ticket) => sum + ticket.tiempoUso!,
    );
    return Duration(
      milliseconds: totalTime.inMilliseconds ~/ ticketsWithTime.length,
    );
  }

  static Duration calculatePeakUsageTime(List<Ticket> tickets) {
    if (tickets.isEmpty) return Duration.zero;

    return tickets
        .where((ticket) => ticket.tiempoUso != null)
        .map((ticket) => ticket.tiempoUso!)
        .reduce((max, current) => current > max ? current : max);
  }

  // Métricas de clientes únicos
  static String getClientIdentifier(Ticket ticket) {
    // Prioridad 1: MAC Address (más preciso)
    if (ticket.dispositivoMac != null && ticket.dispositivoMac!.isNotEmpty) {
      return ticket.dispositivoMac!;
    }

    // Prioridad 2: Nombre del cliente
    if (ticket.cliente != null && ticket.cliente!.isNotEmpty) {
      return ticket.cliente!;
    }

    // Prioridad 3: IP como último recurso
    if (ticket.dispositivoIp != null && ticket.dispositivoIp!.isNotEmpty) {
      return ticket.dispositivoIp!;
    }

    return 'unknown';
  }

  static int calculateUniqueClientsToday(List<Ticket> tickets) {
    final today = DateTime.now();
    final todayTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == today.year &&
              ticket.fechaCreacion.month == today.month &&
              ticket.fechaCreacion.day == today.day,
        )
        .toList();

    final uniqueClients = <String>{};
    for (final ticket in todayTickets) {
      uniqueClients.add(getClientIdentifier(ticket));
    }

    return uniqueClients.length;
  }

  static int calculateUniqueClientsThisMonth(List<Ticket> tickets) {
    final now = DateTime.now();
    final monthTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == now.year &&
              ticket.fechaCreacion.month == now.month,
        )
        .toList();

    final uniqueClients = <String>{};
    for (final ticket in monthTickets) {
      uniqueClients.add(getClientIdentifier(ticket));
    }

    return uniqueClients.length;
  }

  static int calculateTotalUniqueClients(List<Ticket> tickets) {
    final uniqueClients = <String>{};
    for (final ticket in tickets) {
      uniqueClients.add(getClientIdentifier(ticket));
    }

    return uniqueClients.length;
  }

  static int calculateRecurringClients(List<Ticket> tickets) {
    final clientTicketCount = <String, int>{};

    for (final ticket in tickets) {
      final identifier = getClientIdentifier(ticket);
      clientTicketCount[identifier] = (clientTicketCount[identifier] ?? 0) + 1;
    }

    return clientTicketCount.values.where((count) => count > 1).length;
  }

  static int calculateNewClientsToday(List<Ticket> tickets) {
    final today = DateTime.now();
    final todayTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == today.year &&
              ticket.fechaCreacion.month == today.month &&
              ticket.fechaCreacion.day == today.day,
        )
        .toList();

    final allPreviousClients = <String>{};
    final todayClients = <String>{};

    // Obtener todos los clientes anteriores
    for (final ticket in tickets) {
      if (ticket.fechaCreacion.isBefore(
        DateTime(today.year, today.month, today.day),
      )) {
        allPreviousClients.add(getClientIdentifier(ticket));
      }
    }

    // Obtener clientes de hoy
    for (final ticket in todayTickets) {
      todayClients.add(getClientIdentifier(ticket));
    }

    // Clientes nuevos = clientes de hoy que no estaban antes
    return todayClients.difference(allPreviousClients).length;
  }

  // Métricas de rendimiento
  static double calculateUtilizationRate(List<Ticket> tickets) {
    if (tickets.isEmpty) return 0.0;

    final usedTickets = tickets
        .where(
          (ticket) =>
              ticket.status == TicketStatus.utilizado ||
              ticket.status == TicketStatus.enUso,
        )
        .length;

    return (usedTickets / tickets.length) * 100;
  }

  static double calculateTicketsPerHour(List<Ticket> tickets) {
    final today = DateTime.now();
    final todayTickets = tickets
        .where(
          (ticket) =>
              ticket.fechaCreacion.year == today.year &&
              ticket.fechaCreacion.month == today.month &&
              ticket.fechaCreacion.day == today.day,
        )
        .toList();

    if (todayTickets.isEmpty) return 0.0;

    final hoursSinceStart = DateTime.now()
        .difference(DateTime(today.year, today.month, today.day))
        .inHours;
    return todayTickets.length / (hoursSinceStart > 0 ? hoursSinceStart : 1);
  }

  // Datos para gráficos
  static List<Map<String, dynamic>> getDailyRevenueData(
    List<Ticket> tickets,
    int days,
  ) {
    final data = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayTickets = tickets
          .where(
            (ticket) =>
                ticket.fechaCreacion.year == date.year &&
                ticket.fechaCreacion.month == date.month &&
                ticket.fechaCreacion.day == date.day,
          )
          .toList();

      data.add({
        'date': date,
        'revenue': dayTickets.length * ticketPrice,
        'tickets': dayTickets.length,
      });
    }

    return data;
  }

  static List<Map<String, dynamic>> getHourlyUsageData(List<Ticket> tickets) {
    final hourlyData = List.filled(24, 0);

    for (final ticket in tickets) {
      if (ticket.fechaCreacion.year == DateTime.now().year &&
          ticket.fechaCreacion.month == DateTime.now().month &&
          ticket.fechaCreacion.day == DateTime.now().day) {
        hourlyData[ticket.fechaCreacion.hour]++;
      }
    }

    return hourlyData
        .asMap()
        .entries
        .map((entry) => {'hour': entry.key, 'tickets': entry.value})
        .toList();
  }

  // Métricas de estado
  static Map<TicketStatus, int> getStatusDistribution(List<Ticket> tickets) {
    final distribution = <TicketStatus, int>{};

    for (final status in TicketStatus.values) {
      distribution[status] = tickets
          .where((ticket) => ticket.status == status)
          .length;
    }

    return distribution;
  }

  // Métricas de eficiencia
  static double calculateAverageTicketsPerClient(List<Ticket> tickets) {
    final uniqueClients = <String>{};
    for (final ticket in tickets) {
      uniqueClients.add(getClientIdentifier(ticket));
    }

    if (uniqueClients.isEmpty) return 0.0;
    return tickets.length / uniqueClients.length;
  }

  static Duration calculateAverageSessionDuration(List<Ticket> tickets) {
    final ticketsWithTime = tickets
        .where((ticket) => ticket.tiempoUso != null)
        .toList();
    if (ticketsWithTime.isEmpty) return Duration.zero;

    final totalTime = ticketsWithTime.fold(
      Duration.zero,
      (sum, ticket) => sum + ticket.tiempoUso!,
    );
    return Duration(
      milliseconds: totalTime.inMilliseconds ~/ ticketsWithTime.length,
    );
  }
}
