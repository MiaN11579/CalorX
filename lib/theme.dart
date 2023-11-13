import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.poppinsTextTheme(),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.indigo,
  hintColor: Colors.amber,
  // Add more customizations for the dark theme
);

class ThemeProvider with ChangeNotifier {


  ThemeData _themeData = lightTheme; // Set the default theme to light.

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData =
    _themeData.brightness == Brightness.light ? darkTheme : lightTheme;
    notifyListeners();
  }
}