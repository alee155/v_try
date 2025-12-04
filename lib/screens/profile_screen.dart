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
import 'package:vtry/widgets/settings_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginController _loginController = Get.find<LoginController>();
  ProfileController? _profileController;
  bool isNotificationOn = true;
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    // Try to find ProfileController safely
    try {
      _profileController = Get.find<ProfileController>();
      // Load user profile data if not already loaded
      if (_profileController != null &&
          (_profileController!.getUserInfo().isEmpty)) {
        _profileController!.loadUserProfileFromStorage();
      }
    } catch (e) {
      if (kDebugMode) {
        print('ProfileController not found in GetX container: $e');
      }
    }
  }

  // Helper method to build profile info items

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
                    // User name from ProfileController
                    _profileController != null
                        ? Obx(() {
                            final userData =
                                _profileController?.getUserInfo() ?? {};
                            final userName = userData['name'] ?? 'User';
                            return Text(
                              userName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          })
                        : Text(
                            "User",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    // User email from ProfileController
                    _profileController != null
                        ? Obx(() {
                            final userData =
                                _profileController?.getUserInfo() ?? {};
                            final userEmail = userData['email'] ?? 'No email';
                            return Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                            );
                          })
                        : Text(
                            "No email available",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                    SizedBox(height: 10.h),
                    // User info section
                    // _profileController != null
                    //     ? Obx(() {
                    //         final userData =
                    //             _profileController?.getUserInfo() ?? {};
                    //         return Column(
                    //           children: [
                    //             if (userData['id'] != null)
                    //               _buildProfileItem(
                    //                 'User ID',
                    //                 userData['id'].toString(),
                    //               ),
                    //             if (userData['userName'] != null)
                    //               _buildProfileItem(
                    //                 'Username',
                    //                 userData['userName'].toString(),
                    //               ),
                    //             if (userData['phone'] != null)
                    //               _buildProfileItem(
                    //                 'Phone',
                    //                 userData['phone'].toString(),
                    //               ),
                    //           ],
                    //         );
                    //       })
                    //     : const SizedBox(),
                    // SizedBox(height: 10.h),
                    Column(
                      children: [
                        TileContainer(
                          child: SettingsTile(
                            title: "Edit Profile",
                            iconPath: "assets/icons/user_icon.svg",
                          ),
                        ),
                        TileContainer(
                          child: SettingsTile(
                            title: "Edit Password",
                            iconPath: "assets/icons/password_icon.svg",
                          ),
                        ),

                        // Notification Switch
                        TileContainer(
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                            ),
                            title: Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            secondary: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            value: isNotificationOn,
                            onChanged: (value) =>
                                setState(() => isNotificationOn = value),
                          ),
                        ),

                        // Theme Switch
                        TileContainer(
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                            ),
                            title: Text(
                              "Dark Mode",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            secondary: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.dark_mode,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            value: isDarkTheme,
                            onChanged: (value) =>
                                setState(() => isDarkTheme = value),
                          ),
                        ),

                        TileContainer(
                          child: SettingsTile(
                            title: "Subscription",
                            iconPath: "assets/icons/payment.svg",
                          ),
                        ),

                        TileContainer(
                          child: SettingsTile(
                            title: "Delete Account",
                            iconPath: "assets/icons/delete_icon.svg",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _logout();
                          },
                          child: TileContainer(
                            child: SettingsTile(
                              title: "Logout",
                              iconPath: "assets/icons/logout_icon.svg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 130.h,
            left: 10.w,
            child: _profileController != null
                ? Obx(() {
                    final userData = _profileController?.getUserInfo() ?? {};
                    final userName = userData['name'] ?? 'User';
                    final firstLetter = userName.isNotEmpty
                        ? userName[0].toUpperCase()
                        : 'U';

                    return Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                        color: AppColors.primaryBlue.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  })
                : Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                      color: AppColors.primaryBlue.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'U',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
