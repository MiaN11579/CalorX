import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class FoodSearchDelegate extends SearchDelegate {
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

  Future<String> search() async {
    try {
      final response =
          await http.get(Uri.parse('$urlSearch$apiKey$queryBase"$query"'));
      return response.body;
    } catch (e) {
      throw Exception(e.toString());
    }
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
    return FutureBuilder(
        future: search(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResults) {
      final result = searchResults.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          var suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        });
  }
}