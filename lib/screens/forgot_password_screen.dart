import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/forgot_password_controller.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
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
                "Forgot Password",
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
              "Enter your email address below to reset your password.",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),

            // 📧 Email Input Label
            Text(
              "Email Address",
              style: TextStyle(
                color: AppColors.darkBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),

            // 📥 Email Input Field
            TextField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.darkWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.darkPrimary,
                    width: 1,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // 🚀 Submit Button
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.darkPrimary,
                      ),
                    )
                  : CustomButton(
                      text: "Submit",
                      onPressed: () {
                        // Print payload data when button is tapped
                        if (kDebugMode) {
                          print(
                            '\n============= FORGOT PASSWORD PAYLOAD ==============',
                          );
                          print(
                            'Email: ${controller.emailController.text.trim()}',
                          );
                          print('Payload: {');
                          print(
                            '  "email": "${controller.emailController.text.trim()}"',
                          );
                          print('}');
                          print(
                            '================================================\n',
                          );
                        }

                        // Call forgot password method
                        controller.requestPasswordReset();
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

            // 📨 Helper Text (OTP Info)
            Center(
              child: Text(
                "You will receive an OTP on your registered email for verification.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 30.h),

            // 🔙 Back to Login
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Back to Login",
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
