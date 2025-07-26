import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

class ConfiguracionSection extends StatefulWidget {
  const ConfiguracionSection({super.key});

  @override
  State<ConfiguracionSection> createState() => _ConfiguracionSectionState();
}

class _ConfiguracionSectionState extends State<ConfiguracionSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Configuración',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              // Contenedor principal
              Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección Tema
                    const Text(
                      'Tema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.color_lens,
                          color: const Color(0xFF2196F3),
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Tema:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Dropdown nativo
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton<AppThemeMode>(
                            value: themeProvider.currentThemeMode,
                            underline: Container(), // Sin línea por defecto
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: AppThemeMode.automatic,
                                child: const Text('Automático'),
                              ),
                              DropdownMenuItem(
                                value: AppThemeMode.light,
                                child: const Text('Claro'),
                              ),
                              DropdownMenuItem(
                                value: AppThemeMode.dark,
                                child: const Text('Oscuro'),
                              ),
                            ],
                            onChanged: (AppThemeMode? newValue) {
                              if (newValue != null) {
                                themeProvider.setThemeMode(newValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Sección Preferencias
                    const Text(
                      'Preferencias',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Opción de inicio automático
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: const Color(0xFF2196F3),
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Abrir al iniciar el sistema',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Configuración de notificaciones
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: const Color(0xFF2196F3),
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Notificarme al alcanzar cuota de datos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Sección Datos
                    const Text(
                      'Datos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botones de acción
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.file_download,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Exportar datos',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.file_upload,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Importar datos',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Sección Acerca de
                    const Text(
                      'Acerca de',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Información de versión y botón de actualizaciones
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 12),
                        const Text(
                          'Versión: 1.0.0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.system_update,
                            color: Colors.white,
                            size: 16,
                          ),
                          label: const Text(
                            'Buscar actualizaciones',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
