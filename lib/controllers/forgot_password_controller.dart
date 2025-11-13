import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/auth/forgot_verify.dart';
import 'package:vtry/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  
  // State variables
  var isLoading = false.obs;
  
  // Request password reset
  Future<void> requestPasswordReset() async {
    final email = emailController.text.trim();
    
    // Validate email
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    // Print payload data
    if (kDebugMode) {
      print('\n============= FORGOT PASSWORD PAYLOAD DATA ==============');
      print('Email: $email');
      print('Payload: {');
      print('  "email": "$email"');
      print('}');
      print('======================================================\n');
    }
    
    isLoading.value = true;
    
    try {
      final response = await _authService.forgotPassword(email: email);
      
      isLoading.value = false;
      
      // Show toast message with API response
      if (response['success']) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Reset instructions sent to your email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate to verify OTP screen if response is successful (200)
        if (response['statusCode'] == 200) {
          Get.to(
            () => ForgotVerifyScreen(email: email),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to send reset instructions',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;
      
      if (kDebugMode) {
        print('\n======= FORGOT PASSWORD ERROR =======');
        print('Error: $e');
        print('====================================\n');
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
    super.dispose();
  }
}
