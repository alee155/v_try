import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _rememberMeKey = 'remember_me';

  // Save user session data
  Future<bool> saveUserSession({
    required String token,
    required String userId,
    required String email,
    required bool rememberMe,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Only save if remember me is enabled
      if (rememberMe) {
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userIdKey, userId);
        await prefs.setString(_emailKey, email);
        await prefs.setBool(_rememberMeKey, true);
      } else {
        // Clear any existing data if remember me is disabled
        await clearSession();
      }
      
      return true;
    } catch (e) {
      print('Error saving user session: $e');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final rememberMe = prefs.getBool(_rememberMeKey);
      
      // User is logged in if token exists and remember me is enabled
      return token != null && token.isNotEmpty && rememberMe == true;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Get saved auth token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Get saved user ID
  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // Get saved user email
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error getting user email: $e');
      return null;
    }
  }

  // Clear user session (logout)
  Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_emailKey);
      await prefs.remove(_rememberMeKey);
      return true;
    } catch (e) {
      print('Error clearing session: $e');
      return false;
    }
  }
}
