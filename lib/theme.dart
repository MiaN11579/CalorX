import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  final ThemeData _lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardColor: const Color(0xffFFC5C0).withOpacity(0.6),
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Color(0xffFDE882),
      tertiary: Color(0xffF78FAD),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xffF4668F),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) => const TextStyle(color: Colors.white),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    cardColor: Colors.grey[900]!.withOpacity(0.6),
    colorScheme: ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.blue[800]!.withOpacity(0.6),
        tertiary: Colors.indigo[800]!.withOpacity(0.4)),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xff121729),
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
