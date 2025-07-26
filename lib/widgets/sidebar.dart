import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Icono/nombre superior
            const Icon(
              Icons.confirmation_number,
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(height: 32),
            // Iconos principales centrados
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SidebarIcon(
                    icon: Icons.dashboard,
                    selected: selectedIndex == 0,
                    onTap: () => onIndexChanged(0),
                  ),
                  const SizedBox(height: 16),
                  SidebarIcon(
                    icon: Icons.confirmation_number,
                    selected: selectedIndex == 1,
                    onTap: () => onIndexChanged(1),
                  ),
                  const SizedBox(height: 16),
                  SidebarIcon(
                    icon: Icons.bar_chart,
                    selected: selectedIndex == 2,
                    onTap: () => onIndexChanged(2),
                  ),
                  const SizedBox(height: 16),
                  SidebarIcon(
                    icon: Icons.settings,
                    selected: selectedIndex == 3,
                    onTap: () => onIndexChanged(3),
                  ),
                ],
              ),
            ),
            // Botón de cerrar sesión centrado en la parte inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: SidebarIcon(
                  icon: Icons.logout,
                  selected: false,
                  onTap: onLogout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const SidebarIcon({
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: selected ? Colors.white : const Color(0xFF90CAF9),
            size: selected ? 28 : 24,
          ),
        ),
      ),
    );
  }
}
