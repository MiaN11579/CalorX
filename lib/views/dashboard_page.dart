import 'package:final_project/views/components/radial_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'components/calorie_column_chart.dart';
import 'components/gradient_background.dart';
import 'components/pie_chart.dart';
import 'package:final_project/service/service.dart';

import 'components/tracking_bar_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();
  final PageController _controller = PageController(viewportFraction: 1);
  final Service _service = Service();
  int? userCalorie;

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
    ChartData('Carbs', 70, const Color(0xffFFA268)),
    ChartData('Fat', 165, const Color(0xff2FDAC6)),
    ChartData('Protein', 110, const Color(0xffEF6461)),
  ];

  @override
  void initState() {
    super.initState();
    initDashboard();
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
        // decoration: getGradientBackground(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Charts", style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              )),
              SizedBox(
                height: 330,
                child: PageView.builder(
                  itemCount: sfCharts.length,
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
                  child: userCalorie == null ? getCalorieColumnChart() : getCalorieColumnChart(userCalorie!),
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
                  child: userCalorie == null ? getTrackingBarChart() : getTrackingBarChart(userCalorie!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void createCharts() {
    sfCharts.add(getPieChart(chartData, userCalorie!.toDouble()));
    sfCharts.add(getRadialChart(chartData));

    setState(() {
      sfCharts;
    });
  }

  void initDashboard() async {
    userCalorie = await _service.getUserCalorie();
    setState(() {
      userCalorie;
    });
    createCharts();
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color = Colors.white]);
  final String x;
  final double y;
  final Color color;
}
