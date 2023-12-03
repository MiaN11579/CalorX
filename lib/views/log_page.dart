import 'package:final_project/models/food_entry.dart';
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
  late List<FoodEntry> breakfastItems = [];
  late List<FoodEntry> lunchItems = [];
  late List<FoodEntry> dinnerItems = [];
  late List<FoodEntry> snackItems = [];
  late String mealDate = '';

  Future<void> _getMealObject() async {
    Meal? meal = await mealService
        .getMeal(DateFormat('yyyy-MM-dd').format(_selectedDate.toLocal()));
    if (meal != null) {
      setState(() {
        breakfastItems = meal.breakfast!.toList();
        lunchItems = meal.lunch!.toList();
        dinnerItems = meal.dinner!.toList();
        snackItems = meal.snack!.toList();
        mealDate = meal.date!;
      });
    } else {
      setState(() {
        breakfastItems = [];
        lunchItems = [];
        dinnerItems = [];
        snackItems = [];
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

  Widget _buildBox(String label, List<FoodEntry>? foodItems) {
    return Stack(
      children: [
        Container(
            width: 380,
            height: foodItems!.length.toDouble() < 2
                ? 240
                : (240 + 70 * (foodItems!.length.toDouble() - 2)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                    const SizedBox(width: 10),
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
                const SizedBox(height: 20),
                SizedBox(
                  height: 70 * foodItems!.length.toDouble(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: foodItems!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 70,
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  titleTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                                  title: const Text('Remove this entry?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (result == null || !result) {
                                return;
                              }
                              await mealService.removeEntry(
                                  mealDate, foodItems[index].id!, label);
                              await _getMealObject();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 235,
                                    child: Text(
                                      foodItems[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${foodItems[index].calories.toInt().toString()} Cal",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                showSearch(
                    context: context,
                    delegate: FoodSearchDelegate(
                        category: label,
                        date: _selectedDate,
                        onEntryAdded: () async {
                          _getMealObject();
                        }));
              },
              child: Text(
                'Add food',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
            _getMealObject();
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
            _getMealObject();
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
        _getMealObject();
      });
    }
  }
}
