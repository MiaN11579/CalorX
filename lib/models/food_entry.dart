
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodEntry {
  final String? id;
  final String date;
  final String category;
  final String name;
  final double amount;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final double baseCalories;
  final double baseCarbs;
  final double baseFat;
  final double baseProtein;

  FoodEntry({
    this.id,
    required this.date,
    required this.category,
    required this.name,
    required this.amount,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.baseCalories,
    required this.baseCarbs,
    required this.baseFat,
    required this.baseProtein,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? DateTime.now().toString(),
      'date': date,
      'name': name,
      'category' : category,
      'amount' : amount,
      'calories' : calories,
      'carbs' : carbs,
      'fat' : fat,
      'protein' : protein,
      'baseCalories' : baseCalories,
      'baseCarbs' : baseCarbs,
      'baseFat' : baseFat,
      'baseProtein' : baseProtein,
    };
  }

  static FoodEntry fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return FoodEntry(
      id: doc.id,
      date: map['date'] ?? '',
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
      calories: map['calories'] ?? '',
      carbs: map['carbs'] ?? '',
      fat: map['fat'] ?? '',
      protein: map['protein'] ?? '',
      baseCalories: map['baseCalories'] ?? '',
      baseCarbs: map['baseCarbs'] ?? '',
      baseFat: map['baseFat'] ?? '',
      baseProtein: map['baseProtein'] ?? '',
    );
  }

  factory FoodEntry.fromJson(Map<String, dynamic> data){
    final id = data['id'];
    final date = data['date'];
    final category = data['category'];
    final name = data['name'];
    final amount = data['amount'];
    final calories = data['calories'];
    final carbs = data['carbs'];
    final fat = data['fat'];
    final protein = data['protein'];
    final baseCalories = data['baseCalories'];
    final baseCarbs = data['baseCarbs'];
    final baseFat = data['baseFat'];
    final baseProtein = data['baseProtein'];

    return FoodEntry(
      id: id,
      date: date.toString(),
      category: category,
      name: name.toString(),
      amount: amount,
      calories: calories,
      carbs: carbs,
      fat: fat,
      protein: protein,
      baseCalories: baseCalories,
      baseCarbs: baseCarbs,
      baseFat: baseFat,
      baseProtein: baseProtein,
    );
  }
}
