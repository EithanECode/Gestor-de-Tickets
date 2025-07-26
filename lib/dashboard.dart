import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dispositivos conectados',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                DeviceCard(
                  ip: '192.168.0.2',
                  mac: '00-0C-42-1F-65-3A',
                  user: 'user1',
                  time: '2:15',
                  data: '1.1',
                  quota: '5.0',
                  bandwidth: '100',
                ),
                DeviceCard(
                  ip: '192.168.0.3',
                  mac: '00-0C-42-1F-65-3B',
                  user: 'user2',
                  time: '1:10',
                  data: '0.8',
                  quota: '5.0',
                  bandwidth: '100',
                ),
                DeviceCard(
                  ip: '192.168.0.4',
                  mac: '00-0C-42-1F-65-3C',
                  user: 'user3',
                  time: '0:45',
                  data: '0.5',
                  quota: '5.0',
                  bandwidth: '100',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String ip;
  final String mac;
  final String user;
  final String time;
  final String data;
  final String quota;
  final String bandwidth;

  const DeviceCard({
    required this.ip,
    required this.mac,
    required this.user,
    required this.time,
    required this.data,
    required this.quota,
    required this.bandwidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.computer, size: 32, color: Color(0xFF1976D2)),
                      const SizedBox(width: 12),
                      Text(
                        'IP: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(ip),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'MAC: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(mac),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Usuario: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(user),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tiempo: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(time),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Datos: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$data GB'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Cuota: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$quota GB'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Banda: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$bandwidth Mbps'),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(
                    Icons.computer,
                    size: 40,
                    color: Color(0xFF1976D2),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'IP: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(ip),
                            const SizedBox(width: 24),
                            Text(
                              'MAC: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(mac),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Usuario: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(user),
                            const SizedBox(width: 24),
                            Text(
                              'Tiempo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(time),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Datos: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$data GB'),
                            const SizedBox(width: 24),
                            Text(
                              'Cuota: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$quota GB'),
                            const SizedBox(width: 24),
                            Text(
                              'Banda: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$bandwidth Mbps'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: const Color(0xFF2196F3),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Accounts: 12',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.computer,
                        color: const Color(0xFF2196F3),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Online: 3',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
