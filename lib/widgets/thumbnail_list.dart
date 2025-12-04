// lib/widgets/thumbnail_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThumbnailList extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onTap;

  const ThumbnailList({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700.h,
      width: 60.w,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: 70.h,
                width: 70.w,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: selectedIndex == index
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.r),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2.0,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
