import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'components/gradient_background.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();
  final PageController _controller = PageController(viewportFraction: 1);

  final List<SfCircularChart> sfCharts = [];
  final List<CircularChartAnnotation> _annotationSources =
      <CircularChartAnnotation>[
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const ImageIcon(
      AssetImage("assets/images/carbs.png"),
      // color: Colors.red,
      size: 14,
    ),
    ),
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const ImageIcon(
      AssetImage("assets/images/fat.png"),
      // color: Colors.red,
      size: 14,
    ),),
    CircularChartAnnotation(
        angle: 0, radius: '0%', widget: const ImageIcon(
      AssetImage("assets/images/protein.png"),
      // color: Colors.red,
      size: 14,
    ),)
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

  List<Widget> getAppBarCalendar() {
    return <Widget>[
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: getAppBarCalendar(),
          )),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: getGradientBackground(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Charts", style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              )),
              SizedBox(
                height: 330,
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Theme.of(context).cardColor,
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
              const SizedBox(height: 60,),
              SizedBox(
                height: 330,
                child:  Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  child: SfCartesianChart(
                    margin: const EdgeInsets.all(20.0),
                    plotAreaBorderWidth: 0,
                    title: ChartTitle(text: 'Bar chart'),
                    primaryXAxis:
                    CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 100,
                        axisLine: const AxisLine(width: 0),
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(size: 0)),
                    series: _getTracker(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void createCharts() {
    sfCharts.add(SfCircularChart(
      margin: const EdgeInsets.all(20.0),
      title: ChartTitle(text: 'Pie Chart'),
      series: <CircularSeries>[
        // Render pie chart
        DoughnutSeries<ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          cornerStyle: CornerStyle.bothCurve,
          radius: '100%',
          innerRadius: '80%',
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        )
      ],
    ));

    sfCharts.add(SfCircularChart(
      // margin: const EdgeInsets.all(12.0),
      title: ChartTitle(text: 'Radial chart'),
      legend: Legend(
        isVisible: true,
        // overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
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
                SizedBox(
                    width: 55,
                    child: Text(point.x)
                ),
              ])
          );
        },
      ),
      series: _getRadialBarCustomizedSeries(),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
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

  /// Get column series with tracker
  List<ColumnSeries<ChartData, String>> _getTracker() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
          dataSource: <ChartData>[
            ChartData('Mon', 71),
            ChartData('Tue', 84),
            ChartData('Wed', 48),
            ChartData('Thu', 80),
            ChartData('Fri', 76),
            ChartData('Sat', 80),
            ChartData('Sun', 76),
          ],

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          color: Colors.amber[800],
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Marks',
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color = Colors.white]);
  final String x;
  final double y;
  final Color color;
}
