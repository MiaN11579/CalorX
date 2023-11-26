import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard_page.dart';

List<ChartData> chartData = <ChartData>[
  ChartData('Today', 1610),
];

/// Returns column chart for daily calorie.
SfCartesianChart getCalorieColumnChart([int userCalorie = 0]) {
  return SfCartesianChart(
    margin: const EdgeInsets.all(20.0),
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: 'Today Calories'),
    primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: userCalorie.toDouble(),
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0)),
    series: <CartesianSeries>[
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
    ],
  );
}