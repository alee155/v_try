import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/login_controller.dart';
import 'package:vtry/screens/forgot_password_screen.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';
import 'package:vtry/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // GetX Controller
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login to Your Account",
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColors.darkBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Make sure that you already have an account.",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 40.h),

          // Email Field
          Text(
            "Email Address",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.darkBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          CustomTextField(
            controller: controller.emailController,
            hint: "Enter your email",
          ),
          SizedBox(height: 20.h),

          // Password Field
          Text(
            "Password",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.darkBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Obx(
            () => CustomTextField(
              controller: controller.passwordController,
              hint: "Enter your password",
              isPassword: true,
              isPasswordVisible: controller.isPasswordVisible.value,
              togglePassword: controller.togglePasswordVisibility,
            ),
          ),
          SizedBox(height: 30.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      value: controller.stayLoggedInLogin.value,
                      activeColor: AppColors.darkPrimary,
                      onChanged: (_) => controller.toggleStayLoggedInLogin(),
                    ),
                    Text(
                      "Remember me",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.darkBlack,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ForgotPasswordScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkPrimary,
                    ),
                  )
                : CustomButton(
                    text: "Login",
                    onPressed: () {
                      // Print payload data when button is tapped
                      if (kDebugMode) {
                        print(
                          '\n============= LOGIN PAYLOAD DATA ==============',
                        );
                        print(
                          'Email: ${controller.emailController.text.trim()}',
                        );
                        print(
                          'Password: ${controller.passwordController.text.trim()}',
                        );
                        print('Payload: {');
                        print(
                          '  "email": "${controller.emailController.text.trim()}",',
                        );
                        print(
                          '  "password": "${controller.passwordController.text.trim()}"',
                        );
                        print('}');
                        print('============================================\n');
                      }

                      // Call signin method
                      controller.signin();
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
        ],
      ),
    );
  }
}
