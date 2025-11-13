import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  
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
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
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
        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate to home screen or another screen here
        // Get.offAll(() => HomeScreen());
        
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
          snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
