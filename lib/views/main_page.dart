import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'log_page.dart';
import 'package:final_project/models/profile_info.dart';

class MainPage extends StatefulWidget {
  final ProfileInfo profileInfo;

  const MainPage({Key? key, required this.profileInfo}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DashboardPage(),
      const LogPage(),
      ProfilePage(profileInfo: widget.profileInfo),
    ];
    return Scaffold(
        body: screens[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.dashboard_outlined, color: Colors.white,),
              icon: Icon(Icons.dashboard, color: Colors.white,),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt, color: Colors.white,),
              label: 'Logs',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_outline, color: Colors.white,),
              icon: Icon(Icons.person, color: Colors.white,),
              label: 'Profile',
            ),
          ],
        ));
  }
}
