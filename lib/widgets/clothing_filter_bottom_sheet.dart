import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClothingFilterBottomSheet {
  static void show(
    BuildContext context, {
    required Function(Map<String, dynamic>) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // frosted effect
      builder: (context) {
        // Clothing type options
        List<Map<String, String>> clothingOptions = [
          {"title": "Shirt", "icon": "assets/icons/shirt.svg"},
          {"title": "Pant", "icon": "assets/icons/trouser.svg"},
          {"title": "Dress", "icon": "assets/icons/dress.svg"},
          {"title": "Trouser", "icon": "assets/icons/trouser.svg"},
        ];
        List<bool> clothingSelected = List.generate(
          clothingOptions.length,
          (_) => false,
        );

        // Size options
        List<String> sizes = ["XS", "S", "M", "L", "XL", "XXL"];
        List<bool> sizeSelected = List.generate(sizes.length, (_) => false);

        // Price range
        RangeValues priceRange = const RangeValues(0, 500);
        double minPrice = 0;
        double maxPrice = 500;

        return StatefulBuilder(
          builder: (context, setState) {
            void selectAllClothing() {
              setState(() {
                for (int i = 0; i < clothingSelected.length; i++)
                  clothingSelected[i] = true;
              });
            }

            void clearAllClothing() {
              setState(() {
                for (int i = 0; i < clothingSelected.length; i++)
                  clothingSelected[i] = false;
              });
            }

            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 550.h,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          height: 4.h,
                          width: 40.w,
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),

                      // Clothing filter title & buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter Clothes",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: selectAllClothing,
                                child: Text(
                                  "Select All",
                                  style: TextStyle(
                                    color: AppColors.darkPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: clearAllClothing,
                                child: Text(
                                  "Clear All",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // Clothing options chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(clothingOptions.length, (
                            index,
                          ) {
                            bool isSelected = clothingSelected[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  clothingSelected[index] =
                                      !clothingSelected[index];
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: EdgeInsets.only(right: 10.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.darkPrimary.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.darkPrimary
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      clothingOptions[index]["icon"]!,
                                      height: 20.h,
                                      width: 20.w,
                                      colorFilter: ColorFilter.mode(
                                        isSelected
                                            ? AppColors.darkPrimary
                                            : Colors.grey,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      clothingOptions[index]["title"]!,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.darkPrimary
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Sizes filter
                      Text(
                        "Sizes",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 10.w,
                        children: List.generate(sizes.length, (index) {
                          bool isSelected = sizeSelected[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                sizeSelected[index] = !sizeSelected[index];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.darkPrimary.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.darkPrimary
                                      : Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                sizes[index],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.darkPrimary
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 20.h),

                      // Price Range filter
                      Text(
                        "Price Range",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: minPrice,
                        max: maxPrice,
                        divisions: 10,
                        labels: RangeLabels(
                          "\$${priceRange.start.toInt()}",
                          "\$${priceRange.end.toInt()}",
                        ),
                        activeColor: AppColors.darkPrimary,
                        inactiveColor: Colors.grey[300],
                        onChanged: (RangeValues values) {
                          setState(() {
                            priceRange = values;
                          });
                        },
                      ),

                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {
                          List<String> appliedClothing = [];
                          List<String> appliedSizes = [];
                          for (int i = 0; i < clothingOptions.length; i++) {
                            if (clothingSelected[i])
                              appliedClothing.add(clothingOptions[i]["title"]!);
                          }
                          for (int i = 0; i < sizes.length; i++) {
                            if (sizeSelected[i]) appliedSizes.add(sizes[i]);
                          }

                          onApply({
                            "clothing": appliedClothing,
                            "sizes": appliedSizes,
                            "priceRange": priceRange,
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkPrimary,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
