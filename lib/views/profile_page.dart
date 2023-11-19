import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/models/profile_info.dart';

import '../theme.dart';

class ProfilePage extends StatelessWidget {
  final ProfileInfo profileInfo;
  ProfilePage({Key? key, required this.profileInfo}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDark ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            // Sign out the user on pressing the logout button.
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Daily Calorie Intake:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '${profileInfo.calorieIntake} calories',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}