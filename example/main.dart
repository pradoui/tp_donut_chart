import 'package:flutter/material.dart';
import 'package:tp_donut_chart/tp_donut_chart.dart';

void main() {
  runApp(const DonutChartDemoApp());
}

class DonutChartDemoApp extends StatelessWidget {
  const DonutChartDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      DonutChartEntry(label: 'A', value: 10),
      DonutChartEntry(label: 'B', value: 20),
      DonutChartEntry(label: 'C', value: 30),
      DonutChartEntry(label: 'D', value: 40),
      DonutChartEntry(label: 'E', value: 50),
      DonutChartEntry(label: 'F', value: 60),
      DonutChartEntry(label: 'G', value: 70),
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TPDonutChart Visual Test')),
        body: Center(
          child: TPDonutChart(
            entries: entries,
            size: 240,
            strokeWidth: 32,
            gap: 16,
            subtitleText: 'Total de itens',
          ),
        ),
      ),
    );
  }
}
