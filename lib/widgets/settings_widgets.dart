import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vtry/utils/app_colors.dart';

class TileContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const TileContainer({super.key, required this.child, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;
  final bool isDark;

  const SettingsTile({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.darkPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 20.w,
          height: 20.h,
          color: AppColors.darkPrimary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: isDark ? Colors.white70 : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
