import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Observable variable for dark mode state
  var isDarkMode = false.obs;

  static const String _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  // Toggle theme and save to SharedPreferences
  Future<void> toggleTheme(bool value) async {
    try {
      isDarkMode.value = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, value);
      print('Theme saved: ${value ? "Dark" : "Light"}');
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
}
