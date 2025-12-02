import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:vtry/services/session_service.dart';

class ApiService {
  final String baseUrl = 'https://virtualtryon-tan.vercel.app';
  final SessionService _sessionService = SessionService();

  // Get authorization header with token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _sessionService.getToken();
    final headers = {'Content-Type': 'application/json'};

    // Add authorization header if token exists
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Make authenticated GET request
  Future<Map<String, dynamic>> authenticatedGet(String endpoint) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      if (kDebugMode) {
        print('======= GET REQUEST =======');
        print('Endpoint: $endpoint');
        print('Headers: $headers');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        print('==========================');
      }

      final data = json.decode(response.body);
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      return {
        'success': false,
        'message': 'API request failed: $e',
        'statusCode': 500,
      };
    }
  }

  // Make authenticated POST request
  Future<Map<String, dynamic>> authenticatedPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('======= POST REQUEST =======');
        print('Endpoint: $endpoint');
        print('Headers: $headers');
        print('Body: $body');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        print('===========================');
      }

      final data = json.decode(response.body);
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      return {
        'success': false,
        'message': 'API request failed: $e',
        'statusCode': 500,
      };
    }
  }

  // Validate user token
  Future<bool> validateToken() async {
    try {
      final token = await _sessionService.getToken();

      // Return false if no token exists
      if (token == null || token.isEmpty) {
        return false;
      }

      // Make a request to a protected endpoint to check token validity
      // Replace '/api/user/profile' with your actual protected endpoint
      final result = await authenticatedGet('/api/user/profile');
      return result['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Token validation error: $e');
      }
      return false;
    }
  }

  // Fetch product categories
  Future<Map<String, dynamic>> getProductCategories() async {
    try {
      final result = await authenticatedGet('/api/product/categories');
      if (kDebugMode) {
        print('Categories API Response: ${result['data']}');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Fetch categories error: $e');
      }
      return {
        'success': false,
        'message': 'Failed to fetch categories: $e',
        'statusCode': 500,
      };
    }
  }

  // Fetch products by category with pagination
  Future<Map<String, dynamic>> getProductsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // URL encode the category name for the API request
      final encodedCategory = Uri.encodeComponent(category);
      final result = await authenticatedGet(
        '/api/product/all-products?category=$encodedCategory&page=$page&limit=$limit',
      );

      if (kDebugMode) {
        print('\n======= PRODUCTS API REQUEST =======');
        print('Category: $category');
        print('Page: $page, Limit: $limit');
        print('================================\n');

        print('\n======= PRODUCTS API RESPONSE =======');
        print('Success: ${result['success']}');
        print('Status Code: ${result['statusCode']}');
        print('Total Products: ${result['data']?['total'] ?? 'N/A'}');
        print('Total Pages: ${result['data']?['totalPages'] ?? 'N/A'}');
        print('Current Page: ${result['data']?['page'] ?? 'N/A'}');
        print('================================\n');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('\n======= PRODUCTS API ERROR =======');
        print('Category: $category');
        print('Error: $e');
        print('================================\n');
      }
      return {
        'success': false,
        'message': 'Failed to fetch products: $e',
        'statusCode': 500,
      };
    }
  }
}
