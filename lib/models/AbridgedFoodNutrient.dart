class AbridgedFoodNutrient {
  final int? number;
  final String? name;
  final double? amount;
  final String? unitName;
  final String? derivationCode;
  final String? derivationDescription;

  AbridgedFoodNutrient({
    this.number,
    this.name,
    this.amount,
    this.unitName,
    this.derivationCode,
    this.derivationDescription
  });

  factory AbridgedFoodNutrient.fromJson(Map<String, dynamic> data){
    final number = data['number'];
    final name = data['name'];
    final amount = data['amount'];
    final unitName = data['unitName'];
    final derivationCode = data['derivationCode'];
    final derivationDescription = data['derivationDescription'];
    return AbridgedFoodNutrient(
      number: number,
      name: name,
      amount: amount,
      unitName: unitName,
      derivationCode: derivationCode,
      derivationDescription: derivationDescription,
    );
  }
}
