# TP Donut Chart

Um widget de gráfico donut personalizável para Flutter.

## Instalação

Adicione ao seu pubspec.yaml:
```yaml
tp_donut_chart:
  git:
    url: https://github.com/pradoui/tp_donut_chart.git
```

## Uso

```dart
import 'package:tp_donut_chart/tp_donut_chart.dart';

TPDonutChart(
  entries: [
    DonutChartEntry(label: 'Roberta', value: 167, color: Colors.green),
    DonutChartEntry(label: 'João', value: 100, color: Colors.blue),
    DonutChartEntry(label: 'Thiago', value: 50), // usa cor padrão
  ],
  size: 200,
  strokeWidth: 24,
  gap: 32,
  subtitleText: 'Conversas finalizadas',
  subtitleTextStyle: TextStyle(
    color: Colors.orange,
    fontSize: 16,
  ),
)
```

## Parâmetros
- `entries`: Lista de DonutChartEntry (label, valor, cor opcional)
- `colors`: Paleta padrão para barras sem cor definida
- `size`: Tamanho do gráfico
- `strokeWidth`: Espessura das barras
- `gap`: Espaço entre as barras (em pixels)
- `subtitleText`: Texto abaixo do valor central
- `subtitleTextStyle`: Estilo do texto abaixo do valor central
- `centerTextColor`: Cor do texto central
- `tooltipColor`: Cor de fundo do tooltip
- `tooltipTextColor`: Cor do texto do tooltip
- `textStyle`: Estilo aplicado a todos os textos do widget

## Licença
MIT
