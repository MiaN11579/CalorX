
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/food_entry.dart';

class Meal {
  final String? id;
  late final List<FoodEntry>? breakfast;
  late final List<FoodEntry>? lunch;
  late final List<FoodEntry>? dinner;
  late final List<FoodEntry>? snack;

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


  // static Meal fromMap(DocumentSnapshot doc) {
  //   Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
  //   return Meal(
  //     id: doc.id,
  //     breakfast:(map['breakfast'] as List<dynamic> )
  //         .map((entryMap) => FoodEntry.fromMap(entryMap ?? {}))
  //         .toList(),
  //     lunch: (map['lunch'] as List<dynamic> )
  //         .map((entryMap) => FoodEntry.fromMap(entryMap ?? {}))
  //         .toList(),
  //     dinner: (map['dinner'] as List<dynamic> )
  //         .map((entryMap) => FoodEntry.fromMap(entryMap ?? {}))
  //         .toList(),
  //     snack: (map['snack'] as List<dynamic>)
  //         .map((entryMap) => FoodEntry.fromMap(entryMap ?? {}))
  //         .toList(),
  //   );
  // }

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
          .toList()
    );
  }

}
