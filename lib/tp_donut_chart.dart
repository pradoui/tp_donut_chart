library tp_donut_chart;

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';

/// Representa uma entrada (barra) do gráfico donut.
class DonutChartEntry {
  final String label;
  final int value;

  /// Cor da barra. Se não for informada, será usada a cor padrão do pacote.
  final Color? color;
  DonutChartEntry({required this.label, required this.value, this.color});
}

/// Widget de gráfico donut personalizável.
class TPDonutChart extends StatefulWidget {
  final List<DonutChartEntry> entries;
  final List<Color>? colors;
  final double size;
  final double strokeWidth;
  final double gap;
  final String? subtitleText;
  final TextStyle? subtitleTextStyle;
  final Color? centerTextColor;
  final Color? tooltipColor;
  final Color? tooltipTextColor;
  final TextStyle? textStyle;

  const TPDonutChart({
    super.key,
    required this.entries,
    this.colors,
    this.size = 180,
    this.strokeWidth = 22,
    this.gap = 32, // gap em pixels
    this.subtitleText,
    this.subtitleTextStyle,
    this.centerTextColor,
    this.tooltipColor,
    this.tooltipTextColor,
    this.textStyle,
  });

  @override
  State<TPDonutChart> createState() => _TPDonutChartState();
}

class _TPDonutChartState extends State<TPDonutChart> {
  int? _hoveredIndex;
  Offset? _tooltipPosition;

  List<Color> get _defaultColors => const [
        Color(0xFFB7EACB), // verde claro
        Color(0xFFB6E6FB), // azul claro
        Color(0xFFFFE5B4), // amarelo claro
        Color(0xFFFFB6B6), // vermelho claro
        Color(0xFFD6D6F7), // lilás claro
        Color(0xFFF7F7B6), // amarelo pálido
      ];

  void _handleHover(PointerHoverEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(event.position);
    final center = Offset(widget.size / 2, widget.size / 2);
    final dx = local.dx - center.dx;
    final dy = local.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);
    if (distance < widget.size / 2 &&
        distance > widget.size / 2 - widget.strokeWidth) {
      double angle = atan2(dy, dx);
      angle += pi / 2; // Corrige para o topo ser zero
      if (angle < 0) angle += 2 * pi;
      final total = widget.entries.fold<int>(0, (sum, e) => sum + e.value);
      double startAngle = 0;
      final gapRadians = widget.gap / (widget.size / 2);
      for (int i = 0; i < widget.entries.length; i++) {
        final sweep = max<double>(
            0, 2 * pi * (widget.entries[i].value / total) - gapRadians);
        double arcStart = startAngle % (2 * pi);
        double arcEnd = (arcStart + sweep) % (2 * pi);
        bool isInArc = false;
        if (arcStart < arcEnd) {
          isInArc = angle >= arcStart && angle <= arcEnd;
        } else {
          // Arco cruza o zero
          isInArc = angle >= arcStart || angle <= arcEnd;
        }
        if (isInArc) {
          setState(() {
            _hoveredIndex = i;
            _tooltipPosition = local;
          });
          return;
        }
        startAngle += 2 * pi * (widget.entries[i].value / total);
      }
    }
    if (_hoveredIndex != null) {
      setState(() {
        _hoveredIndex = null;
        _tooltipPosition = null;
      });
    }
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      _hoveredIndex = null;
      _tooltipPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.entries.fold<int>(0, (sum, e) => sum + e.value);
    final usedColors = widget.colors ?? _defaultColors;
    final centerTextColor = widget.centerTextColor ?? Colors.white;
    final tooltipColor = widget.tooltipColor ?? Colors.black.withOpacity(0.8);
    final tooltipTextColor = widget.tooltipTextColor ?? Colors.white;
    final textStyle = widget.textStyle ?? const TextStyle(color: Colors.white);
    final subtitleText = widget.subtitleText ?? 'Total de mensagens';
    final subtitleTextStyle = widget.subtitleTextStyle ??
        const TextStyle(
          color: Color(0xFFB0B6BA),
          fontSize: 14,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MouseRegion(
          onHover: _handleHover,
          onExit: _handleExit,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DonutChartPainter(
                    entries: widget.entries,
                    colors: usedColors,
                    strokeWidth: widget.strokeWidth,
                    gap: widget.gap,
                    hoveredIndex: _hoveredIndex,
                  ),
                ),
                // Valor central
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$total',
                        style: TextStyle(
                          color: centerTextColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitleText,
                        textAlign: TextAlign.center,
                        style: subtitleTextStyle,
                      ),
                    ],
                  ),
                ),
                // Tooltip
                if (_hoveredIndex != null && _tooltipPosition != null)
                  Positioned(
                    left:
                        (_tooltipPosition!.dx - 24).clamp(0, widget.size - 48),
                    top: (_tooltipPosition!.dy - 36).clamp(0, widget.size - 32),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tooltipColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.entries[_hoveredIndex!].value}',
                          style: TextStyle(
                                  color: tooltipTextColor,
                                  fontWeight: FontWeight.bold)
                              .merge(textStyle),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28), // Espaçamento extra entre gráfico e labels
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  widget.entries.length,
                  (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _LegendDot(
                                color: widget.entries[i].color ??
                                    usedColors[i % usedColors.length]),
                            const SizedBox(width: 8),
                            Text(widget.entries[i].label,
                                style: textStyle, textAlign: TextAlign.left),
                          ],
                        ),
                      )),
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutChartEntry> entries;
  final List<Color> colors;
  final double strokeWidth;
  final double gap;
  final int? hoveredIndex;

  _DonutChartPainter({
    required this.entries,
    required this.colors,
    required this.strokeWidth,
    required this.gap,
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);
    if (total == 0) return;
    double startAngle = -pi / 2;
    final gapRadians = gap / (size.width / 2);
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final sweep = max<double>(0, 2 * pi * (entry.value / total) - gapRadians);
      if (sweep > 0) {
        final paint = Paint()
          ..color = (hoveredIndex == null || hoveredIndex == i)
              ? (entry.color ?? colors[i % colors.length])
              : (entry.color ?? colors[i % colors.length]).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Offset.zero & size, startAngle + gapRadians / 2, sweep,
            false, paint);
      }
      startAngle += 2 * pi * (entry.value / total);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.entries != entries;
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
