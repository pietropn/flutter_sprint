import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Barra de navegação inferior azul-marinho com destaque amarelo no item
/// selecionado, replicando a bottom nav bar dos protótipos (Home, Turmas,
/// Plataformas, Dashboard).
class EuroBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Widget> trailing;

  const EuroBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.trailing = const [],
  });

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.groups_rounded, label: 'Turmas'),
    (icon: Icons.dashboard_customize_rounded, label: 'Plataformas'),
    (icon: Icons.bar_chart_rounded, label: 'Dashboard'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.darkBlue),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              ...List.generate(_items.length, (i) {
                final selected = i == currentIndex;
                final item = _items[i];
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.accentYellow : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: 20,
                            color: selected ? AppColors.darkBlue : Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected ? AppColors.accentYellow : Colors.white70,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (trailing.isNotEmpty) ...[
                Container(width: 1, height: 32, color: Colors.white24),
                ...trailing.map(
                  (w) => IconTheme(
                    data: const IconThemeData(color: Colors.white70),
                    child: w,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
