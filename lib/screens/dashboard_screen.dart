import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:vtry/controllers/profile_controller.dart';
import 'package:vtry/models/category_model.dart' as category_model;
import 'package:vtry/models/product_model.dart';
import 'package:vtry/screens/product_details_screen.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/GlassContainer.dart';
import 'package:vtry/widgets/ProductItem.dart';
import 'package:vtry/widgets/shimmer_widgets.dart';

import 'package:vtry/widgets/category_container.dart';
import 'package:vtry/widgets/clothing_filter_bottom_sheet.dart';
import 'package:vtry/widgets/glass_text_field.dart';

class DashboardScreen extends StatefulWidget {
  final List<category_model.Category> categories;
  final bool isLoadingCategories;
  final String? categoryErrorMessage;
  final int selectedCategoryIndex;
  final Function(int)? onCategorySelected;

  // Products data
  final List<Product> products;
  final bool isLoadingProducts;
  final String? productErrorMessage;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onLoadMore;

  const DashboardScreen({
    super.key,
    this.categories = const [],
    this.isLoadingCategories = true,
    this.categoryErrorMessage,
    this.selectedCategoryIndex = 0,
    this.onCategorySelected,
    this.products = const [],
    this.isLoadingProducts = false,
    this.productErrorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onLoadMore,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController searchController = TextEditingController();
  ProfileController? _profileController;
  List<bool> isFavorite = List.generate(10, (_) => false);
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set selectedIndex from props
    selectedIndex = widget.selectedCategoryIndex;

    // Try to find ProfileController safely
    try {
      _profileController = Get.find<ProfileController>();
    } catch (e) {
      if (kDebugMode) {
        print('ProfileController not found in GetX container: $e');
      }
      // We'll handle the null case in the UI
    }
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.isLoadingProducts && widget.products.isEmpty
            ? const ShimmerProductGrid() // Using shimmer effect for initial loading
            : widget.productErrorMessage != null && widget.products.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 300.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading products',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.productErrorMessage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Check if user has reached end of the list
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      widget.onLoadMore != null &&
                      !widget.isLoadingProducts &&
                      widget.currentPage < widget.totalPages) {
                    // Call onLoadMore to fetch next page
                    widget.onLoadMore!();
                  }
                  return false;
                },
                child: MasonryGridView.builder(
                  padding: EdgeInsets.only(
                    top: 260.h,
                    left: 10.w,
                    right: 10.w,
                    bottom: 100.h,
                  ),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount:
                      widget.products.length +
                      (widget.isLoadingProducts && widget.products.isNotEmpty
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end when loading more items
                    if (index == widget.products.length &&
                        widget.isLoadingProducts) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(
                            color: AppColors.darkPrimary,
                          ),
                        ),
                      );
                    }

                    final product = widget.products[index];
                    final imageUrl = product.images.isNotEmpty
                        ? product.images[0]
                        : 'https://picsum.photos/400/200?random=$index';

                    // Make sure isFavorite list is large enough
                    if (index >= isFavorite.length) {
                      isFavorite.addAll(
                        List.generate(
                          index - isFavorite.length + 10,
                          (_) => false,
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: ProductItem(
                        imageUrl: imageUrl,
                        name: product.title,
                        category: product.category,
                        price: 'Rs ${product.price.toStringAsFixed(2)}',
                        rating:
                            4.5, // Default rating or you could add rating to your model
                        isFavorite: isFavorite[index],
                        onFavoriteTap: () {
                          setState(() {
                            isFavorite[index] = !isFavorite[index];
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GlassContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.9),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Display user name from ProfileController if available
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
                                  'User',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                      _profileController != null
                          ? Obx(() {
                              final userData =
                                  _profileController?.getUserInfo() ?? {};
                              final userName = userData['name'] ?? 'User';
                              final firstLetter = userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : 'U';

                              return Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  color: AppColors.darkPrimary.withOpacity(0.8),
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
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            })
                          : Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2,
                                ),
                                color: AppColors.darkPrimary.withOpacity(0.8),
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
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: GlassTextField(
                          controller: searchController,
                          hintText: "Search clothes . . . ",
                          prefixIcon: Icons.search,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          ClothingFilterBottomSheet.show(
                            context,
                            onApply: (selectedFilters) {
                              // selectedFilters is a List<String> of the selected checkboxes
                              print("Selected filters: $selectedFilters");
                              // TODO: filter your GridView here based on selectedFilters
                            },
                          );
                        },

                        child: Container(
                          height: 48.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: AppColors.darkPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/filter.svg",
                              colorFilter: const ColorFilter.mode(
                                AppColors.darkWhite,
                                BlendMode.srcIn,
                              ),
                              height: 23.h,
                              width: 23.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  widget.isLoadingCategories
                      ? const ShimmerCategoriesList() // Show shimmer while loading
                      : widget.categoryErrorMessage != null
                      ? Center(
                          child: Text(
                            'Error loading categories',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 44.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.categories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10.w),
                            itemBuilder: (context, index) {
                              final category_model.Category category =
                                  widget.categories[index];
                              // Format the category title: remove 'men' and 'collection', then capitalize first letter
                              String displayTitle = category.title
                                  .replaceAll('men ', '') // Remove 'men '
                                  .replaceAll(
                                    ' collection',
                                    '',
                                  ) // Remove ' collection'
                                  .trim(); // Trim any extra spaces

                              // Capitalize first letter
                              List<String> words = displayTitle.split(' ');
                              for (int i = 0; i < words.length; i++) {
                                if (words[i].isNotEmpty) {
                                  words[i] =
                                      words[i][0].toUpperCase() +
                                      words[i].substring(1);
                                }
                              }
                              displayTitle = words.join(' ');

                              return CategoryContainer(
                                title: displayTitle,
                                selected: index == selectedIndex,
                                onTap: () {
                                  // Print original category name when tapped
                                  print('Selected Category: ${category.title}');
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  // Call the parent callback if provided
                                  if (widget.onCategorySelected != null) {
                                    widget.onCategorySelected!(index);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
