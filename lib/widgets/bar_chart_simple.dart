import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BarChartItem {
  final String label;
  final double value;
  final Color color;
  const BarChartItem({required this.label, required this.value, required this.color});
}

/// Gráfico de barras verticais simples, desenhado com widgets nativos
/// (sem dependências externas), usado no Dashboard do Gestor.
class SimpleBarChart extends StatelessWidget {
  final List<BarChartItem> items;
  final double height;

  const SimpleBarChart({super.key, required this.items, this.height = 140});

  @override
  Widget build(BuildContext context) {
    final maxValue = items.map((e) => e.value).fold<double>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items
            .map(
              (item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: (height - 34) * (item.value / maxValue).clamp(0.03, 1.0),
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
