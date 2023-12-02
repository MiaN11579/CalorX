import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard_page.dart';
import 'chart_data.dart';
import 'macro_data.dart';

/// Returns pie chart.
Card getDonutChart(Color cardColor, MacroData macroData) {
  List<ChartData> chartData = [
    ChartData('Carbs', macroData.carbs, const Color(0xffDD7292)),
    ChartData('Fat', macroData.fat, const Color(0xff2FDAC6)),
    ChartData('Protein', macroData.protein, const Color(0xffDB5461)),
  ];
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    color: cardColor,
    elevation: 0,
    child: SfCircularChart(
      margin: const EdgeInsets.all(20.0),
      title: ChartTitle(
        text: 'My Macros',
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      legend: const Legend(
        position: LegendPosition.bottom,
        textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 16,
            fontStyle: FontStyle.italic),
        isVisible: true,
        isResponsive:true,
        overflowMode: LegendItemOverflowMode.wrap),
      series: getDoughnutChart(chartData),
    ),
  );
}

bool isChartEmpty(List<ChartData> chartData) {
  bool isEmpty = true;
  for (ChartData data in chartData) {
    if (data.y != 0) {
      isEmpty = false;
    }
  }
  return isEmpty;
}

List<CircularSeries> getDoughnutChart(List<ChartData> chartData) {
  if (isChartEmpty(chartData)) {
    return <CircularSeries>[
      DoughnutSeries<ChartData, String>(
      dataSource: chartData,
      radius: '100%',
      innerRadius: '50%',
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
    ),
    ];
  } else {
    return <CircularSeries>[
      DoughnutSeries<ChartData, String>(
        dataSource: chartData,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        cornerStyle: CornerStyle.bothFlat,
        radius: '100%',
        innerRadius: '50%',
        explodeAll: true,
        explodeOffset: '2%',
        explode: true,
        pointColorMapper: (ChartData data, _) => data.color,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
      ),
    ];
  }
}
