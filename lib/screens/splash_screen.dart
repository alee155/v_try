import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vtry/auth/welcome_screen.dart';
import 'package:vtry/controllers/login_controller.dart';
import 'package:vtry/screens/bottom_nav_screen.dart';
import 'package:vtry/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginController _loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    // Show splash screen for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in with "Remember Me" enabled
    final bool isLoggedIn = await _loginController.checkUserLoggedIn();
    final String? token = await _loginController.getSavedToken();

    if (kDebugMode) {
      print('\n======= CHECKING LOGIN STATUS =======');
      print('Is logged in: $isLoggedIn');
      print('Saved token: $token');
      print('====================================\n');
    }

    // Navigate based on login status
    if (isLoggedIn && token != null && token.isNotEmpty) {
      // User is logged in, navigate to home screen
      Get.offAll(
        () => BottomNavScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // User is not logged in, navigate to welcome screen
      Get.offAll(
        () => WelcomeScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: const Center(
        child: Text(
          "Splash Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
