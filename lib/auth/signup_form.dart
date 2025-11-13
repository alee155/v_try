import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/signup_controller.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';
import 'package:vtry/widgets/custom_text_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up to Your Account",
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Make sure your account keep secure",
            style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
          ),
          SizedBox(height: 10.h),
          Text(
            "Name",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          CustomTextField(
            controller: controller.nameController,
            hint: "Enter your name",
          ),

          SizedBox(height: 10.h),
          Text(
            "User Name",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          CustomTextField(
            controller: controller.usernameController,
            hint: "Enter your user name",
          ),
          SizedBox(height: 10.h),
          Text(
            "Email Address",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          CustomTextField(
            controller: controller.emailController,
            hint: "Enter your email",
          ),
          SizedBox(height: 10.h),
          Text(
            "Phone Number",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          CustomTextField(
            controller: controller.phoneController,
            hint: "Enter your phone number",
          ),
          SizedBox(height: 10.h),
          Text(
            "Password",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          Obx(
            () => CustomTextField(
              controller: controller.passwordController,
              hint: "Enter your password",
              isPassword: true,
              isPasswordVisible: controller.isPasswordVisible.value,
              togglePassword: controller.togglePasswordVisibility,
            ),
          ),
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: controller.agreeToTerms.value,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (_) => controller.toggleTermsAgreement(),
                ),
                Text(
                  "I agree with the terms and conditions by creating an\naccount",
                  style: TextStyle(fontSize: 10.sp, color: AppColors.grey),
                ),
              ],
            ),
          ),

          10.h.verticalSpace,
          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  )
                : CustomButton(
                    text: "Create Account",
                    onPressed: () {
                      // Print payload data to terminal when button is tapped
                      if (kDebugMode) {
                        print(
                          '\n============= SIGNUP PAYLOAD DATA ==============',
                        );
                        print('Name: ${controller.nameController.text.trim()}');
                        print(
                          'UserName: ${controller.usernameController.text.trim()}',
                        );
                        print(
                          'Email: ${controller.emailController.text.trim()}',
                        );
                        print(
                          'Phone: ${controller.phoneController.text.trim()}',
                        );
                        print(
                          'Password: ${controller.passwordController.text.trim()}',
                        );
                        print('Payload: {');
                        print(
                          '  "name": "${controller.nameController.text.trim()}",',
                        );
                        print(
                          '  "userName": "${controller.usernameController.text.trim()}",',
                        );
                        print(
                          '  "email": "${controller.emailController.text.trim()}",',
                        );
                        print(
                          '  "phone": ${controller.phoneController.text.trim()},',
                        );
                        print(
                          '  "password": "${controller.passwordController.text.trim()}"',
                        );
                        print('}');
                        print(
                          '===============================================\n',
                        );
                      }

                      // Call the signup method
                      controller.signup();
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
        ],
      ),
    );
  }
}
