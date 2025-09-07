import 'dart:convert';
import 'package:http/http.dart' as http;

class MikrotikService {
  String? _ip;
  String? _username;
  String? _password;
  String? _token;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  // Configurar conexión
  Future<bool> configureConnection({
    required String ip,
    required String username,
    required String password,
  }) async {
    _ip = ip;
    _username = username;
    _password = password;

    return await testConnection();
  }

  // Probar conexión
  Future<bool> testConnection() async {
    if (_ip == null || _username == null || _password == null) {
      return false;
    }

    try {
      final response = await http
          .get(
            Uri.parse('http://$_ip/rest/system/resource'),
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
            },
          )
          .timeout(const Duration(seconds: 10));

      _isConnected = response.statusCode == 200;
      return _isConnected;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  // Obtener usuarios hotspot
  Future<List<Map<String, dynamic>>> getHotspotUsers() async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final response = await http.get(
        Uri.parse('http://$_ip/rest/ip/hotspot/user'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear usuario hotspot
  Future<bool> createHotspotUser({
    required String username,
    required String password,
    String? profile,
    String? limitBytes,
    String? limitUptime,
  }) async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final body = {
        'name': username,
        'password': password,
        if (profile != null) 'profile': profile,
        if (limitBytes != null) 'limit-bytes': limitBytes,
        if (limitUptime != null) 'limit-uptime': limitUptime,
      };

      final response = await http.post(
        Uri.parse('http://$_ip/rest/ip/hotspot/user'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  // Eliminar usuario hotspot
  Future<bool> deleteHotspotUser(String username) async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final response = await http.delete(
        Uri.parse('http://$_ip/rest/ip/hotspot/user/$username'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        },
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  // Obtener usuarios activos
  Future<List<Map<String, dynamic>>> getActiveUsers() async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final response = await http.get(
        Uri.parse('http://$_ip/rest/ip/hotspot/active'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Error al obtener usuarios activos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Desconectar usuario
  Future<bool> disconnectUser(String sessionId) async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final response = await http.delete(
        Uri.parse('http://$_ip/rest/ip/hotspot/active/$sessionId'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        },
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error al desconectar usuario: $e');
    }
  }

  // Obtener estadísticas del sistema
  Future<Map<String, dynamic>> getSystemStats() async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final response = await http.get(
        Uri.parse('http://$_ip/rest/system/resource'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          'Error al obtener estadísticas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Generar voucher
  Future<Map<String, dynamic>?> generateVoucher({
    required String username,
    required String password,
    String? profile,
    int? timeLimit,
    int? dataLimit,
  }) async {
    if (!_isConnected) throw Exception('No conectado a MikroTik');

    try {
      final body = {
        'name': username,
        'password': password,
        if (profile != null) 'profile': profile,
        if (timeLimit != null) 'limit-uptime': '${timeLimit}m',
        if (dataLimit != null)
          'limit-bytes': '${dataLimit * 1024 * 1024}', // Convertir MB a bytes
      };

      final response = await http.post(
        Uri.parse('http://$_ip/rest/ip/hotspot/user'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return {'username': username, 'password': password, 'success': true};
      } else {
        return {
          'success': false,
          'error': 'Error al generar voucher: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  // Desconectar
  void disconnect() {
    _isConnected = false;
    _token = null;
  }
}
