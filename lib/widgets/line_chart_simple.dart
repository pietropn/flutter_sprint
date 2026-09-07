import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gráfico de linha simples desenhado com CustomPainter (sem dependências
/// externas), usado no Dashboard do Gestor para mostrar a evolução do
/// total de faltas ao longo dos meses.
class SimpleLineChart extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double height;

  const SimpleLineChart({
    super.key,
    required this.values,
    this.color = AppColors.primaryBlue,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LinePainter(values: values, color: color),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _LinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1 : (maxV - minV);

    final stepX = values.length > 1 ? size.width / (values.length - 1) : size.width;

    final path = Path();
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final normalized = (values[i] - minV) / range;
      final y = size.height - (normalized * (size.height - 10)) - 5;
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: 0.08));
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = color;
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => oldDelegate.values != values;
}
