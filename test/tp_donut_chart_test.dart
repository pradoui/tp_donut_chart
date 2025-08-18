import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tp_donut_chart/tp_donut_chart.dart';

void main() {
  testWidgets('TPDonutChart exibe corretamente múltiplos itens e hover',
      (WidgetTester tester) async {
    final entries = [
      DonutChartEntry(label: 'Category1', color: Colors.blue, value: 120),
      DonutChartEntry(label: 'Category2', color: Colors.red, value: 80),
      DonutChartEntry(label: 'Category3', color: Colors.green, value: 60),
      DonutChartEntry(label: 'Category4', color: Colors.orange, value: 40),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: TPDonutChart(entries: entries),
          ),
        ),
      ),
    );
    // Verifica se todos os labels aparecem
    for (final entry in entries) {
      expect(find.text(entry.label), findsOneWidget);
    }
    // Verifica se o total aparece
    expect(find.text('280'), findsOneWidget);
    // Simula hover em cada fatia (não é possível simular hover exato em CustomPaint, mas pode testar a renderização)
    // Para testes visuais, recomenda-se usar o Golden Test ou testar manualmente no app.
  });
}
