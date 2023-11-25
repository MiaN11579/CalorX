import 'package:flutter/material.dart';
import 'components/food_search_delegate.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Logs'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: FoodSearchDelegate());
                  },
                  child:  Text(
                    'Search',
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
