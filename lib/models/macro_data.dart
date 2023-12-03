class MacroData {
  MacroData({this.carbs = 0, this.fat = 0, this.protein = 0});
  double carbs;
  double fat;
  double protein;

  Map<String, dynamic> toMap() {
    return {
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
    };
  }

  static MacroData fromMap(Map<String, dynamic> data) {
    return MacroData(
      carbs: data['carbs'] ?? 0,
      fat: data['fat'] ?? 0,
      protein: data['protein'] ?? 0,
    );
  }
}
