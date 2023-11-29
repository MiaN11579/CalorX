import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_info.dart';
import 'package:fraction/fraction.dart';

class FoodEntry {
  final String? id;
  final DateTime date;
  final String name;
  final MixedFraction amount;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;

  FoodEntry({
    this.id,
    required this.date,
    required this.name,
    required this.amount,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
    };
  }

  static FoodEntry fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return FoodEntry(
      id: doc.id,
      date: map['date'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
      calories: map['calories'] ?? '',
      carbs: map['carbs'] ?? '',
      fat: map['fat'] ?? '',
      protein: map['protein'] ?? '',
    );
  }
}
