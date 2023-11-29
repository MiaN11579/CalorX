
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/food_entry.dart';

class Meal {
  final String? id;
  final List<FoodEntry>? breakfast;
  final List<FoodEntry>? lunch;
  final List<FoodEntry>? dinner;
  final List<FoodEntry>? snack;

  Meal({
    this.id,
    this.breakfast,
    this.lunch,
     this.dinner,
     this.snack,

  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snack': snack,

    };
  }

  static Meal fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      breakfast: map['breakfast'] ?? '',
      lunch: map['lunch'] ?? '',
      dinner: map['dinner'] ?? '',
      snack: map['snack'] ?? '',
    );
  }

}
