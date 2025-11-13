import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/screens/resetPassword_screen.dart';
import 'package:vtry/services/auth_service.dart';

class ForgotOtpController extends GetxController {
  final AuthService _authService = AuthService();
  final String email;

  ForgotOtpController({required this.email});

  // OTP state
  var otp = ''.obs;
  var isLoading = false.obs;
  var secondsRemaining = 300.obs; // 5 minutes countdown
  var isResendEnabled = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 300;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        isResendEnabled.value = true;
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  String get formattedTime {
    final minutes = (secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void setOtp(String value) {
    otp.value = value;
  }

  // Verify the OTP for password reset
  Future<void> verifyOtp() async {
    if (otp.value.isEmpty || otp.value.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter a valid 4-digit OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Print payload data to terminal
    if (kDebugMode) {
      print('\n============= VERIFY FORGOT OTP PAYLOAD ==============');
      print('Email: $email');
      print('OTP: ${otp.value}');
      print('Payload: {');
      print('  "email": "$email",');
      print('  "otp": "${otp.value}"');
      print('}');
      print('==================================================\n');
    }

    isLoading.value = true;

    try {
      final response = await _authService.verifyForgotOtp(
        email: email,
        otp: otp.value,
      );

      isLoading.value = false;

      // Show toast message with API response
      if (response['success']) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP verified successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to reset password screen with email
        Get.off(
          () => ResetPasswordScreen(email: email),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to verify OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('\n======= VERIFY FORGOT OTP ERROR =======');
        print('Error: $e');
        print('======================================\n');
      }

      Get.snackbar(
        'Error',
        'An unexpected error occurred during verification',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void resendOtp() {
    // TODO: Implement resend OTP functionality
    // For now, just restart the timer
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
