import 'package:final_project/models/SearchResultFood.dart';
import 'package:final_project/views/add_food_entry_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:final_project/models/SearchResult.dart';

import 'gradient_background.dart';

class FoodSearchDelegate extends SearchDelegate {
  final String category;
  final DateTime date;

  FoodSearchDelegate({required this.date, required this.category});

  List<String> searchResults = [
    'Cheddar Cheese',
    'Milk',
    'Bacon',
    'Eggs',
    'White Rice',
    'Blueberries',
  ];
  String urlSearch = 'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=';
  String apiKey = '5Zwsmg1lLYSeaQ9Yx0T1rbstPEIjdQJjA6T56vzn';
  String queryBase = '&query=';
  String dataType = 'Foundation,Survey (FNDDS),Branded';

  Future<String> _search() async {
    try {
      final response = await http.get(
          Uri.parse('$urlSearch$apiKey$queryBase"$query"&dataType=$dataType'));
      return response.body;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<Widget> foodDetails(SearchResultFood food) {
    final nutrients = food.foodNutrient;
    var details = <Widget>[];
    if (nutrients != null) {
      for (var nutrient in nutrients) {
        final number = nutrient.number;
        final name = nutrient.name;
        final amount = nutrient.amount;
        final unitName = nutrient.unitName;
        final derivationCode = nutrient.derivationCode;
        final derivationDescription = nutrient.derivationDescription;
        final line = Text(
            '$number, $name, $amount, $unitName, $derivationCode, $derivationDescription',
            style: const TextStyle(fontSize: 22, color: Colors.white));
        if (amount! > 0) {
          details.add(line);
        }
      }
    }
    return details;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        decoration: getGradientBackground(context),
        child: FutureBuilder(
            future: _search(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final jsonData = snapshot.data!;
                final parsedJson = jsonDecode(jsonData);
                final searchResult = SearchResult.fromJson(parsedJson);
                final foods = searchResult.foods;
                if (foods != null) {
                  return ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(foods[index].description,
                              style: const TextStyle(fontSize: 22, color: Colors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFoodEntryPage(
                                  category: category,
                                  food: foods[index],
                                  date: date,
                                ),
                              ),
                            );
                          },
                        );
                      });
                } else {
                  return Text('No foods match this $query');
                }
              } else {
                return Scaffold(
                    body: Container(
                        decoration: getGradientBackground(context),
                        child:
                            const Center(child: CircularProgressIndicator(color: Colors.white))));
              }
            }),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResults) {
      final result = searchResults.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return Container(
      decoration: getGradientBackground(context),
      child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            var suggestion = suggestions[index];
            return ListTile(
              title: Text(suggestion,
                  style: const TextStyle(fontSize: 22, color: Colors.white)),
              textColor: Colors.white,
              onTap: () {
                query = suggestion;
                showResults(context);
              },
            );
          }),
    );
  }
}
