import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  final ThemeData _lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[200],
    colorScheme: const ColorScheme.light(
        primary: Colors.white,
        secondary: Colors.black,
        tertiary: Colors.white),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    cardColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
        primary: Colors.blue[800]!.withOpacity(0.6),
        secondary: Colors.white,
        tertiary: Colors.indigo[800]!.withOpacity(0.4)),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
  );

  ThemeData get currentTheme => isDark ? _darkTheme : _lightTheme;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
