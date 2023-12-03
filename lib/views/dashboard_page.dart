import 'package:final_project/controller/meal_service.dart';
import 'package:final_project/views/components/radial_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chart_data.dart';
import 'components/daily_calories_chart.dart';
import 'components/gradient_background.dart';
import 'components/donut_chart.dart';
import 'package:final_project/controller/user_account_service.dart';
import '../models/macro_data.dart';
import 'components/weekly_calories_chart.dart';

import 'package:final_project/date_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateManager.instance.date;
  final PageController _dailyController = PageController(viewportFraction: 1);
  final PageController _weeklyController = PageController(viewportFraction: 1);
  final UserAccountService _userAccountService = UserAccountService();
  final MealService _mealService = MealService();
  int? _goalCalorie;
  double _dailyCalorie = 0;
  final List<Card> _dailyCharts = [];
  final List<Card> _weeklyCharts = [];
  MacroData _macroData = MacroData();
  List<ChartData> _weeklyCalorieData = <ChartData>[
    ChartData('Mon', 0),
    ChartData('Tue', 0),
    ChartData('Wed', 0),
    ChartData('Thu', 0),
    ChartData('Fri', 0),
    ChartData('Sat', 0),
    ChartData('Sun', 0),
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
        DateManager.instance.setDate(picked);
        _selectedDate = DateManager.instance.date;
      });
      await updateCharts();
    }
  }

  List<Widget> getAppBarCalendar() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () async {
          setState(() {
            DateManager.instance
                .setDate(_selectedDate.subtract(const Duration(days: 1)));
            _selectedDate = DateManager.instance.date;
          });
          await updateCharts();
        },
      ),
      GestureDetector(
        child: Text(DateFormat('EE, MMM d').format(_selectedDate.toLocal())),
        onTap: () => _selectDate(context),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () async {
          setState(() {
            DateManager.instance
                .setDate(_selectedDate.add(const Duration(days: 1)));
            _selectedDate = DateManager.instance.date;
          });
          await updateCharts();
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
              const Text("Daily Charts",
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )),
              const SizedBox(height: 20),
              SizedBox(
                height: 330,
                child: PageView.builder(
                  itemCount: _dailyCharts.length,
                  controller: _dailyController,
                  itemBuilder: (context, index) {
                    return ListenableBuilder(
                      listenable: _dailyController,
                      builder: (context, child) {
                        double factor = 1;
                        if (_dailyController.position.hasContentDimensions) {
                          factor = 1 - (_dailyController.page! - index).abs();
                        }
                        return Center(
                          child: SizedBox(
                            height: 300 + (factor * 30),
                            child: _dailyCharts[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Weekly Charts",
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 330,
                child: PageView.builder(
                  itemCount: _weeklyCharts.length,
                  controller: _weeklyController,
                  itemBuilder: (context, index) {
                    return ListenableBuilder(
                      listenable: _weeklyController,
                      builder: (context, child) {
                        double factor = 1;
                        if (_weeklyController.position.hasContentDimensions) {
                          factor = 1 - (_weeklyController.page! - index).abs();
                        }
                        return Center(
                          child: SizedBox(
                            height: 300 + (factor * 30),
                            child: _weeklyCharts[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateCharts() async {
    Color cardColor = Theme.of(context).cardColor;
    _dailyCalorie = await _mealService.getDailyCalorie(_selectedDate);
    _macroData = await _mealService.getDailyMacro(_selectedDate);
    _weeklyCalorieData = await _mealService.getWeeklyCalorie(_selectedDate);

    _dailyCharts.clear();
    _dailyCharts.add(getDailyCaloriesChart(
        cardColor, _dailyCalorie, _goalCalorie!.toDouble()));
    _dailyCharts.add(getDonutChart(cardColor, _macroData));
    _dailyCharts.add(getRadialChart(cardColor, _macroData));

    _weeklyCharts.clear();
    _weeklyCharts.add(getWeeklyCaloriesChart(
        cardColor, _weeklyCalorieData, _goalCalorie!.toDouble()));

    if (mounted) {
      setState(() {
        _dailyCharts;
        _weeklyCharts;
      });
    }
  }

  void initDashboard() async {
    _goalCalorie = await _userAccountService.getUserCalorie();
    setState(() {
      _goalCalorie;
    });
    await updateCharts();
  }
}
