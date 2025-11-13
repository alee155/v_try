import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  final String baseUrl = 'https://virtualtryon-tan.vercel.app';

  // Sign up user with email, password and other details
  Future<Map<String, dynamic>> signup({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
    required bool agreeToTerms,
  }) async {
    try {
      // Validate all fields are provided
      if (name.isEmpty ||
          username.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          password.isEmpty) {
        return {
          'success': false,
          'message': 'All fields are required',
          'statusCode': 400,
        };
      }

      // Validate terms agreement
      if (!agreeToTerms) {
        return {
          'success': false,
          'message': 'You must agree to terms and conditions',
          'statusCode': 400,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "userName": username,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************Signup API Response Status***************: ${response.statusCode}',
        );
        print(
          '***************Signup API Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 201,
        'message':
            responseData['message'] ??
            (response.statusCode == 201
                ? 'Signup successful'
                : 'Signup failed'),
        'data': responseData,
        'statusCode': response.statusCode,
        'email': email, // Return email for use in verification screen
      };
    } catch (error) {
      if (kDebugMode) {
        print('Signup Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred during signup: $error',
        'statusCode': 500,
      };
    }
  }

  // Sign in user with email and password
  Future<Map<String, dynamic>> signin({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email and password
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email and password are required',
          'statusCode': 400,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email, "password": password}),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************Signin API Response Status***************: ${response.statusCode}',
        );
        print(
          '***************Signin API Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message':
            responseData['message'] ??
            (response.statusCode == 200
                ? 'Signin successful'
                : 'Signin failed'),
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (error) {
      if (kDebugMode) {
        print('Signin Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred during signin: $error',
        'statusCode': 500,
      };
    }
  }

  // Verify OTP sent to user's email
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      // Validate email and OTP
      if (email.isEmpty || otp.isEmpty) {
        return {
          'success': false,
          'message': 'Email and OTP are required',
          'statusCode': 400,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************OTP Verification Response Status***************: ${response.statusCode}',
        );
        print(
          '***************OTP Verification Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message':
            responseData['message'] ??
            (response.statusCode == 200
                ? 'OTP verified successfully'
                : 'OTP verification failed'),
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (error) {
      if (kDebugMode) {
        print('OTP Verification Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred during OTP verification: $error',
        'statusCode': 500,
      };
    }
  }

  // Request password reset via email
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      // Validate email
      if (email.isEmpty) {
        return {
          'success': false,
          'message': 'Email is required',
          'statusCode': 400,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/forgotPassword'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email}),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************Forgot Password API Response Status***************: ${response.statusCode}',
        );
        print(
          '***************Forgot Password API Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message':
            responseData['message'] ??
            (response.statusCode == 200
                ? 'Reset instructions sent to your email'
                : 'Failed to send reset instructions'),
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (error) {
      if (kDebugMode) {
        print('Forgot Password Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred while requesting password reset: $error',
        'statusCode': 500,
      };
    }
  }

  // Verify OTP for password reset
  Future<Map<String, dynamic>> verifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    try {
      // Validate email and OTP
      if (email.isEmpty || otp.isEmpty) {
        return {
          'success': false,
          'message': 'Email and OTP are required',
          'statusCode': 400,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/verifyForgotOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email, "otp": otp}),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************Verify Forgot OTP API Response Status***************: ${response.statusCode}',
        );
        print(
          '***************Verify Forgot OTP API Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message':
            responseData['message'] ??
            (response.statusCode == 200
                ? 'OTP verified successfully'
                : 'Failed to verify OTP'),
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (error) {
      if (kDebugMode) {
        print('Verify Forgot OTP Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred during OTP verification: $error',
        'statusCode': 500,
      };
    }
  }

  // Reset user password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Validate parameters
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        return {
          'success': false,
          'message': 'All fields are required',
          'statusCode': 400,
        };
      }

      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Passwords do not match',
          'statusCode': 400,
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/user/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
      );

      if (kDebugMode) {
        print('******************************************************');
        print(
          '***************Reset Password API Response Status***************: ${response.statusCode}',
        );
        print(
          '***************Reset Password API Response Body***************: ${response.body}',
        );
        print('******************************************************');
      }

      final responseData = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message':
            responseData['message'] ??
            (response.statusCode == 200
                ? 'Password reset successful'
                : 'Failed to reset password'),
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (error) {
      if (kDebugMode) {
        print('Reset Password Error: $error');
      }
      return {
        'success': false,
        'message': 'An error occurred during password reset: $error',
        'statusCode': 500,
      };
    }
  }
}
