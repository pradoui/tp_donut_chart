# TPDonutChart

A modern, responsive and animated donut chart widget for Flutter.

## Features
- Supports multiple entries (label, color, value)
- Responsive (custom width and height)
- Entry animation
- Hover: highlights slice and shows value/label in the center
- Modern look: rounded edges and gaps between arcs for up to 4 entries
- Standard donut chart (no gaps, no rounded edges) for 5+ entries
- Custom text color and style

## Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  tp_donut_chart: ^0.0.3
```

Then run:
```
flutter pub get
```

## Usage

```dart
import 'package:tp_donut_chart/donut_chart.dart';

final entries = [
  TPDonutChartEntry(label: 'Sales', color: Colors.blue, value: 120),
  TPDonutChartEntry(label: 'Expenses', color: Colors.red, value: 80),
  TPDonutChartEntry(label: 'Profit', color: Colors.green, value: 60),
  TPDonutChartEntry(label: 'Other', color: Colors.orange, value: 40),
];

TPDonutChart(
  entries: entries,
  width: 300,
  height: 300,
  thickness: 40,
  subtitleText: 'Total',
  textColor: Colors.black,
  textStyle: const TextStyle(fontWeight: FontWeight.bold),
)
```

## Parameters
- `entries`: List of TPDonutChartEntry (required)
- `width`, `height`: Chart size
- `thickness`: Arc thickness
- `subtitleText`: Center subtitle below the value
- `textColor`: Text color
- `textStyle`: Text style

## TPDonutChartEntry
```dart
class TPDonutChartEntry {
  final String label;
  final Color color;
  final double value;

  TPDonutChartEntry({
    required this.label,
    required this.color,
    required this.value,
  });
}
```

## Example
See `main.dart` for a complete usage example.

## License
MIT
