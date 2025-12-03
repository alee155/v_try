import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _rememberMeKey = 'remember_me';
  static const String _userProfileKey = 'user_profile';

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

  // Save user profile data
  Future<bool> saveUserProfile(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userProfileKey, jsonEncode(userData));
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Get saved user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userProfileJson = prefs.getString(_userProfileKey);

      if (userProfileJson != null && userProfileJson.isNotEmpty) {
        return jsonDecode(userProfileJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Get user's name
  Future<String?> getUserName() async {
    try {
      final userData = await getUserProfile();
      return userData?['name'];
    } catch (e) {
      print('Error getting user name: $e');
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
      await prefs.remove(_userProfileKey);
      return true;
    } catch (e) {
      print('Error clearing session: $e');
      return false;
    }
  }
}
