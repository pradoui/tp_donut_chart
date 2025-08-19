import 'package:flutter/material.dart';
import 'dart:math';

/// A customizable and responsive donut chart widget for Flutter.
/// Supports up to 10 entries with rounded gaps, hover effect, and central value/label styling.
class DonutChartEntry {
  final String label;
  final Color color;
  final double value;

  DonutChartEntry({
    required this.label,
    required this.color,
    required this.value,
  });
}

class TPDonutChart extends StatefulWidget {
  final List<DonutChartEntry> entries;
  final double width;
  final double height;
  final double thickness;
  final String subtitleText;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextStyle? valueTextStyle; // NOVO
  final TextStyle? labelTextStyle; // NOVO

  const TPDonutChart({
    Key? key,
    required this.entries,
    this.width = 250,
    this.height = 250,
    this.thickness = 40,
    this.subtitleText = 'Total',
    this.textColor,
    this.textStyle,
    this.valueTextStyle,
    this.labelTextStyle,
  }) : super(key: key);

  @override
  State<TPDonutChart> createState() => _TPDonutChartState();
}

class _TPDonutChartState extends State<TPDonutChart>
    with SingleTickerProviderStateMixin {
  int? hoveredIndex;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.entries.fold(0, (sum, item) => sum + item.value);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final donutSize = min(w, h * 0.7); // 70% for the chart
          final labelHeight = h - donutSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: donutSize,
                height: donutSize,
                child: MouseRegion(
                  onHover: (event) {
                    final localPos = event.localPosition;
                    final center = Offset(donutSize / 2, donutSize / 2);
                    final radius = donutSize / 2 - widget.thickness / 2;
                    final dx = localPos.dx - center.dx;
                    final dy = localPos.dy - center.dy;
                    final distance = sqrt(dx * dx + dy * dy);
                    if (distance < radius + widget.thickness / 2 &&
                        distance > radius - widget.thickness / 2) {
                      double angle = atan2(dy, dx);
                      if (angle < -pi / 2) angle += 2 * pi;
                      final bool useGaps = widget.entries.length <= 10;
                      final double gap = useGaps ? 0.48 : 0.0;
                      final int nGaps = useGaps ? widget.entries.length : 0;
                      final double totalGap = nGaps * gap;
                      double total = widget.entries
                          .fold(0, (sum, item) => sum + item.value);
                      List<double> sweepAngles =
                          List.filled(widget.entries.length, 0);
                      double sweepSum = 0;
                      for (int i = 0; i < widget.entries.length; i++) {
                        sweepAngles[i] = total > 0
                            ? (widget.entries[i].value / total) * 2 * pi
                            : 0;
                        sweepSum += sweepAngles[i];
                      }
                      double maxSweep = 2 * pi - totalGap;
                      if (sweepSum > maxSweep && sweepSum > 0) {
                        double ratio = maxSweep / sweepSum;
                        for (int i = 0; i < sweepAngles.length; i++) {
                          sweepAngles[i] *= ratio;
                        }
                      }
                      double startAngle = -pi / 2;
                      for (int i = 0; i < widget.entries.length; i++) {
                        double arcStart = startAngle + (useGaps ? gap / 2 : 0);
                        double arcEnd = arcStart + sweepAngles[i];
                        if (angle >= arcStart && angle < arcEnd) {
                          if (hoveredIndex != i) {
                            setState(() {
                              hoveredIndex = i;
                            });
                          }
                          return;
                        }
                        startAngle += sweepAngles[i] + (useGaps ? gap : 0);
                      }
                    } else {
                      if (hoveredIndex != null) {
                        setState(() {
                          hoveredIndex = null;
                        });
                      }
                    }
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredIndex = null;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return CustomPaint(
                            size: Size(donutSize, donutSize),
                            painter: _DonutChartPainter(
                              entries: widget.entries,
                              thickness: widget.thickness,
                              animationValue: _controller.value,
                              hoveredIndex: hoveredIndex,
                            ),
                          );
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              hoveredIndex != null
                                  ? widget.entries[hoveredIndex!].value
                                      .toStringAsFixed(2)
                                  : total.toStringAsFixed(2),
                              style: (() {
                                final baseStyle = widget.valueTextStyle ??
                                    widget.textStyle ??
                                    Theme.of(context).textTheme.headlineMedium;
                                if (baseStyle?.fontSize != null) {
                                  return baseStyle?.copyWith(
                                    color: widget.textColor ??
                                        (hoveredIndex != null
                                            ? widget
                                                .entries[hoveredIndex!].color
                                            : null),
                                  );
                                } else {
                                  return baseStyle?.copyWith(
                                    fontSize:
                                        min(widget.width, widget.height) * 0.16,
                                    color: widget.textColor ??
                                        (hoveredIndex != null
                                            ? widget
                                                .entries[hoveredIndex!].color
                                            : null),
                                  );
                                }
                              })(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              hoveredIndex != null
                                  ? widget.entries[hoveredIndex!].label
                                  : widget.subtitleText,
                              style: (() {
                                final baseStyle = widget.labelTextStyle ??
                                    widget.textStyle ??
                                    Theme.of(context).textTheme.bodyMedium;
                                if (baseStyle?.fontSize != null) {
                                  return baseStyle?.copyWith(
                                    color: widget.textColor ??
                                        (hoveredIndex != null
                                            ? widget
                                                .entries[hoveredIndex!].color
                                            : null),
                                  );
                                } else {
                                  return baseStyle?.copyWith(
                                    fontSize:
                                        min(widget.width, widget.height) * 0.08,
                                    color: widget.textColor ??
                                        (hoveredIndex != null
                                            ? widget
                                                .entries[hoveredIndex!].color
                                            : null),
                                  );
                                }
                              })(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: labelHeight > 0 ? labelHeight : 0,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    children: [
                      for (int i = 0; i < widget.entries.length; i++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: widget.entries[i].color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.entries[i].label,
                              style: widget.textStyle
                                      ?.copyWith(color: widget.textColor) ??
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: widget.textColor,
                                      ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutChartEntry> entries;
  final double thickness;
  final double animationValue;
  final int? hoveredIndex;

  _DonutChartPainter({
    required this.entries,
    required this.thickness,
    required this.animationValue,
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total = entries.fold(0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - thickness / 2;

    final bool useGaps = entries.length <= 10;
    final double gap = useGaps ? 0.48 : 0.0; // fixed gap
    final StrokeCap cap = useGaps ? StrokeCap.round : StrokeCap.butt;
    final int nGaps = useGaps ? entries.length : 0;
    final double totalGap = nGaps * gap;
    List<double> sweepAngles = List.filled(entries.length, 0);
    double sweepSum = 0;
    for (int i = 0; i < entries.length; i++) {
      sweepAngles[i] =
          total > 0 ? (entries[i].value / total) * 2 * pi * animationValue : 0;
      sweepSum += sweepAngles[i];
    }
    double maxSweep = 2 * pi - totalGap;
    if (sweepSum > maxSweep && sweepSum > 0) {
      double ratio = maxSweep / sweepSum;
      for (int i = 0; i < sweepAngles.length; i++) {
        sweepAngles[i] *= ratio;
      }
    }
    // Draw arcs with fixed gap
    for (int i = 0; i < entries.length; i++) {
      final isHovered = hoveredIndex == i;
      final paint = Paint()
        ..color = (hoveredIndex != null)
            ? (isHovered ? entries[i].color : entries[i].color.withOpacity(0.3))
            : entries[i].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = cap;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (useGaps ? gap / 2 : 0),
        sweepAngles[i],
        false,
        paint,
      );
      startAngle += sweepAngles[i] + (useGaps ? gap : 0);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
