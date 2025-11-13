import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/otp_controller.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final OtpController otpController = Get.put(OtpController());

  OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Main Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon / illustration
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: AppColors.primaryBlue,
                ),
              ),
              40.h.verticalSpace,

              Text(
                "Verify Your Account",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              10.h.verticalSpace,
              Text(
                "Enter the 4-digit code sent to your email",
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              5.h.verticalSpace,
              RichText(
                text: TextSpan(
                  text: "OTP has been sent to ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              20.h.verticalSpace,
              OtpTextField(
                numberOfFields: 4,
                borderColor: AppColors.primaryBlue,
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(12),
                fieldWidth: 60.w,
                keyboardType: TextInputType.number,
                focusedBorderColor: AppColors.primaryBlue,
                clearText: otpController.isLoading.value,
                onCodeChanged: (String code) {
                  // Update OTP as user types
                  otpController.setOtp(code);
                },
                onSubmit: (String verificationCode) {
                  otpController.setOtp(verificationCode);
                  // Auto-verify OTP when all 4 digits are entered
                  if (verificationCode.length == 4) {
                    // Print payload data when OTP is completed
                    if (kDebugMode) {
                      print(
                        '\n============= OTP VERIFICATION PAYLOAD ==============',
                      );
                      print('Email: $email');
                      print('OTP: $verificationCode');
                      print(
                        'Payload: {"email": "$email", "otp": "$verificationCode"}',
                      );
                      print(
                        '==================================================\n',
                      );
                    }

                    // Show feedback to user that we're processing
                    // Get.snackbar(
                    //   'Processing',
                    //   'Verifying OTP for $email...',
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   backgroundColor: AppColors.primaryBlue,
                    //   colorText: Colors.white,
                    //   duration: const Duration(seconds: 1),
                    // );
                    otpController.verifyOtp(email);
                  }
                },
              ),
              20.h.verticalSpace,

              // Countdown Timer
              Obx(
                () => Text(
                  otpController.isResendEnabled.value
                      ? "You can resend OTP now"
                      : "Expires in ${otpController.formattedTime}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: otpController.isResendEnabled.value
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              20.h.verticalSpace,

              // Resend OTP Text
              Obx(
                () => GestureDetector(
                  onTap: otpController.isResendEnabled.value
                      ? otpController.resendOtp
                      : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                      decoration: otpController.isResendEnabled.value
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Button at bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Obx(
          () => otpController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                )
              : CustomButton(
                  text: "Verify OTP",
                  onPressed: () {
                    // Print payload data when button is tapped
                    if (kDebugMode) {
                      print(
                        '\n============= OTP VERIFICATION PAYLOAD ==============',
                      );
                      print('Email: $email');
                      print('OTP: ${otpController.otp.value}');
                      print(
                        'Payload: {"email": "$email", "otp": "${otpController.otp.value}"}',
                      );
                      print(
                        '==================================================\n',
                      );
                    }

                    // Proceed with verification
                    otpController.verifyOtp(email);
                  },
                  backgroundColor: AppColors.primaryBlue,
                  textColor: Colors.white,
                  textSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  borderRadius: 30.r,
                  height: 55.h,
                ),
        ),
      ),
    );
  }
}
