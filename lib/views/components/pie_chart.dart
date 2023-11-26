import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard_page.dart';

/// Returns radial bar.
SfCircularChart getPieChart(List<ChartData> chartData, double userCalorie) {
  return SfCircularChart(
    margin: const EdgeInsets.all(20.0),
    title: ChartTitle(text: 'Macros'),
    series: <CircularSeries>[
      // Render pie chart
      DoughnutSeries<ChartData, String>(
        dataSource: chartData,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        cornerStyle: CornerStyle.bothFlat,
        radius: '100%',
        innerRadius: '70%',
        pointColorMapper: (ChartData data, _) => data.color,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
      )
    ],
    annotations: <CircularChartAnnotation>[
      CircularChartAnnotation(
        angle: 0,
        widget: Text("$userCalorie Calories"),
      ),
    ],
  );
}