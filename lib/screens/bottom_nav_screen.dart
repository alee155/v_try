import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:vtry/screens/dashboard_creen.dart';
import 'package:vtry/screens/favorites_screen.dart';
import 'package:vtry/screens/profile_screen.dart';
import 'package:vtry/screens/search_screen.dart';
import 'package:vtry/utils/app_colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  Widget _buildNavItem(String assetName, bool isActive) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black26.withOpacity(0.2) : Colors.transparent,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            assetName,
            colorFilter: ColorFilter.mode(
              AppColors.primaryBlue,
              BlendMode.srcIn,
            ),
            height: 28.h,
            width: 28.w,
          ),
          3.h.verticalSpace,
          Container(
            height: 5.h,
            width: 5.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.white : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _getTabContent(),

          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 65.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.08),
                      ],
                      stops: const [0.1, 0.9],
                    ),
                    borderRadius: BorderRadius.circular(34.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.25),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: -3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _currentIndex = 0),
                        child: _buildNavItem(
                          "assets/icons/home.svg",
                          _currentIndex == 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _currentIndex = 1),
                        child: _buildNavItem(
                          "assets/icons/fav.svg",
                          _currentIndex == 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _currentIndex = 2),
                        child: _buildNavItem(
                          "assets/icons/cart.svg",
                          _currentIndex == 2,
                        ),
                      ),

                      GestureDetector(
                        onTap: () => setState(() => _currentIndex = 3),
                        child: _buildNavItem(
                          "assets/icons/profile.svg",
                          _currentIndex == 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTabContent() {
    switch (_currentIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const FavoriteScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
