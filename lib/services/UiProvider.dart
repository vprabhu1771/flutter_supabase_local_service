import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends Notifier<bool> {
  late SharedPreferences _storage;

  @override
  bool build() {
    _loadTheme(); // Load saved theme preference on app start
    return false; // Default theme is light
  }

  // Custom Themes
  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  final greenTheme = ThemeData(
    primaryColor: Color(0x0067A1), // Hex #2196F3 (Blue),
    brightness: Brightness.light,
    primaryColorDark: Colors.pinkAccent,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF69b82f), // Pink AppBar
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white), // AppBar icons color
    ),

    // TabBar Theme
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white, // Selected tab text color
      unselectedLabelColor: Colors.white70, // Unselected tab text color
      indicator: UnderlineTabIndicator( // Custom underline indicator
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Selected tab text style
      unselectedLabelStyle: TextStyle(fontSize: 14), // Unselected tab text style
    ),

    // Button Theme
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF69b82f), // Default button color
      textTheme: ButtonTextTheme.primary,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Button text color
        backgroundColor: Color(0xFF69b82f), // Button background color
      ),
    ),

    // TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // backgroundColor: Colors.pink, // TextButton color
        foregroundColor: Colors.white, // TextButton color
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF69b82f), // Background color
      selectedItemColor: Colors.white, // Selected icon & text color
      unselectedItemColor: Colors.white70, // Unselected icon & text color
      selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, backgroundColor: Color(0xFF69b82f)), // Selected text style
      unselectedLabelStyle: TextStyle(fontSize: 12), // Unselected text style
    ),


    // Icon Theme
    iconTheme: IconThemeData(color: Colors.pink), // Default icon color
    primaryIconTheme: IconThemeData(color: Colors.white), // Primary icon color (AppBar, etc.)

    // Text Theme
    // textTheme: TextTheme(
    //   bodyLarge: TextStyle(color: Colors.pinkAccent, fontSize: 18), // Large text
    //   bodyMedium: TextStyle(color: Colors.pink, fontSize: 16), // Medium text
    //   bodySmall: TextStyle(color: Colors.pink, fontSize: 14), // Small text
    //   titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), // Large titles
    // ),
  );

  // Toggle dark mode
  Future<void> toggleTheme() async {
    state = !state; // Toggle state
    await _storage.setBool("isDark", state);
  }

  // Load saved theme preference
  Future<void> _loadTheme() async {
    _storage = await SharedPreferences.getInstance();
    state = _storage.getBool("isDark") ?? false;
  }
}

// Riverpod provider
final uiProvider = NotifierProvider<UiProvider, bool>(() => UiProvider());
