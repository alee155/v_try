import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/reset_password_controller.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';
import 'package:vtry/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  ResetPasswordScreen({super.key, required this.email});

  late final ResetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    // Initialize controller with email
    controller = Get.put(ResetPasswordController(email: email));
    return Scaffold(
      backgroundColor: AppColors.darkWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Image
            Center(
              child: Image.asset(
                'assets/images/forgot.png',
                height: 180.h,
                width: 180.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),

            // 🔤 Title
            Center(
              child: Text(
                "Reset Password",
                style: TextStyle(
                  color: AppColors.darkBlack,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // 📄 Description
            Text(
              "Enter your new password below and confirm it to reset your account password.",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),

            // New Password Field
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.darkBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomTextField(
                controller: controller.newPasswordController,
                hint: "Enter your new password",
                isPassword: true,
                isPasswordVisible: controller.isNewPasswordVisible.value,
                togglePassword: controller.toggleNewPasswordVisibility,
              ),
            ),
            SizedBox(height: 20.h),

            // Confirm Password Field
            Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.darkBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomTextField(
                controller: controller.confirmPasswordController,
                hint: "Confirm your new password",
                isPassword: true,
                isPasswordVisible: controller.isConfirmPasswordVisible.value,
                togglePassword: controller.toggleConfirmPasswordVisibility,
              ),
            ),

            SizedBox(height: 30.h),

            // Reset Button
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.darkPrimary,
                      ),
                    )
                  : CustomButton(
                      text: "Reset Password",
                      onPressed: () {
                        // Print payload data when button is tapped
                        if (kDebugMode) {
                          print(
                            '\n============= RESET PASSWORD PAYLOAD ==============',
                          );
                          print('Email: $email');
                          print(
                            'Password: ${controller.newPasswordController.text.trim()}',
                          );
                          print(
                            'Confirm Password: ${controller.confirmPasswordController.text.trim()}',
                          );
                          print('Payload: {');
                          print('  "email": "$email",');
                          print(
                            '  "password": "${controller.newPasswordController.text.trim()}",',
                          );
                          print(
                            '  "confirmPassword": "${controller.confirmPasswordController.text.trim()}"',
                          );
                          print('}');
                          print(
                            '================================================\n',
                          );
                        }

                        // Call reset password method
                        controller.resetPassword();
                      },
                      backgroundColor: AppColors.darkPrimary,
                      textColor: Colors.white,
                      textSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      borderRadius: 30.r,
                      height: 55.h,
                    ),
            ),

            SizedBox(height: 15.h),

            // 📨 Helper Text
            Center(
              child: Text(
                "Make sure your new password is at least 8 characters long.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
