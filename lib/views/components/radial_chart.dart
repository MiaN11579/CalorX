import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard_page.dart';

/// Returns radial chart.
Card getRadialChart(ThemeData themeData, List<ChartData> chartData) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    color: themeData.cardColor,
    elevation: 0,
    child: SfCircularChart(
      // margin: const EdgeInsets.all(12.0),
      title: ChartTitle(
        text: 'Radial chart',
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: themeData.colorScheme.primary,
        ),
      ),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return SizedBox(
              height: 65,
              width: 120,
              child: Row(children: <Widget>[
                SizedBox(
                    height: 65,
                    width: 65,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        _annotationSources[index],
                      ],
                      series: <RadialBarSeries<ChartData, String>>[
                        RadialBarSeries<ChartData, String>(
                            dataSource: <ChartData>[chartData[index]],
                            maximumValue: 150,
                            radius: '100%',
                            cornerStyle: CornerStyle.bothCurve,
                            xValueMapper: (ChartData data, _) =>
                                point.x as String,
                            yValueMapper: (ChartData data, _) => data.y,
                            pointColorMapper: (ChartData data, _) => data.color,
                            trackOpacity: 0.3,
                            useSeriesColor: true,
                            innerRadius: '75%',
                            pointRadiusMapper: (ChartData data, _) => data.x),
                      ],
                    )),
                SizedBox(width: 55, child: Text(point.x)),
              ]));
        },
      ),
      series: getRadialBar(chartData),
    ),
  );
}

final List<CircularChartAnnotation> _annotationSources =
    <CircularChartAnnotation>[
  CircularChartAnnotation(
    angle: 0,
    radius: '0%',
    widget: const ImageIcon(
      AssetImage("assets/images/carbs.png"),
      // color: Colors.red,
      size: 14,
    ),
  ),
  CircularChartAnnotation(
    angle: 0,
    radius: '0%',
    widget: const ImageIcon(
      AssetImage("assets/images/fat.png"),
      // color: Colors.red,
      size: 14,
    ),
  ),
  CircularChartAnnotation(
    angle: 0,
    radius: '0%',
    widget: const ImageIcon(
      AssetImage("assets/images/protein.png"),
      // color: Colors.red,
      size: 14,
    ),
  )
];

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
