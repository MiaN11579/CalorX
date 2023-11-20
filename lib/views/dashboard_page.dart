import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();
  final PageController _controller = PageController(viewportFraction: 0.8);

  final List<SfCircularChart> sfCharts = [];
  final List<CircularChartAnnotation> _annotationSources =
      <CircularChartAnnotation>[
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const Icon(Icons.fastfood)),
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const Icon(Icons.fastfood)),
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const Icon(Icons.fastfood))
  ];

  final List<ChartData> chartData = [
    ChartData('Carbs', 70, Colors.deepOrange),
    ChartData('Fat', 165, Colors.teal),
    ChartData('Protein', 110, Colors.blueAccent),
  ];

  @override
  void initState() {
    super.initState();
    createCharts();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  setState(() {
                    _selectedDate =
                        _selectedDate.subtract(const Duration(days: 1));
                  });
                },
              ),
              GestureDetector(
                child: Text(
                    DateFormat('EE, MMM d').format(_selectedDate.toLocal())),
                onTap: () => _selectDate(context),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                },
              ),
            ],
          )),
      body: SizedBox(
        height: 450, // Card height
        child: PageView.builder(
          itemCount: 2,
          controller: _controller,
          itemBuilder: (context, index) {
            return ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                double factor = 1;
                if (_controller.position.hasContentDimensions) {
                  factor = 1 - (_controller.page! - index).abs();
                }

                return Center(
                  child: SizedBox(
                    height: 300 + (factor * 30),
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      child: sfCharts[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      // Column(children: [
      //   //Initialize the chart widget
      //
    );
  }

  void createCharts() {
    sfCharts.add(SfCircularChart(
      title: ChartTitle(text: 'Pie Chart'),
      series: <CircularSeries>[
        // Render pie chart
        DoughnutSeries<ChartData, String>(
          dataSource: chartData,
          // pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (ChartData data, _) => data.color,
        )
      ],
    ));

    sfCharts.add(SfCircularChart(
      title: ChartTitle(text: 'Radial chart'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return SizedBox(
              height: 60,
              width: 120,
              child: Row(children: <Widget>[
                SizedBox(
                    height: 75,
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
                SizedBox(
                    width: 55,
                    child: Text(point.x)
                ),
              ]));
        },
      ),
      series: _getRadialBarCustomizedSeries(),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
          radius: '30%',
          height: '40%',
          width: '100%',
          widget: const Text("TEST"),
        ),
      ],
    ));

    setState(() {
      sfCharts;
    });
  }

  /// Returns radial bar which need to be customized.
  List<RadialBarSeries<ChartData, String>> _getRadialBarCustomizedSeries() {
    return <RadialBarSeries<ChartData, String>>[
      RadialBarSeries<ChartData, String>(
        maximumValue: 150,
        gap: '10%',
        radius: '100%',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '50%',
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        pointRadiusMapper: (ChartData data, _) => data.x,
        pointColorMapper: (ChartData data, _) => data.color,
        trackOpacity: 0.3,
        useSeriesColor: true,
        legendIconType: LegendIconType.circle,
      ),
    ];
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color = Colors.white]);

  final String x;
  final double y;
  final Color color;
}
