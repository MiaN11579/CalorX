import 'package:final_project/models/food_entry.dart';
import 'macro_data.dart';

class Meal {
  late  List<FoodEntry>? breakfast;
  late  List<FoodEntry>? lunch;
  late  List<FoodEntry>? dinner;
  late  List<FoodEntry>? snack;
  late  String? date;
  double dailyCalorie = 0;
  MacroData macroData = MacroData();

  Meal({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    this.date,
    required this.dailyCalorie,
    required this.macroData,
  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast?.map((entry) => entry.toMap()).toList(),
      'lunch': lunch?.map((entry) => entry.toMap()).toList(),
      'dinner': dinner?.map((entry) => entry.toMap()).toList(),
      'snack': snack?.map((entry) => entry.toMap()).toList(),
      'date': date,
      'dailyCalorie': dailyCalorie,
      'macroData': macroData.toMap(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> data) {

    return Meal(
      breakfast:  (data['breakfast'] as List<dynamic>?)
          ?.map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lunch: (data['lunch'] as List<dynamic>?)
          ?.map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      dinner: (data['dinner'] as List<dynamic>?)
        ?.map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
      snack: (data['snack'] as List<dynamic>?)
          ?.map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: data['date'],
      dailyCalorie: data['dailyCalorie'],
      macroData: MacroData.fromMap(data['macroData']),
    );
  }

}
