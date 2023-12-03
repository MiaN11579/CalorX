import 'food_search_criteria.dart';
import 'search_result_food.dart';

class SearchResult {
  final FoodSearchCriteria? foodSearchCriteria;
  final int? totalHits;
  final int? currentPage;
  final int? totalPages;
  final List<SearchResultFood>? foods;

  SearchResult(
      {this.foodSearchCriteria,
      this.totalHits,
      this.currentPage,
      this.totalPages,
      this.foods});

  factory SearchResult.fromJson(Map<String, dynamic> data) {
    final foodSearchCriteria = data['foodSearchCriteria'];
    final totalHits = data['totalHits'];
    final currentPage = data['currentPage'];
    final totalPages = data['totalPages'];
    final foods = data['foods'] as List<dynamic>?;
    return SearchResult(
      foodSearchCriteria: FoodSearchCriteria.fromJson(foodSearchCriteria),
      totalHits: totalHits,
      currentPage: currentPage,
      totalPages: totalPages,
      foods: foods
          ?.map(
              (food) => SearchResultFood.fromJson(food as Map<String, dynamic>))
          .toList(),
    );
  }
}
