import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/meal.dart';
import '../views/components/chart_data.dart';
import '../views/components/macro_data.dart';

class MealService {
  final CollectionReference entryCollection;

  MealService()
      : entryCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('meals');

  Future<void> addEntry(Meal meal) async {
    try {
      // Assuming you have a unique identifier for the meal (e.g., user ID)
      final existingMeal = await entryCollection
          .where('date', isEqualTo: meal.date) // Replace 'date' with the actual field name
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



  /// Deletes a car with the specified [id] from Firestore.
  Future<void> removeEntry(String id) async {
    try {
      // Remove entry from Firestore
      await entryCollection.doc(id).delete();
      debugPrint('Entry deleted with ID: $id');
    } catch (e) {
      // Handle any errors that occur during the remove process
      debugPrint('Error saving user profile: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(Meal meal) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      final snapshot = await entryCollection.where('date', isEqualTo: meal.date).get();
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

      Map<String, dynamic>? data = snapshot.docs.first.data() as Map<String, dynamic>?;
      print(data);
      if (data != null) {
        return Meal.fromJson(data);
      }
    }
    return null;
    

  }

  Future<int> getDailyCalorie(DateTime selectedDate) async {
    return 2000 - selectedDate.day * 20;
  }

  Future<MacroData> getDailyMacro(DateTime selectedDate) async {
    return MacroData(89, 67, 72);
  }

  Future<List<ChartData>> getWeeklyCalorie(DateTime selectedDate) async {
    return <ChartData>[
      ChartData('Mon', 1610),
      ChartData('Tue', 1140),
      ChartData('Wed', 1480),
      ChartData('Thu', 2200),
      ChartData('Fri', 1760),
      ChartData('Sat', 1500),
      ChartData('Sun', 1460),
    ];
  }
}
