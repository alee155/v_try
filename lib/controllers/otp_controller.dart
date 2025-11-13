import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtry/screens/success_screen.dart';
import 'package:vtry/services/auth_service.dart';

class OtpController extends GetxController {
  final AuthService _authService = AuthService();
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

  void resendOtp() {
    // Your resend OTP logic here
    startTimer(); // restart timer
  }

  void setOtp(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp(String email) async {
    if (otp.value.isEmpty || otp.value.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter a valid 4-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.verifyOtp(
        email: email,
        otp: otp.value,
      );

      isLoading.value = false;

      // Print response in terminal
      if (kDebugMode) {
        print('\n======= OTP VERIFICATION RESPONSE =======');
        print('Status Code: ${response['statusCode']}');
        print('Success: ${response['success']}');
        print('Message: ${response['message']}');
        try {
          print('Response Data: ${json.encode(response['data'])}');
        } catch (e) {
          print('Response Data: ${response['data']}');
        }
        print('=======================================\n');
      }

      // Show toast message with response
      if (response['success']) {
        // // Show success toast
        // Get.snackbar(
        //   'Success',
        //   'OTP verified successfully',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   duration: const Duration(seconds: 3),
        // );

        Get.off(
          () => const SuccessScreen(),
          transition: Transition.fadeIn,
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

      // Print error in terminal
      if (kDebugMode) {
        print('\n======= OTP VERIFICATION ERROR =======');
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
