import 'AbridgedFoodNutrient.dart';

class SearchResultFood {
  final int fdcId;
  final String? datatype;
  final String description;
  final String? foodCode;
  final List<AbridgedFoodNutrient>? foodNutrient;
  final String? publicationDate;
  final String? scientificName;
  final String? brandOwner;
  final String? gtinUpc;
  final String? ingredients;
  final int? ndbNumber;
  final String? additionalDescriptions;
  final String? allHighLightFields;
  final double? score;

  SearchResultFood({
    required this.fdcId,
    this.datatype,
    required this.description,
    this.foodCode,
    this.foodNutrient,
    this.publicationDate,
    this.scientificName,
    this.brandOwner,
    this.gtinUpc,
    this.ingredients,
    this.ndbNumber,
    this.additionalDescriptions,
    this.allHighLightFields,
    this.score,
  });

  factory SearchResultFood.fromJson(Map<String, dynamic> data){
    final fdcId = data['fdcId'];
    final datatype = data['datatype'];
    final description = data['description'];
    final foodCode = data['foodCode']?.toString();
    final foodNutrient = data['foodNutrients'] as List<dynamic>?;
    final publicationDate = data['publicationDate'];
    final scientificName = data['scientificName'];
    final brandOwner = data['brandOwner'];
    final gtinUpc = data['gtinUpc'];
    final ingredients = data['ingredients'];
    final ndbNumber = data['ndbNumber'];
    final additionalDescriptions = data['additionalDescriptions'];
    final allHighLightFields = data['allHighLightFields'];
    final score = data['score'];
    return SearchResultFood(
      fdcId: fdcId,
      datatype: datatype,
      description: description,
      foodCode: foodCode,
      foodNutrient: foodNutrient?.map((nutrient)=> AbridgedFoodNutrient.fromJson(nutrient as Map<String, dynamic>)).toList(),
      publicationDate: publicationDate,
      scientificName: scientificName,
      brandOwner: brandOwner,
      gtinUpc: gtinUpc,
      ingredients: ingredients,
      ndbNumber: ndbNumber,
      additionalDescriptions: additionalDescriptions,
      allHighLightFields: allHighLightFields,
      score: score,
    );
  }
}
