import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/auth/welcome_screen.dart';
import 'package:vtry/services/auth_service.dart';

class ResetPasswordController extends GetxController {
  final AuthService _authService = AuthService();
  final String email;

  // Form controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // State variables
  var isLoading = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  ResetPasswordController({required this.email});

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate form fields
  bool validateForm() {
    if (newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (newPasswordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  // Reset password
  Future<void> resetPassword() async {
    if (!validateForm()) return;

    isLoading.value = true;

    // Print payload data
    if (kDebugMode) {
      print('\n============= RESET PASSWORD PAYLOAD DATA ==============');
      print('Email: $email');
      print('Password: ${newPasswordController.text.trim()}');
      print('Confirm Password: ${confirmPasswordController.text.trim()}');
      print('Payload: {');
      print('  "email": "$email",');
      print('  "password": "${newPasswordController.text.trim()}",');
      print('  "confirmPassword": "${confirmPasswordController.text.trim()}"');
      print('}');
      print('===================================================\n');
    }

    try {
      final response = await _authService.resetPassword(
        email: email,
        password: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      isLoading.value = false;

      // Show toast message with API response
      if (response['success']) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Password reset successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate back to login screen on success
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(
            () => const WelcomeScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to reset password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('\n======= RESET PASSWORD ERROR =======');
        print('Error: $e');
        print('===================================\n');
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
