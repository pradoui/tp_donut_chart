# TPDonutChart

A customizable and responsive donut chart widget for Flutter. Supports up to 10 entries with rounded gaps, hover effect, and central value/label styling.

## Features
- Up to 10 entries with rounded gaps
- Responsive sizing (width/height)
- Customizable thickness
- Hover effect for desktop/web
- Custom styles for central value and label
- Legend below the chart

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  tp_donut_chart: ^0.0.4  
```

## Usage
```dart
TPDonutChart(
  entries: [
    DonutChartEntry(label: 'Leads', value: 3000, color: Color(0xFF5B2EFF)),
    DonutChartEntry(label: 'Active', value: 5200, color: Color(0xFF2ECC40)),
    // ...
  ],
  width: 300,
  height: 300,
  thickness: 32,
  subtitleText: 'Leads',
  valueTextStyle: TextStyle(fontSize: 32, color: Colors.white),
  labelTextStyle: TextStyle(fontSize: 16, color: Colors.white),
)
```

## Changelog
See [CHANGELOG.md](CHANGELOG.md)

## License
MIT
