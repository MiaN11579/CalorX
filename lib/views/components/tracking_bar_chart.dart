import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard_page.dart';

List<ChartData> chartData = <ChartData>[
  ChartData('Mon', 1610),
  ChartData('Tue', 1140),
  ChartData('Wed', 1480),
  ChartData('Thu', 2200),
  ChartData('Fri', 1760),
  ChartData('Sat', 1500),
  ChartData('Sun', 1460),
];

/// Get column series with tracker
Card getTrackingBarChart(ThemeData themeData, [double userCalorie = 0]) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    color: themeData.cardColor,
    elevation: 0,
    child: SfCartesianChart(
      margin: const EdgeInsets.all(20.0),
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: 'Weekly Calories',
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: themeData.colorScheme.primary,
        ),
      ),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: getMax(chartData, userCalorie),
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: getColumnSeries(chartData, userCalorie),
    ),
  );
}

double getMax(List<ChartData> chartData, double userCalorie) {
  double max = userCalorie;
  for (var data in chartData) {
    max = data.y > userCalorie ? data.y : max;
  }
  return max == userCalorie ? (max + max / 6) : (max + max / 10);
}

List<CartesianSeries> getColumnSeries(
    List<ChartData> chartData, double userCalorie) {
  return <CartesianSeries>[
    // Render column series
    ColumnSeries<ChartData, String>(
        dataSource: chartData,

        /// We can enable the track for column here.
        isTrackVisible: true,
        trackColor: Colors.grey[800]!,
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(15),
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 10, color: Colors.white))),
    // Render line series
    LineSeries<ChartData, String>(
        dataSource: <ChartData>[
          ChartData('Mon', userCalorie),
          ChartData('Tue', userCalorie),
          ChartData('Wed', userCalorie),
          ChartData('Thu', userCalorie),
          ChartData('Fri', userCalorie),
          ChartData('Sat', userCalorie),
          ChartData('Sun', userCalorie),
        ],
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y)
  ];
}
