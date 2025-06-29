import 'package:flutter/material.dart';

class MikrotikConfigScreen extends StatefulWidget {
  const MikrotikConfigScreen({super.key});

  @override
  State<MikrotikConfigScreen> createState() => _MikrotikConfigScreenState();
}

class _MikrotikConfigScreenState extends State<MikrotikConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isScanning = true;
  bool _rememberDevice = true;

  @override
  void initState() {
    super.initState();
    // Simulación de escaneo
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Mikrotik'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.router, size: 64, color: Color(0xFF1976D2)),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _ipController,
                          decoration: const InputDecoration(
                            labelText: 'IP del Mikrotik',
                            prefixIcon: Icon(Icons.language),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Ingrese la IP'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _userController,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Ingrese el usuario'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passController,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Ingrese la contraseña'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            StatefulBuilder(
                              builder: (context, setStateCheckbox) {
                                return Checkbox(
                                  value: _rememberDevice,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberDevice = value ?? true;
                                    });
                                    setStateCheckbox(() {});
                                  },
                                );
                              },
                            ),
                            const Text('Recordar dispositivo'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navegar a Dashboard sin validar datos
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/dashboard');
                            },
                            child: const Text('Guardar / Conectar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF2196F3)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _isScanning
                              ? Row(
                                  children: const [
                                    CircularProgressIndicator(strokeWidth: 2),
                                    SizedBox(width: 12),
                                    Text('Buscando dispositivos Mikrotik...'),
                                  ],
                                )
                              : const Text('Dispositivo Mikrotik encontrado.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
