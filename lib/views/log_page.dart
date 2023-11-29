import 'package:final_project/models/food_entry.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:intl/intl.dart';
import 'components/food_search_delegate.dart';
import 'components/gradient_background.dart';
import 'package:final_project/models/meal.dart';


class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  DateTime _selectedDate = DateTime.now();

  //create a meal object using the food entries user has added
  Meal  myMeal = Meal(
  breakfast: [
  FoodEntry(date: DateTime.now(), name: "eggs", amount: MixedFraction(denominator: 4, numerator: 3, whole: 1), calories: 70, carbs: 0, fat: 0, protein: 0),
  FoodEntry(date: DateTime.now(), name: "coffee", amount: MixedFraction(denominator: 4, numerator: 3, whole: 1), calories: 70, carbs: 0, fat: 0, protein: 0),
  FoodEntry(date: DateTime.now(), name: "toast", amount: MixedFraction(denominator: 4, numerator: 3, whole: 1), calories: 70, carbs: 0, fat: 0, protein: 0)
  ],
  lunch: [],dinner: [],snack: []);

  late List<String> breakfastItems = [];
  List<String> initializeBreakfastItems() {
    breakfastItems = myMeal.breakfast!.map((foodEntry) => foodEntry.name).toList();
    return breakfastItems;
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

            decoration: getGradientBackground(context),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),

              child: Column(
              children: [
                SizedBox(height: 70,),
                _buildBox("Breakfast", initializeBreakfastItems()),
                SizedBox(height: 20,),
                _buildBox("Lunch", []),
                SizedBox(height: 20,),
                _buildBox("Dinner", []),
                SizedBox(height: 20,),
                _buildBox("Snack", []),
                SizedBox(height: 20,),

              ],
            ),
          ),
        )
      ),
    );
  }


  Widget _buildBox(String label, List<String>? foodItems){
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
                  Icon(label == "Breakfast" ? Icons.free_breakfast :
                  label=="Lunch" ? Icons.lunch_dining : label == "Dinner" ? Icons.dinner_dining : Icons.apple,
                    color: Theme.of(context).colorScheme.primary,),
                  SizedBox(width: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "$label",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child:
              ListView.builder(
                itemCount: foodItems!.length,
                itemBuilder: (context, index) {
                  return Text(
                    foodItems[index],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                  );
                },
              ),)
            ],
          )
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: FoodSearchDelegate());
              },
              child:  Text(
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
            _selectedDate = _selectedDate.subtract(const Duration(days: 1));
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
            _selectedDate = _selectedDate.add(const Duration(days: 1));
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
        _selectedDate = picked;
      });
    }
  }
}
