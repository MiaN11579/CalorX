import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/food_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/meal.dart';
import '../models/chart_data.dart';
import '../models/macro_data.dart';

class MealService {
  final CollectionReference entryCollection;

  MealService()
      : entryCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('meals');

  /// Adds a meal to Firestore.
  Future<void> addMeal(Meal meal) async {
    try {
      // Assuming you have a unique identifier for the meal (e.g., user ID)
      final existingMeal = await entryCollection
          .where('date',
              isEqualTo: meal.date) // Replace 'date' with the actual field name
          .limit(1)
          .get();

      if (existingMeal.docs.isEmpty) {
        // No existing meal for the given date, so add the new one
        await entryCollection.add(meal.toMap());
      } else {
        // Meal already exists for the given date, handle accordingly
        // For example, you could display an error message to the user
        print('Meal already exists for the given date');
      }
    } catch (e) {
      debugPrint('Error saving meal: $e');
      rethrow;
    }
  }

  /// Deletes an entry inside a given meal with the specified [id] from Firestore.
  Future<void> removeEntry(
      String mealDate, String entryId, String label) async {
    try {
      final snapshot =
          await entryCollection.where('date', isEqualTo: mealDate).get();
      final mealDocument = snapshot.docs.first;
      // Get the current meal
      final meal = Meal.fromJson(mealDocument.data() as Map<String, dynamic>);
      var toRemove = [];
      switch (label) {
        case 'Breakfast':
          for (var entry in meal.breakfast!) {
            if (entry.id == entryId) {
              toRemove.add(entry);
            }
          }
          meal.breakfast?.removeWhere((e) => toRemove.contains(e));
          break; // The switch statement must be told to exit, or it will execute every case.
        case 'Lunch':
          for (var entry in meal.lunch!) {
            if (entry.id == entryId) {
              toRemove.add(entry);
            }
          }
          meal.lunch?.removeWhere((e) => toRemove.contains(e));
          break;
        case 'Dinner':
          for (var entry in meal.dinner!) {
            if (entry.id == entryId) {
              toRemove.add(entry);
            }
          }
          meal.dinner?.removeWhere((e) => toRemove.contains(e));
          break;
        case 'Snack':
          for (var entry in meal.snack!) {
            if (entry.id == entryId) {
              toRemove.add(entry);
            }
          }
          meal.snack?.removeWhere((e) => toRemove.contains(e));
          break;
      }
      await mealDocument.reference.delete(); // delete the meal from Firestore
      await entryCollection.add(meal.toMap()); // add the updated meal to Firestore
    } catch (e) {
      debugPrint('Error removing entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(Meal meal) async {
    try {
      final snapshot =
          await entryCollection.where('date', isEqualTo: meal.date).get();
      final mealDocument = snapshot.docs.first;
      await mealDocument.reference.update(meal.toMap());
    } catch (e) {
      debugPrint('Error updating meal: $e');
      rethrow;
    }
  }

  Future<Meal?> getMeal(String date) async {
    final snapshot = await entryCollection.where('date', isEqualTo: date).get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic>? data =
          snapshot.docs.first.data() as Map<String, dynamic>?;
      // print(data);
      if (data != null) {
        return Meal.fromJson(data);
      }
    }
    return null;
  }

  Future<double> getDailyCalorie(DateTime selectedDate) async {
    final snapshot = await entryCollection
        .where('date',
            isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate.toLocal()))
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic>? data =
          snapshot.docs.first.data() as Map<String, dynamic>?;
      if (data != null) {
        return Meal.fromJson(data).dailyCalorie;
      }
    }
    return 0;
  }

  Future<MacroData> getDailyMacro(DateTime selectedDate) async {
    final snapshot = await entryCollection
        .where('date',
            isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate.toLocal()))
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic>? data =
          snapshot.docs.first.data() as Map<String, dynamic>?;

      if (data != null) {
        if (data.containsKey('macroData')) {
          final info = data['macroData'];
          return MacroData(
            carbs: info['carbs'],
            fat: info['fat'],
            protein: info['protein'],
          );
        } else {
          debugPrint('Error: The entry does not contain macroData.');
        }
      }
    }
    return MacroData();
  }

  Future<List<ChartData>> getWeeklyCalorie(DateTime selectedDate) async {
    List<ChartData> calorieList = <ChartData>[
      ChartData('Mon', 0),
      ChartData('Tue', 0),
      ChartData('Wed', 0),
      ChartData('Thu', 0),
      ChartData('Fri', 0),
      ChartData('Sat', 0),
      ChartData('Sun', 0),
    ];

    DateTime monday =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    for (var i = 0; i < 7; i++) {
      DateTime weekday = monday.add(Duration(days: i)).toLocal();
      final snapshot = await entryCollection
          .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(weekday))
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic>? data =
            snapshot.docs.first.data() as Map<String, dynamic>?;
        if (data != null) {
          calorieList[i] = ChartData(DateFormat('EE').format(weekday),
              Meal.fromJson(data).dailyCalorie.toInt().toDouble());
        }
      }
    }
    return calorieList;
  }
}
