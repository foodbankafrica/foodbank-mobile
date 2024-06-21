import 'package:flutter/material.dart';
import 'package:food_bank/themes/custom_themes/text_theme.dart';

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class FoodBankTheme {
  //  Light theme for the application
  static ThemeData lightTheme = ThemeData(
    primarySwatch: _createMaterialColor(
      const Color(0xFFEB5017),
    ),
    primaryColor: const Color(0xFFEB5017),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFEB5017),
      onPrimary: Colors.black,
      secondary: Colors.grey,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.red,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    fontFamily: 'Inter',
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
      (states) => const Color(0xFFEB5017),
    )),
    tabBarTheme: const TabBarTheme(
      indicatorColor: Color(0xFFEB5017),
      labelColor: Color(0xFFEB5017),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      modalBackgroundColor: Colors.white,
    ),
    textTheme: FoodBankTextTheme.lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fixedSize: const Size(350, 55),
        disabledBackgroundColor: const Color(0xFFD0D5DD),
        elevation: 0,
        backgroundColor: const Color(0xFFEB5017),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    datePickerTheme: const DatePickerThemeData(),
  );

// Dark theme for the application
  static ThemeData darkTheme = ThemeData();
}
