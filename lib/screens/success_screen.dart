import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vtry/auth/welcome_screen.dart';

import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150.h,
                width: 150.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  image: const DecorationImage(
                    image: AssetImage('assets/images/succes.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              40.h.verticalSpace,

              Text(
                "Account Created!",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              15.h.verticalSpace,

              Text(
                "Get login and enjoy AI features instantly.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              50.h.verticalSpace,
              CustomButton(
                text: "Go to Login",
                onPressed: () {
                  Get.off(
                    () => const WelcomeScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: AppColors.primaryBlue,

                textColor: Colors.white,
                textSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                borderRadius: 30.r,
                height: 55.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
