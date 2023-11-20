import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  final ThemeData _lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white70,
      indicatorColor: Colors.white,
      textTheme: GoogleFonts.poppinsTextTheme(),
      primaryIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.tealAccent.shade200.withOpacity(0.6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.blueGrey[200],
      ));

  final ThemeData _darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(backgroundColor: Colors.tealAccent[700]?.withOpacity(0.7)),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.blueGrey[600],
      ));

  ThemeData get currentTheme => isDark ? _darkTheme : _lightTheme;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
