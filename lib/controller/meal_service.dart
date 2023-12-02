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
      var mealId = FirebaseAuth.instance.currentUser?.uid;

      if (mealId != null) {
        // Set the specific document ID when adding/updating the meal
        await entryCollection.doc(mealId).set(meal.toMap());
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
      // Save the user data to Firestore
      print(meal);
      await entryCollection.doc(FirebaseAuth.instance.currentUser?.uid).update(meal.toMap());
    } catch (e) {
      // Handle any errors that occur during the save process
      debugPrint('Error updating meal: $e');
      rethrow;
    }
  }


  Future<Meal?> getMeal() async {
    final snapshot = await entryCollection.doc(FirebaseAuth.instance.currentUser?.uid).get();
    if (snapshot.exists) {
      // Retrieve profileInfo from the first entry
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      print(data!['breakfast']);

        return Meal(
          breakfast: data!['breakfast'],
          lunch: data!['lunch'],
          dinner: data!['dinner'],
          snack: data!['snack'],

        );

    } else {
      return null;
    }
  }


}
