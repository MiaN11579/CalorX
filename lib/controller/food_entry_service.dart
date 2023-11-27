import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/food_entry.dart';

class FoodEntryService {
  final CollectionReference entryCollection;

  FoodEntryService()
      : entryCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('foodEntries');

  Future<void> addEntry(FoodEntry entry) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Save the user data to Firestore
      await entryCollection.add(entry.toMap());
    } catch (e) {
      // Handle any errors that occur during the add process
      debugPrint('Error saving user profile: $e');
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

  Future<void> updateEntry(FoodEntry entry) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Save the user data to Firestore
      await entryCollection.doc(entry.id).update(entry.toMap());
    } catch (e) {
      // Handle any errors that occur during the save process
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }
}
