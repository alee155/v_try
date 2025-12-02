import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/screens/bottom_nav_screen.dart';
import 'package:vtry/services/auth_service.dart';
import 'package:vtry/services/session_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var stayLoggedInLogin = false.obs;
  var stayLoggedInSignup = false.obs;

  void toggleStayLoggedInLogin() {
    stayLoggedInLogin.value = !stayLoggedInLogin.value;
  }

  void toggleStayLoggedInSignup() {
    stayLoggedInSignup.value = !stayLoggedInSignup.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validate form fields
  bool validateForm() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  // Sign in user
  Future<void> signin() async {
    if (!validateForm()) return;

    isLoading.value = true;

    // Print payload to terminal
    if (kDebugMode) {
      print('\n============= SIGNIN PAYLOAD DATA ==============');
      print('Email: ${emailController.text.trim()}');
      print('Password: ${passwordController.text.trim()}');
      print('Remember Me: ${stayLoggedInLogin.value}');
      print('Payload: {');
      print('  "email": "${emailController.text.trim()}",');
      print('  "password": "${passwordController.text.trim()}"');
      print('}');
      print('===============================================\n');
    }

    try {
      final response = await _authService.signin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      isLoading.value = false;

      // Show toast message with API response
      if (response['success']) {
        // Extract token and user data from response
        final data = response['data'];
        final token = data['token'] ?? '';
        final userId = data['user']?['_id'] ?? '';
        final email = emailController.text.trim();
        
        // Save session data if remember me is checked
        if (stayLoggedInLogin.value) {
          await _sessionService.saveUserSession(
            token: token,
            userId: userId,
            email: email,
            rememberMe: stayLoggedInLogin.value,
          );
          
          if (kDebugMode) {
            print('\n======= SESSION SAVED =======');
            print('Token: $token');
            print('User ID: $userId');
            print('Email: $email');
            print('Remember Me: ${stayLoggedInLogin.value}');
            print('============================\n');
          }
        }

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to home screen or another screen here
        Get.offAll(() => BottomNavScreen());
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('\n======= SIGNIN ERROR =======');
        print('Error: $e');
        print('============================\n');
      }

      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Check if user is already logged in
  Future<bool> checkUserLoggedIn() async {
    return await _sessionService.isLoggedIn();
  }
  
  // Get saved auth token
  Future<String?> getSavedToken() async {
    return await _sessionService.getToken();
  }
  
  // Logout user and clear session
  Future<void> logout() async {
    await _sessionService.clearSession();
    // Additional logout logic can be added here
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
