import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/auth/login_form.dart';
import 'package:vtry/auth/signup_form.dart';
import 'package:vtry/utils/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: AppColors.darkPrimary),

          // Top container
          Positioned(
            top: 80.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 183.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkPrimary,
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello, There',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.darkWhite,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlack,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.darkPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(24.r)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 5.w,
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppColors.darkWhite,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: AppColors.darkPrimary,
                          unselectedLabelColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(text: 'Login'),
                            Tab(text: 'Sign Up'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 520.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.darkWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [LoginForm(), SignupForm()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
