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
      DonutChartEntry(label: 'Leads', value: 3000, color: Color(0xFF5B2EFF)),
      DonutChartEntry(label: 'Ativos', value: 5200, color: Color(0xFF2ECC40)),
      DonutChartEntry(label: 'Inativos', value: 300, color: Color(0xFFFFDC00)),
      DonutChartEntry(label: 'Erro', value: 100, color: Color(0xFFFF4136)),
      //DonutChartEntry(label: 'Teste', value: 200, color: Color(0xFF39CCCC)),
    ];
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Color(0xFF23272A),
        appBar: AppBar(title: const Text('TPDonutChart Demo')),
        body: Center(
          child: TPDonutChart(
            entries: entries,
            width: 240,
            height: 240,
            thickness: 32,
            subtitleText: 'Leads',
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
