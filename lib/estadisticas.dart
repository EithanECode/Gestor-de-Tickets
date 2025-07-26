import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'providers/ticket_provider.dart';
import 'services/statistics_service.dart';
import 'models/ticket.dart';

class EstadisticasSection extends StatefulWidget {
  const EstadisticasSection({super.key});

  @override
  State<EstadisticasSection> createState() => _EstadisticasSectionState();
}

class _EstadisticasSectionState extends State<EstadisticasSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para animación de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controlador para animación de slide
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controlador para animación de gráficos
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animaciones
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.elasticOut),
    );

    // Iniciar animaciones
    _fadeController.forward();
    _slideController.forward();
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        final tickets = ticketProvider.tickets
            .where((ticket) => !ticket.isDeleted)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  Text(
                    'Dashboard de Estadísticas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Métricas completas del negocio de WiFi',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Métricas Financieras
                  _buildSectionTitle(
                    context,
                    '💰 Métricas Financieras',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Hoy',
                          '\$${StatisticsService.calculateDailyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.green,
                          Icons.today,
                          0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Mes',
                          '\$${StatisticsService.calculateMonthlyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.blue,
                          Icons.calendar_month,
                          1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Año',
                          '\$${StatisticsService.calculateYearlyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.purple,
                          Icons.calendar_today,
                          2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Promedio/Ticket',
                          '\$${StatisticsService.calculateAverageTicketRevenue(tickets).toStringAsFixed(2)}',
                          Colors.orange,
                          Icons.analytics,
                          3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Métricas de Uso de Datos
                  _buildSectionTitle(
                    context,
                    '🌐 Uso de Datos',
                    Icons.data_usage,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedUsageCard(
                          context,
                          'Total Datos',
                          '${StatisticsService.calculateTotalDataUsage(tickets).toStringAsFixed(1)} GB',
                          Colors.cyan,
                          Icons.storage,
                          4,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedUsageCard(
                          context,
                          'Promedio/Ticket',
                          '${StatisticsService.calculateAverageDataPerTicket(tickets).toStringAsFixed(1)} GB',
                          Colors.teal,
                          Icons.analytics,
                          5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedUsageCard(
                          context,
                          'Pico de Datos',
                          '${StatisticsService.calculatePeakDataUsage(tickets).toStringAsFixed(1)} GB',
                          Colors.indigo,
                          Icons.trending_up,
                          6,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedUsageCard(
                          context,
                          'Tiempo Total',
                          _formatDuration(
                            StatisticsService.calculateTotalUsageTime(tickets),
                          ),
                          Colors.deepPurple,
                          Icons.access_time,
                          7,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Métricas de Clientes Únicos
                  _buildSectionTitle(
                    context,
                    '👥 Clientes Únicos',
                    Icons.people,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Hoy',
                          '${StatisticsService.calculateUniqueClientsToday(tickets)}',
                          Colors.green,
                          Icons.person_add,
                          8,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Este Mes',
                          '${StatisticsService.calculateUniqueClientsThisMonth(tickets)}',
                          Colors.blue,
                          Icons.group,
                          9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Total',
                          '${StatisticsService.calculateTotalUniqueClients(tickets)}',
                          Colors.purple,
                          Icons.people_outline,
                          10,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Recurrentes',
                          '${StatisticsService.calculateRecurringClients(tickets)}',
                          Colors.orange,
                          Icons.repeat,
                          11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Nuevos Hoy',
                          '${StatisticsService.calculateNewClientsToday(tickets)}',
                          Colors.teal,
                          Icons.person_add_alt,
                          12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedClientCard(
                          context,
                          'Promedio/Cliente',
                          '${StatisticsService.calculateAverageTicketsPerClient(tickets).toStringAsFixed(1)}',
                          Colors.indigo,
                          Icons.analytics,
                          13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Métricas de Rendimiento
                  _buildSectionTitle(context, '📊 Rendimiento', Icons.speed),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedPerformanceCard(
                          context,
                          'Tasa Utilización',
                          '${StatisticsService.calculateUtilizationRate(tickets).toStringAsFixed(1)}%',
                          Colors.green,
                          Icons.pie_chart,
                          14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedPerformanceCard(
                          context,
                          'Tickets/Hora',
                          '${StatisticsService.calculateTicketsPerHour(tickets).toStringAsFixed(1)}',
                          Colors.blue,
                          Icons.timer,
                          15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedPerformanceCard(
                          context,
                          'Sesión Promedio',
                          _formatDuration(
                            StatisticsService.calculateAverageSessionDuration(
                              tickets,
                            ),
                          ),
                          Colors.orange,
                          Icons.access_time_filled,
                          16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedPerformanceCard(
                          context,
                          'Tickets Totales',
                          '${tickets.length}',
                          Colors.purple,
                          Icons.confirmation_number,
                          17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // NUEVA SECCIÓN: MÉTRICAS DE VENTAS ESPECÍFICAS
                  _buildSectionTitle(
                    context,
                    '🛒 Ventas de Tickets',
                    Icons.shopping_cart,
                  ),
                  const SizedBox(height: 16),

                  // Ventas por día
                  Row(
                    children: [
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Hoy',
                          '${StatisticsService.calculateTicketsSoldToday(tickets)}',
                          '\$${StatisticsService.calculateDailyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.green,
                          Icons.today,
                          18,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Ayer',
                          '${StatisticsService.calculateTicketsSoldYesterday(tickets)}',
                          '\$${StatisticsService.calculateRevenueYesterday(tickets).toStringAsFixed(2)}',
                          Colors.blue,
                          Icons.history,
                          19,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ventas por semana
                  Row(
                    children: [
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Esta Semana',
                          '${StatisticsService.calculateTicketsSoldThisWeek(tickets)}',
                          '\$${StatisticsService.calculateRevenueThisWeek(tickets).toStringAsFixed(2)}',
                          Colors.purple,
                          Icons.view_week,
                          20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Semana Pasada',
                          '${StatisticsService.calculateTicketsSoldLastWeek(tickets)}',
                          '\$${StatisticsService.calculateRevenueLastWeek(tickets).toStringAsFixed(2)}',
                          Colors.orange,
                          Icons.calendar_view_week,
                          21,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ventas por mes
                  Row(
                    children: [
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Este Mes',
                          '${StatisticsService.calculateTicketsSoldThisMonth(tickets)}',
                          '\$${StatisticsService.calculateRevenueThisMonth(tickets).toStringAsFixed(2)}',
                          Colors.indigo,
                          Icons.calendar_month,
                          22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Mes Pasado',
                          '${StatisticsService.calculateTicketsSoldLastMonth(tickets)}',
                          '\$${StatisticsService.calculateRevenueLastMonth(tickets).toStringAsFixed(2)}',
                          Colors.teal,
                          Icons.calendar_today,
                          23,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ventas por año
                  Row(
                    children: [
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Este Año',
                          '${StatisticsService.calculateTicketsSoldThisYear(tickets)}',
                          '\$${StatisticsService.calculateRevenueThisYear(tickets).toStringAsFixed(2)}',
                          Colors.deepPurple,
                          Icons.calendar_view_month,
                          24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Año Pasado',
                          '${StatisticsService.calculateTicketsSoldLastYear(tickets)}',
                          '\$${StatisticsService.calculateRevenueLastYear(tickets).toStringAsFixed(2)}',
                          Colors.deepOrange,
                          Icons.calendar_today,
                          25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // TENDENCIAS Y CRECIMIENTO
                  _buildSectionTitle(
                    context,
                    '📈 Tendencias',
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTrendCard(
                          context,
                          'Crecimiento Semanal',
                          '${StatisticsService.calculateGrowthRate(tickets, 'week').toStringAsFixed(1)}%',
                          Colors.blue,
                          Icons.trending_up,
                          26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTrendCard(
                          context,
                          'Crecimiento Mensual',
                          '${StatisticsService.calculateGrowthRate(tickets, 'month').toStringAsFixed(1)}%',
                          Colors.green,
                          Icons.trending_up,
                          27,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTrendCard(
                          context,
                          'Crecimiento Anual',
                          '${StatisticsService.calculateGrowthRate(tickets, 'year').toStringAsFixed(1)}%',
                          Colors.purple,
                          Icons.trending_up,
                          28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSalesCard(
                          context,
                          'Promedio/Día',
                          '${(StatisticsService.calculateTicketsSoldThisMonth(tickets) / DateTime.now().day).toStringAsFixed(1)}',
                          '\$${((StatisticsService.calculateRevenueThisMonth(tickets)) / DateTime.now().day).toStringAsFixed(2)}',
                          Colors.cyan,
                          Icons.analytics,
                          29,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Métricas Financieras
                  _buildSectionTitle(
                    context,
                    '💰 Métricas Financieras',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Hoy',
                          '\$${StatisticsService.calculateDailyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.green,
                          Icons.today,
                          0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Mes',
                          '\$${StatisticsService.calculateMonthlyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.blue,
                          Icons.calendar_month,
                          1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Ingresos Año',
                          '\$${StatisticsService.calculateYearlyRevenue(tickets).toStringAsFixed(2)}',
                          Colors.purple,
                          Icons.calendar_today,
                          2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedFinancialCard(
                          context,
                          'Promedio/Ticket',
                          '\$${StatisticsService.calculateAverageTicketRevenue(tickets).toStringAsFixed(2)}',
                          Colors.orange,
                          Icons.analytics,
                          3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Gráficos
                  _buildSectionTitle(context, '📈 Gráficos', Icons.show_chart),
                  const SizedBox(height: 16),

                  // Gráfico de ingresos diarios
                  _buildAnimatedRevenueChart(context, tickets),
                  const SizedBox(height: 24),

                  // Gráfico de uso por hora
                  _buildAnimatedHourlyUsageChart(context, tickets),
                  const SizedBox(height: 24),

                  // Gráfico de distribución de estados
                  _buildAnimatedStatusDistributionChart(context, tickets),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedFinancialCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedUsageCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.bounceOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedClientCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedPerformanceCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalesCard(
    BuildContext context,
    String title,
    String value,
    String revenue,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        revenue,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4 * scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1 * scale),
                    color.withOpacity(0.05 * scale),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedRevenueChart(
    BuildContext context,
    List<Ticket> tickets,
  ) {
    final data = StatisticsService.getDailyRevenueData(tickets, 7);

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _chartAnimation.value,
          child: Card(
            elevation: 4,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingresos de los Últimos 7 Días',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('\$${value.toInt()}');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < data.length) {
                                  final date =
                                      data[value.toInt()]['date'] as DateTime;
                                  return Text('${date.day}/${date.month}');
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: data.asMap().entries.map((entry) {
                              return FlSpot(
                                entry.key.toDouble(),
                                entry.value['revenue'] * _chartAnimation.value,
                              );
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).primaryColor,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHourlyUsageChart(
    BuildContext context,
    List<Ticket> tickets,
  ) {
    final data = StatisticsService.getHourlyUsageData(tickets);

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _chartAnimation.value,
          child: Card(
            elevation: 4,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uso por Hora (Hoy)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            data
                                .map((d) => d['tickets'] as int)
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            1,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}h');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: data.map((d) {
                          return BarChartGroupData(
                            x: d['hour'],
                            barRods: [
                              BarChartRodData(
                                toY:
                                    (d['tickets'] as int).toDouble() *
                                    _chartAnimation.value,
                                color: Theme.of(context).primaryColor,
                                width: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatusDistributionChart(
    BuildContext context,
    List<Ticket> tickets,
  ) {
    final distribution = StatisticsService.getStatusDistribution(tickets);
    final total = tickets.length;

    if (total == 0) {
      return Card(
        elevation: 4,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: const Center(child: Text('No hay datos para mostrar')),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _chartAnimation.value,
          child: Card(
            elevation: 4,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribución de Estados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sections: distribution.entries.map((entry) {
                                final percentage = total > 0
                                    ? (entry.value / total) * 100
                                    : 0.0;
                                return PieChartSectionData(
                                  value:
                                      entry.value.toDouble() *
                                      _chartAnimation.value,
                                  title:
                                      '${(percentage * _chartAnimation.value).toStringAsFixed(1)}%',
                                  color: _getStatusColor(entry.key),
                                  radius: 80,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: distribution.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(entry.key),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _getStatusText(entry.key),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Text(
                                      '${(entry.value * _chartAnimation.value).toInt()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
