import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/utils/app_colors.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String category;
  final String price;
  final double rating;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const ProductItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = (rating % 2 == 0)
        ? 260.h
        : 190.h; // example variation

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // 🖼️ Product Image
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16).r),
              child: Image.network(
                imageUrl,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // ❤️ Favorite Icon (top-right)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  height: 32.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                category,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: TextStyle(fontSize: 13.sp, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
