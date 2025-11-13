import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vtry/utils/app_colors.dart';

import 'package:vtry/widgets/category_container.dart';
import 'package:vtry/widgets/clothing_filter_bottom_sheet.dart';
import 'package:vtry/widgets/glass_text_field.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.count(
          padding: EdgeInsets.only(
            top: 260.h,
            left: 10.w,
            right: 10.w,
            bottom: 20.h,
          ),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            for (final imageUrl in [
              'https://picsum.photos/400/200?random=1',
              'https://picsum.photos/400/200?random=2',
              'https://picsum.photos/400/200?random=3',
              'https://picsum.photos/400/200?random=4',
              'https://picsum.photos/400/200?random=5',
              'https://picsum.photos/400/200?random=6',
              'https://picsum.photos/400/200?random=7',
              'https://picsum.photos/400/200?random=8',
              'https://picsum.photos/400/200?random=9',
              'https://picsum.photos/400/200?random=10',
              'https://picsum.photos/400/200?random=11',
            ])
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 260.h,
                width: double.infinity,
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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
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
                    color: Colors.white.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                            Text(
                              "Sarah Johnson",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://randomuser.me/api/portraits/women/44.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
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
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/filter.svg",
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
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
                    SizedBox(
                      height: 44.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,

                        children: const [
                          CategoryContainer(
                            title: "All Items",
                            iconPath: "assets/icons/all.svg",
                          ),
                          SizedBox(width: 10),
                          CategoryContainer(
                            title: "Shirt",
                            iconPath: "assets/icons/shirt.svg",
                          ),
                          SizedBox(width: 10),
                          CategoryContainer(
                            title: "Dress",
                            iconPath: "assets/icons/dress.svg",
                          ),
                          SizedBox(width: 10),
                          CategoryContainer(
                            title: "Trouser",
                            iconPath: "assets/icons/trouser.svg",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
