import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vtry/services/session_service.dart';

class ProfileController extends GetxController {
  // Services
  final SessionService _sessionService = SessionService();

  // State variables
  var isLoading = false.obs;
  var userData = Rx<Map<String, dynamic>>({});
  var errorMessage = ''.obs;

  // Base URL for API
  final String baseUrl = 'https://virtualtryon-tan.vercel.app';

  // Fetch user profile data
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      // Get auth token from session service
      final token = await _sessionService.getToken();

      if (token == null || token.isEmpty) {
        errorMessage.value = 'No authentication token found';
        isLoading.value = false;
        return;
      }

      // Log API request details
      if (kDebugMode) {
        print('\n============= USER PROFILE API REQUEST ==============');
        print('Endpoint: /api/user/profile');
        print('Authorization: Bearer $token');
        print('===================================================\n');
      }

      // Make API call to fetch user profile
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      isLoading.value = false;

      // Log API response
      if (kDebugMode) {
        print('\n============= USER PROFILE API RESPONSE ==============');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        print('====================================================\n');
      }

      // Handle response based on status code
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData.value = data;

        // Print user data in readable format
        if (kDebugMode) {
          print('\n============= USER PROFILE DATA ==============');
          data.forEach((key, value) {
            print('$key: $value');
          });
          print('==============================================\n');
        }
      } else {
        // Handle error responses
        errorMessage.value = 'Failed to load profile: ${response.statusCode}';
        if (kDebugMode) {
          print('\n============= USER PROFILE ERROR ==============');
          print('Status Code: ${response.statusCode}');
          print('Error: ${response.body}');
          print('==============================================\n');
        }
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: $e';

      if (kDebugMode) {
        print('\n============= USER PROFILE EXCEPTION ==============');
        print('Error: $e');
        print('=================================================\n');
      }
    }
  }

  // Get user information
  Map<String, dynamic> getUserInfo() {
    return userData.value;
  }
}
