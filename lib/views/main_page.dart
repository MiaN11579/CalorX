import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'log_page.dart';

class MainPage extends StatefulWidget {
  final int dailyCalorieIntake;
  const MainPage({Key? key, required this.dailyCalorieIntake}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DashboardPage(),
      const LogPage(),
      ProfilePage(dailyCalorieIntake: widget.dailyCalorieIntake),
    ];
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.greenAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard_outlined),
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Logs',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_outline),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
