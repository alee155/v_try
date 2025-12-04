import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/forgot_otp_controller.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';

class ForgotVerifyScreen extends StatelessWidget {
  final String email;

  ForgotVerifyScreen({super.key, required this.email});

  late final ForgotOtpController controller;

  @override
  Widget build(BuildContext context) {
    // Initialize controller with the email parameter
    controller = Get.put(ForgotOtpController(email: email));
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/forgot.png',
                  height: 180.h,
                  width: 180.w,
                  fit: BoxFit.contain,
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
                        color: AppColors.darkPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              20.h.verticalSpace,
              OtpTextField(
                numberOfFields: 4,
                borderColor: AppColors.darkPrimary,
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(12),
                fieldWidth: 60.w,
                keyboardType: TextInputType.number,
                focusedBorderColor: AppColors.darkPrimary,
                onCodeChanged: (String code) {
                  // Update OTP as user types
                  controller.setOtp(code);
                },
                onSubmit: (String verificationCode) {
                  controller.setOtp(verificationCode);
                  // Print payload data when OTP is entered
                  if (kDebugMode) {
                    print(
                      '\n============= VERIFY FORGOT OTP PAYLOAD ==============',
                    );
                    print('Email: $email');
                    print('OTP: $verificationCode');
                    print('Payload: {');
                    print('  "email": "$email",');
                    print('  "otp": "$verificationCode"');
                    print('}');
                    print(
                      '==================================================\n',
                    );
                  }
                },
              ),

              20.h.verticalSpace,

              // Timer
              Obx(
                () => Text(
                  controller.isResendEnabled.value
                      ? "You can resend OTP now"
                      : "Expires in ${controller.formattedTime}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: controller.isResendEnabled.value
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              10.h.verticalSpace,

              // Resend button
              Obx(
                () => GestureDetector(
                  onTap: controller.isResendEnabled.value
                      ? controller.resendOtp
                      : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.darkPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: controller.isResendEnabled.value
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
              20.h.verticalSpace,
            ],
          ),
        ),
      ),

      // Button at bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkPrimary,
                  ),
                )
              : CustomButton(
                  text: "Verify OTP",
                  onPressed: () => controller.verifyOtp(),
                  backgroundColor: AppColors.darkPrimary,
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
