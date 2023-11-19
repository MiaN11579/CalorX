import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  final ThemeData _lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.blueGrey,
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    brightness: Brightness.dark,
    indicatorColor: Colors.white,
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );


  ThemeData get currentTheme => isDark ? _darkTheme : _lightTheme;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}