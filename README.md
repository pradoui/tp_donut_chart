# TP Donut Chart

A customizable donut chart widget for Flutter.

## Installation

Add it to yours pubspec.yaml:
```yaml
tp_donut_chart:
  git:
    url: https://github.com/pradoui/tp_donut_chart.git
```

## How to use

```dart
import 'package:tp_donut_chart/tp_donut_chart.dart';

TPDonutChart(
  entries: [
    DonutChartEntry(label: 'Robert', value: 167, color: Colors.green),
    DonutChartEntry(label: 'John', value: 100, color: Colors.blue),
    DonutChartEntry(label: 'Thiago', value: 50), 
  ],
  size: 200,
  strokeWidth: 24,
  gap: 32,
  subtitleText: 'Message Count',
  subtitleTextStyle: TextStyle(
    color: Colors.orange,
    fontSize: 16,
  ),
)
```

## Parameters
- `entries`: List of DonutChartEntry (label, value, color optional)
- `colors`: Standard palette for bars without defined color
- `size`: Size of the chart
- `strokeWidth`: Thickness of the bars
- `gap`: Space between bars (in pixels)
- `subtitleText`: Text below the central value
- `subtitleTextStyle`: Text style of the text below the central value
- `centerTextColor`: Color of central text
- `tooltipColor`: Tooltip background color
- `tooltipTextColor`: Tooltip text color
- `textStyle`: Style applied to all widget texts

## License
MIT
