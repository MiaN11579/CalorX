import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/food_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/meal.dart';

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


  Future<Meal?> getMeal(DateTime date) async {
    final snapshot = await entryCollection.where('date', isEqualTo: date).get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic>? data = snapshot.docs.first.data() as Map<String, dynamic>?;
      if (data != null) {

        return Meal.fromJson(data);
      }
    }

    return null;
  }




}
