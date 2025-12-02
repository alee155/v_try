import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/GlassContainer.dart';
import 'package:vtry/widgets/ProductItem.dart';
import 'package:vtry/widgets/category_container.dart';
import 'package:vtry/widgets/clothing_filter_bottom_sheet.dart';
import 'package:vtry/widgets/glass_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<bool> isFavorite = List.generate(10, (_) => false);
  int selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {"title": "All Items", "icon": "assets/icons/all.svg"},
    {"title": "Shirt", "icon": "assets/icons/shirt.svg"},
    {"title": "Dress", "icon": "assets/icons/dress.svg"},
    {"title": "Trouser", "icon": "assets/icons/trouser.svg"},
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //     SliverAppBar(
          //       expandedHeight: 200.h,
          //       pinned: true,
          //       backgroundColor: Colors.transparent,
          //       automaticallyImplyLeading: false,
          //       flexibleSpace: LayoutBuilder(
          //         builder: (context, constraints) {
          //           // Calculate if the appbar is collapsed
          //           bool isCollapsed =
          //               constraints.biggest.height <= kToolbarHeight + 40.h;

          //           return GlassContainer(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   SizedBox(height: 40.h),

          //                   // Only show full header when not collapsed
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             "Welcome back,",
          //                             style: TextStyle(
          //                               color: Colors.grey.withOpacity(0.9),
          //                               fontSize: 14.sp,
          //                               fontWeight: FontWeight.w500,
          //                             ),
          //                           ),
          //                           Text(
          //                             "user name",
          //                             style: TextStyle(
          //                               color: Colors.black,
          //                               fontSize: 19.sp,
          //                               fontWeight: FontWeight.bold,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       Container(
          //                         width: 56,
          //                         height: 56,
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           border: Border.all(
          //                             color: Colors.white.withOpacity(0.4),
          //                             width: 2,
          //                           ),
          //                           image: const DecorationImage(
          //                             image: NetworkImage(
          //                               'https://randomuser.me/api/portraits/women/44.jpg',
          //                             ),
          //                             fit: BoxFit.cover,
          //                           ),
          //                           boxShadow: [
          //                             BoxShadow(
          //                               color: Colors.black.withOpacity(0.2),
          //                               blurRadius: 8,
          //                               spreadRadius: 1,
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(height: 20.h),
          //                   if (!isCollapsed)
          //                     Row(
          //                       children: [
          //                         Expanded(
          //                           child: GlassTextField(
          //                             controller: searchController,
          //                             hintText: "Search clothes . . . ",
          //                             prefixIcon: Icons.search,
          //                           ),
          //                         ),
          //                         SizedBox(width: 10.w),
          //                         GestureDetector(
          //                           onTap: () {
          //                             ClothingFilterBottomSheet.show(
          //                               context,
          //                               onApply: (selectedFilters) {
          //                                 print(
          //                                   "Selected filters: $selectedFilters",
          //                                 );
          //                               },
          //                             );
          //                           },
          //                           child: Container(
          //                             height: 48.h,
          //                             width: 48.w,
          //                             decoration: BoxDecoration(
          //                               color: AppColors.primaryBlue,
          //                               borderRadius: BorderRadius.circular(12),
          //                             ),
          //                             child: Center(
          //                               child: SvgPicture.asset(
          //                                 "assets/icons/filter.svg",
          //                                 colorFilter: const ColorFilter.mode(
          //                                   AppColors.white,
          //                                   BlendMode.srcIn,
          //                                 ),
          //                                 height: 23.h,
          //                                 width: 23.w,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   SizedBox(height: 20.h),
          //                   SizedBox(
          //                     height: 44.h,
          //                     child: ListView.separated(
          //                       scrollDirection: Axis.horizontal,
          //                       itemCount: categories.length,
          //                       separatorBuilder: (context, index) =>
          //                           SizedBox(width: 10.w),
          //                       itemBuilder: (context, index) {
          //                         final category = categories[index];
          //                         return CategoryContainer(
          //                           title: category["title"]!,
          //                           iconPath: category["icon"]!,
          //                           selected: index == selectedIndex,
          //                           onTap: () {
          //                             setState(() {
          //                               selectedIndex = index;
          //                             });
          //                           },
          //                         );
          //                       },
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //     SliverPadding(
          //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          //       sliver: SliverMasonryGrid.count(
          //         crossAxisCount: 2,
          //         mainAxisSpacing: 16,
          //         crossAxisSpacing: 16,
          //         childCount: 10,
          //         itemBuilder: (context, index) {
          //           final imageUrl = 'https://picsum.photos/400/200?random=$index';
          //           final productName = 'Product ${index + 1}';
          //           final productPrice = '\$${(index + 1) * 20}';
          //           final productCategory = 'T-shirt';
          //           final productRating = 4.0 + index % 5;

          //           return ProductItem(
          //             imageUrl: imageUrl,
          //             name: productName,
          //             category: productCategory,
          //             price: productPrice,
          //             rating: productRating,
          //             isFavorite: isFavorite[index],
          //             onFavoriteTap: () {
          //               setState(() {
          //                 isFavorite[index] = !isFavorite[index];
          //               });
          //             },
          //           );
          //         },
          //       ),
          //     ),
        ],
      ),
    );
  }
}
