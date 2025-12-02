import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:vtry/utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true;
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            tileContainer(
              child: settingsTile("Edit Profile", "assets/icons/user_icon.svg"),
            ),

            tileContainer(
              child: settingsTile(
                "Edit Password",
                "assets/icons/password_icon.svg",
              ),
            ),

            // ------------------ NOTIFICATION SWITCH ------------------
            tileContainer(
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
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
                onChanged: (value) {
                  setState(() {
                    isNotificationOn = value;
                  });
                },
              ),
            ),

            // ------------------ THEME SWITCH ------------------
            tileContainer(
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
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
                  child: Icon(Icons.dark_mode, color: AppColors.primaryBlue),
                ),
                value: isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                  // You can add your theme switching logic here
                },
              ),
            ),

            tileContainer(
              child: settingsTile("Subscription", "assets/icons/payment.svg"),
            ),
            tileContainer(
              child: settingsTile("Logout", "assets/icons/logout_icon.svg"),
            ),
            tileContainer(
              child: settingsTile(
                "Delete Account",
                "assets/icons/delete_icon.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- WRAPPER FOR CLEAN CARD DESIGN ----------
  Widget tileContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // ---------- NORMAL SETTINGS TILE ----------
  Widget settingsTile(String title, String iconPath) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 20.w,
          height: 20.h,
          color: AppColors.primaryBlue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }
}
