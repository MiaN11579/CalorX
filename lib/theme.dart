import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  final ThemeData _lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.blue[400]!.withOpacity(0.6),
    colorScheme: const ColorScheme.light(
        primary: Color(0xff8DEBFF),
        secondary: Colors.white,
        tertiary: Color(0xff6CACFF),
      // primary: Color(0xffFDE882),
      // secondary: Colors.deepPurple,
      // tertiary: Color(0xffF78FAD),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor : Color(0xff98D4FF),
    ),

    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    cardColor: Colors.grey[900]!.withOpacity(0.6),
    colorScheme: ColorScheme.dark(
        primary: Colors.blue[800]!.withOpacity(0.6),
        secondary: Colors.white,
        tertiary: Colors.indigo[800]!.withOpacity(0.4)),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor : Color(0xff121729),
    ),

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
