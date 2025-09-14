import 'package:flutter/material.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ThemeNotifier extends ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadTheme(); // Load theme when the class is instantiated
  }

  void toggleTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    _saveTheme(mode); // Save theme to SharedPreferences
  }

  // Save theme mode to SharedPreferences
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    if(mode == ThemeMode.dark){
      prefs.setString('themeMode', "dark");
    } else if(mode == ThemeMode.light){
      prefs.setString('themeMode', "light");
    } else if(mode == ThemeMode.system){
      prefs.setString('themeMode', "system");
    }
  }

  // Load theme mode from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? themeModeString = prefs.getString('themeMode');
    if(themeModeString == "dark"){
      _themeMode = ThemeMode.dark;
    } else if(themeModeString == "light"){
      _themeMode = ThemeMode.light;
    } else if(themeModeString == "system"){
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  final ThemeData appTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xff6953F7),
      unselectedItemColor: secondaryTextColor,
      selectedLabelStyle: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      unselectedLabelStyle: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
    ),
    scaffoldBackgroundColor: const Color(0xffF0F2F7),
    primaryColor: const Color(0xff6953F7),
    secondaryHeaderColor: const Color(0xffFFB300),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: Color(0xffFFB300),
        color: Color(0xff6953F7)
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      labelMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
      labelSmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: blackColour,
          fontWeight: FontWeight.w400
      ),

      bodyLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      bodyMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
      bodySmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: blackColour,
          fontWeight: FontWeight.w400
      ),

      titleLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      titleMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
      titleSmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: blackColour,
          fontWeight: FontWeight.w400
      ),

      headlineLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      headlineMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
      headlineSmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18.sp,
          color: blackColour,
          fontWeight: FontWeight.w400
      ),

      displayLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: blackColour,
          fontWeight: FontWeight.w600
      ),
      displayMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: blackColour,
          fontWeight: FontWeight.w500
      ),
      displaySmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: blackColour,
          fontWeight: FontWeight.w400
      ),
    ),
  );

  final ThemeData appDarkTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xffBB86FC),
      unselectedItemColor: whiteColour,
      selectedLabelStyle: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      unselectedLabelStyle: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
    ),
    scaffoldBackgroundColor: const Color(0xff121212), // Dark background
    primaryColor: const Color(0xffBB86FC), // Soft purple for contrast
    secondaryHeaderColor: const Color(0xffFFA000), // Deep amber, slightly darker
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: Color(0xffFFA000), // Matches secondaryHeaderColor
      color: Color(0xffBB86FC), // Matches primaryColor
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      labelMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
      labelSmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13.sp,
          color: whiteColour,
          fontWeight: FontWeight.w400
      ),

      bodyLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      bodyMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
      bodySmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14.sp,
          color: whiteColour,
          fontWeight: FontWeight.w400
      ),

      titleLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      titleMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
      titleSmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16.sp,
          color: whiteColour,
          fontWeight: FontWeight.w400
      ),

      headlineLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      headlineMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
      headlineSmall: TextStyle(
          fontFamily: "Montserrat",
          color: whiteColour,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400
      ),

      displayLarge: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: whiteColour,
          fontWeight: FontWeight.w600
      ),
      displayMedium: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: whiteColour,
          fontWeight: FontWeight.w500
      ),
      displaySmall: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.sp,
          color: whiteColour,
          fontWeight: FontWeight.w400
      ),
    ),
  );
}

