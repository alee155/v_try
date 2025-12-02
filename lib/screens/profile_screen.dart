import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/auth/welcome_screen.dart';
import 'package:vtry/controllers/login_controller.dart';
import 'package:vtry/controllers/profile_controller.dart';
import 'package:vtry/screens/settings_screen.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginController _loginController = Get.find<LoginController>();
  final ProfileController _profileController = Get.find<ProfileController>();

  // Helper method to build profile info items
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        barrierDismissible: false,
      );

      // Clear user session
      await _loginController.logout();

      if (kDebugMode) {
        print('\n======= USER LOGGED OUT =======');
        print('============================\n');
      }

      // Close loading dialog
      Get.back();

      // Navigate to welcome screen
      Get.offAll(
        () => WelcomeScreen(),
        transition: Transition.leftToRight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // Close loading dialog
      Get.back();

      if (kDebugMode) {
        print('\n======= LOGOUT ERROR =======');
        print('Error: $e');
        print('============================\n');
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.primaryBlue)),

          Positioned(
            top: 50.h,
            right: 10.w,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const SettingsScreen());
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 650.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.h.verticalSpace,
                    Text(
                      "Muhammad Ali",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "alee155@gmail.com",
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    ),

                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        childAspectRatio: 1.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _gridItem(Icons.favorite, "05", Colors.pink),
                          _gridItem(Icons.person, "Prime ", Colors.deepPurple),
                          _gridItem(Icons.image, "19", Colors.teal),
                          _gridItem(Icons.star, "4.5", Colors.amber),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 130.h,
            left: 10.w,
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://randomuser.me/api/portraits/women/44.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _gridItem(IconData icon, String title, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 28, color: color),
        ),
        SizedBox(height: 10.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
