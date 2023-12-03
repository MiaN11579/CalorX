import 'package:final_project/controller/meal_service.dart';
import 'package:final_project/models/abridged_food_nutrient.dart';
import 'package:final_project/models/food_entry.dart';
import 'package:final_project/models/macro_data.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/search_result_food.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../models/meal.dart';
import 'components/gradient_background.dart';

final nutrientType = {
  'protein': 203,
  'fat': 204,
  'carbs': 205,
  'calories': 208,
};

class AddFoodEntryPage extends StatefulWidget {
  final String category;
  final DateTime date;
  final SearchResultFood food;
  final Function onEntryAdded;

  const AddFoodEntryPage({
    super.key,
    required this.category,
    required this.food,
    required this.date,
    required this.onEntryAdded,
  });

  @override
  State<AddFoodEntryPage> createState() => _AddFoodEntryPageState();
}

double getNutrientAmount(List<AbridgedFoodNutrient> nutrients, int number) {
  if (nutrients != null) {
    for (var nutrient in nutrients) {
      if (nutrient.number == number) {
        return nutrient.amount ?? 0.0;
      }
    }
  }
  return 0.0;
}

class _AddFoodEntryPageState extends State<AddFoodEntryPage> {
  final MealService mealService = MealService();

  late double _protein;
  late double _fat;
  late double _carbs;
  late double _calories;

  final _amountController = TextEditingController();

  List<Widget> foodDetails(SearchResultFood food) {
    final nutrients = food.foodNutrient;
    var details = <Widget>[];
    if (nutrients != null) {
      for (var nutrient in nutrients) {
        final number = nutrient.number;
        final name = nutrient.name;
        final amount = nutrient.amount;
        final unitName = nutrient.unitName;
        final derivationCode = nutrient.derivationCode;
        final derivationDescription = nutrient.derivationDescription;
        final line = Text(
            '$number, $name, $amount, $unitName, $derivationCode, $derivationDescription');
        if (amount! > 0) {
          details.add(line);
        }
      }
    }
    return details;
  }

  Future<void> _saveFoodItem() async {
    final String text = _amountController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amount cannot be empty')));
      return;
    }
    final double amount = double.parse(text);
    if (amount.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amount must be a Positive number')));
      return;
    }
    if (amount == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amount must be a greater than zero')));
      return;
    }
    const double perOneHundredGrams = 100.0;
    final double multiplier = amount / perOneHundredGrams;

    final FoodEntry newEntry = FoodEntry(
        date: DateFormat('yyyy-MM-dd').format(widget.date.toLocal()),
        category: widget.category,
        name: widget.food.description,
        amount: amount,
        calories: double.parse((multiplier * _calories).toStringAsFixed(2)),
        carbs: double.parse((multiplier * _carbs).toStringAsFixed(2)),
        fat: double.parse((multiplier * _fat).toStringAsFixed(2)),
        protein: double.parse((multiplier * _protein).toStringAsFixed(2)),
        baseCalories: _calories,
        baseCarbs: _carbs,
        baseFat: _fat,
        baseProtein: _protein);

    // Update or add new entry based on the category

    // Check if a meal with the same date already exists in Firebase

    final existingMeal = await mealService
        .getMeal(DateFormat('yyyy-MM-dd').format(widget.date.toLocal()));

    if (existingMeal != null) {
      // If meal exists, update it
      if (newEntry.category == "Breakfast") {
        existingMeal.breakfast!.add(newEntry);
      } else if (newEntry.category == "Lunch") {
        existingMeal.lunch!.add(newEntry);
      } else if (newEntry.category == "Dinner") {
        existingMeal.dinner!.add(newEntry);
      } else if (newEntry.category == "Snack") {
        existingMeal.snack!.add(newEntry);
      }
      // Update calorie and macros
      existingMeal.dailyCalorie += newEntry.calories;
      existingMeal.macroData.carbs += newEntry.carbs;
      existingMeal.macroData.fat += newEntry.fat;
      existingMeal.macroData.protein += newEntry.protein;
      await mealService.updateMeal(existingMeal);
    } else {
      // If meal doesn't exist, add a new entry
      Meal meal = Meal(
          breakfast: [],
          lunch: [],
          dinner: [],
          snack: [],
          date: DateFormat('yyyy-MM-dd').format(widget.date.toLocal()),
          dailyCalorie: newEntry.calories,
          macroData: MacroData(
              carbs: newEntry.carbs,
              fat: newEntry.fat,
              protein: newEntry.protein));
      if (newEntry.category == "Breakfast") {
        meal.breakfast!.add(newEntry);
      } else if (newEntry.category == "Lunch") {
        meal.lunch!.add(newEntry);
      } else if (newEntry.category == "Dinner") {
        meal.dinner!.add(newEntry);
      } else if (newEntry.category == "Snack") {
        meal.snack!.add(newEntry);
      }
      await mealService.addMeal(meal);
    }

    widget.onEntryAdded.call();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      final nutrients = widget.food.foodNutrient;
      _protein = getNutrientAmount(nutrients!, nutrientType['protein']!);
      _fat = getNutrientAmount(nutrients!, nutrientType['fat']!);
      _carbs = getNutrientAmount(nutrients!, nutrientType['carbs']!);
      _calories = getNutrientAmount(nutrients!, nutrientType['calories']!);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add ${widget.category} Item'),
      ),
      body: Container(
        decoration: getGradientBackground(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.food.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                      ],
                      decoration: const InputDecoration(
                        hintText: '100.0',
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  const Text('grams',
                      style: TextStyle(color: Colors.white, fontSize: 18))
                ],
              ),
              const Gap(40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Per 100 grams:',
                      style: TextStyle(color: Colors.white, fontSize: 18))
                ],
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Calories: ${_calories}kcal',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Carbs:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '${_carbs}g',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Fat:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '${_fat}g',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Protein:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '${_protein}g',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(40.0),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10)),
                  ),
                  onPressed: _saveFoodItem,
                  child: Text(
                    'Submit Food Item'.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
