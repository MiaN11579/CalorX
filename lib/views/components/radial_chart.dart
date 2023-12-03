import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data.dart';
import '../../models/macro_data.dart';

/// Returns radial chart.
Card getRadialChart(Color cardColor, MacroData macroData) {
  List<ChartData> chartData = [
    ChartData('Carbs', double.parse((macroData.carbs).toStringAsFixed(1)),
        const Color(0xffDD7292)),
    ChartData('Fat', double.parse((macroData.fat).toStringAsFixed(1)),
        const Color(0xff2FDAC6)),
    ChartData('Protein', double.parse((macroData.protein).toStringAsFixed(1)),
        const Color(0xffDB5461)),
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
        text: 'Macros Goal',
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      legend: const Legend(
        position: LegendPosition.right,
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 16,
            fontStyle: FontStyle.italic),
      ),
      series: getRadialBar(chartData),
      tooltipBehavior:
          TooltipBehavior(enable: true, format: 'point.x : point.y'),
    ),
  );
}

/// Returns radial bar.
List<RadialBarSeries<ChartData, String>> getRadialBar(
    List<ChartData> chartData) {
  return <RadialBarSeries<ChartData, String>>[
    RadialBarSeries<ChartData, String>(
      maximumValue: 150,
      gap: '10%',
      radius: '100%',
      dataSource: chartData,
      cornerStyle: CornerStyle.bothCurve,
      innerRadius: '50%',
      trackOpacity: 0.3,
      useSeriesColor: true,
      legendIconType: LegendIconType.circle,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      pointRadiusMapper: (ChartData data, _) => data.x,
      pointColorMapper: (ChartData data, _) => data.color,
    ),
  ];
}
