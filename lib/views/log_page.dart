import 'package:flutter/material.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Logs'),
      ),
      body: Center(
      ),
    );
  }
}