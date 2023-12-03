import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data.dart';
import '../../models/macro_data.dart';

/// Returns column chart for daily calorie.
Card getDailyCaloriesChart(Color cardColor, double dailyCalorie, double goalCalorie) {
  List<ChartData> chartData = <ChartData>[
    ChartData('Today', dailyCalorie, const Color(0xffDD7292)),
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
        text: 'My Calories',
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      /// It used to set the annotation on circular chart.
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: PhysicalModel(
            shape: BoxShape.circle,
            color: Colors.transparent,
            child: Container(),
          ),
        ),
        CircularChartAnnotation(
            widget: Text(
                textAlign: TextAlign.center,
                "${chartData[0].y.toInt()}/${goalCalorie.toInt()}\nCal",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic)))
      ],
      series: <RadialBarSeries<ChartData, String>>[
        RadialBarSeries<ChartData, String>(
          dataSource: chartData,
          radius: '100%',
          innerRadius: '70%',
          maximumValue: goalCalorie,
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          pointColorMapper: (ChartData data, _) => data.color,
          pointRadiusMapper: (ChartData data, _) => data.x,
          trackOpacity: 0.3,
          useSeriesColor: true,
        )
      ],
    ),
  );
}
