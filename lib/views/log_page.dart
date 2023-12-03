import 'package:final_project/views/components/macro_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/meal_service.dart';
import '../date_manager.dart';
import 'components/food_search_delegate.dart';
import 'components/gradient_background.dart';
import 'package:final_project/models/meal.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  DateTime _selectedDate = DateManager.instance.date;

  //create a meal object using the food entries user has added
  // Meal myMeal = Meal(breakfast: [], lunch: [], dinner: [], snack: [], date: _selectedDate);

  final MealService mealService = MealService();
  late List<String> breakfastItems = [];
  late List<String> lunchItems = [];
  late List<String> dinnerItems = [];
  late List<String> snackItems = [];

  Future<void> _getMealObject() async {
    Meal? meal = await mealService.getMeal(DateFormat('yyyy-MM-dd').format(_selectedDate.toLocal()));
    if (meal != null) {
      setState(() {
        breakfastItems = meal.breakfast!.map((entry) => entry.name).toList();
        lunchItems = meal.lunch!.map((entry) => entry.name).toList();
        dinnerItems = meal.dinner!.map((entry) => entry.name).toList();
        snackItems = meal.snack!.map((entry) => entry.name).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _getMealObject();
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
      body: Center(
          child: Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: getGradientBackground(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildBox("Breakfast", breakfastItems),
              const SizedBox(height: 20),
              _buildBox("Lunch", lunchItems),
              const SizedBox(height: 20),
              _buildBox("Dinner", dinnerItems),
              const SizedBox(height: 20),
              _buildBox("Snack", snackItems),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildBox(String label, List<String>? foodItems) {
    return Stack(
      children: [
        Container(
            width: 380,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(19),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      label == "Breakfast"
                          ? Icons.free_breakfast
                          : label == "Lunch"
                              ? Icons.lunch_dining
                              : label == "Dinner"
                                  ? Icons.dinner_dining
                                  : Icons.apple,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: foodItems!.length,
                    itemBuilder: (context, index) {
                      return Text(
                        foodItems[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: FoodSearchDelegate(category: label, date: _selectedDate));
              },
              child: Text(
                'Add food',
                style: TextStyle(color: const Color(0xffF4668F)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getAppBarCalendar() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          setState(() {
            DateManager.instance
                .setDate(_selectedDate.subtract(const Duration(days: 1)));
            _selectedDate = DateManager.instance.date;
          });
        },
      ),
      GestureDetector(
        child: Text(DateFormat('EE, MMM d').format(_selectedDate.toLocal())),
        onTap: () => _selectDate(context),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () {
          setState(() {
            DateManager.instance
                .setDate(_selectedDate.add(const Duration(days: 1)));
            _selectedDate = DateManager.instance.date;
          });
        },
      ),
    ];
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
    }
  }
}
