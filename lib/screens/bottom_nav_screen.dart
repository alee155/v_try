import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/login_controller.dart';
import 'package:vtry/controllers/profile_controller.dart';
import 'package:vtry/models/category_model.dart' as category_model;
import 'package:vtry/models/product_model.dart';
import 'package:vtry/screens/edit_profile_screen.dart';
import 'package:vtry/screens/forgot_password_screen.dart';
import 'package:vtry/services/api_service.dart';

import 'package:vtry/screens/dashboard_screen.dart';
import 'package:vtry/screens/favorites_screen.dart';
import 'package:vtry/screens/product_details_screen.dart';
import 'package:vtry/screens/profile_screen.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/GlassContainer.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  final LoginController _loginController = Get.find<LoginController>();
  late final ProfileController _profileController = Get.put(
    ProfileController(),
  );
  final ApiService _apiService = ApiService();
  String? _authToken;

  // Categories related variables
  List<category_model.Category> categories = [];
  bool isLoadingCategories = true;
  String? categoryErrorMessage;
  int selectedCategoryIndex = 0; // Track selected category index

  // Products related variables
  List<Product> products = [];
  bool isLoadingProducts = false;
  String? productErrorMessage;
  int currentPage = 1;
  int totalPages = 1;
  int totalProducts = 0;
  int productsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _checkAuthToken();
    fetchCategories();
  }

  // Handle category selection
  void onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
      if (kDebugMode && categories.isNotEmpty && index < categories.length) {
        print('\n======= CATEGORY SELECTED =======');
        print('Selected category: ${categories[index].title}');
        print('================================\n');
      }
    });

    // Fetch products for the selected category
    if (categories.isNotEmpty && index < categories.length) {
      fetchProducts(categories[index].title, page: 1, resetProducts: true);
    }
  }

  // Fetch products by category with pagination
  Future<void> fetchProducts(
    String category, {
    int page = 1,
    bool resetProducts = false,
  }) async {
    setState(() {
      isLoadingProducts = true;
      productErrorMessage = null;
      if (resetProducts) {
        products = [];
        currentPage = page;
      }
    });

    try {
      final response = await _apiService.getProductsByCategory(
        category,
        page: page,
        limit: productsPerPage,
      );

      if (response['success']) {
        if (response['data'] != null) {
          final productResponse = ProductResponse.fromJson(response['data']);

          setState(() {
            if (resetProducts) {
              products = productResponse.products;
            } else {
              products.addAll(productResponse.products);
            }

            currentPage = productResponse.page;
            totalPages = productResponse.totalPages;
            totalProducts = productResponse.total;
            isLoadingProducts = false;
          });
        } else {
          setState(() {
            productErrorMessage = 'Invalid data format received';
            isLoadingProducts = false;
          });
        }
      } else {
        setState(() {
          productErrorMessage =
              'Failed to fetch products: ${response['message']}';
          isLoadingProducts = false;
        });
      }
    } catch (e) {
      setState(() {
        productErrorMessage = 'Error: $e';
        isLoadingProducts = false;
      });
    }
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    setState(() {
      isLoadingCategories = true;
      categoryErrorMessage = null;
    });

    try {
      final response = await _apiService.getProductCategories();

      if (response['success']) {
        if (response['data'] != null) {
          // API returns a list of strings, not an object
          final List<dynamic> categoriesData = response['data'];
          final categoryResponse = category_model.CategoryResponse.fromJsonList(
            categoriesData,
          );

          setState(() {
            categories = categoryResponse.categories;
            isLoadingCategories = false;
            // Auto-select the first category if available
            if (categories.isNotEmpty) {
              selectedCategoryIndex = 0;
              // Print the selected category
              if (kDebugMode) {
                print('\n======= SELECTED CATEGORY =======');
                print('Auto-selected first category: ${categories[0].title}');
                print('================================\n');
              }
            }
          });

          // Fetch products for the auto-selected category
          if (categories.isNotEmpty) {
            fetchProducts(categories[0].title, page: 1, resetProducts: true);
          }

          if (kDebugMode) {
            print('\n======= CATEGORIES FETCHED =======');
            print('Total categories: ${categories.length}');
            for (var category in categories) {
              print('Category: ${category.title}');
            }
            print('================================\n');
          }
        } else {
          setState(() {
            categoryErrorMessage = 'Invalid data format received';
            isLoadingCategories = false;
          });
        }
      } else {
        setState(() {
          categoryErrorMessage =
              'Failed to fetch categories: ${response['message']}';
          isLoadingCategories = false;
        });
      }
    } catch (e) {
      setState(() {
        categoryErrorMessage = 'Error: $e';
        isLoadingCategories = false;
      });
    }
  }

  Future<void> _checkAuthToken() async {
    // Get the saved auth token
    _authToken = await _loginController.getSavedToken();

    if (kDebugMode) {
      print('\n======= BOTTOM NAV SCREEN =======');
      print('Auth Token: $_authToken');
      print('================================\n');
    }

    // Load profile from storage first (if available)
    await _profileController.loadUserProfileFromStorage();

    // Fetch user profile if token exists
    if (_authToken != null && _authToken!.isNotEmpty) {
      await _profileController.fetchUserProfile();
    }
  }

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
              isActive ? AppColors.darkWhite : AppColors.darkPrimary,
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
            child: GlassContainer(
              height: 65.h,
              borderRadius: BorderRadius.circular(34.r),
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
        ],
      ),
    );
  }

  Widget _getTabContent() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen(
          categories: categories,
          isLoadingCategories: isLoadingCategories,
          categoryErrorMessage: categoryErrorMessage,
          selectedCategoryIndex: selectedCategoryIndex,
          onCategorySelected: onCategorySelected,
          // Products data
          products: products,
          isLoadingProducts: isLoadingProducts,
          productErrorMessage: productErrorMessage,
          currentPage: currentPage,
          totalPages: totalPages,
          // Pagination handler
          onLoadMore: () {
            if (currentPage < totalPages &&
                !isLoadingProducts &&
                categories.isNotEmpty) {
              fetchProducts(
                categories[selectedCategoryIndex].title,
                page: currentPage + 1,
                resetProducts: false,
              );
            }
          },
        );
      case 1:
        return ForgotPasswordScreen();
      case 2:
        return const FavoriteScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
