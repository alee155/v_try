import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/models/product_model.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/thumbnail_list.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitleInAppBar = false;

  int _selectedImageIndex = 0;
  int _selectedSizeIndex = -1;
  int _selectedColorIndex = -1;

  // threshold at which the title appears (adjust as needed)
  static const double _titleShowOffset = 140.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow =
        _scrollController.hasClients &&
        _scrollController.offset > _titleShowOffset;

    if (shouldShow != _showTitleInAppBar) {
      setState(() {
        _showTitleInAppBar = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Color _getColorFromName(String colorName) {
    final Map<String, Color> colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'black': Colors.black,
      'white': Colors.white,
      'grey': Colors.grey,
      'purple': Colors.purple,
      'orange': Colors.orange,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'navy': const Color(0xFF000080),
      'navy blue': const Color(0xFF000080),
      'metal': Colors.blueGrey,
    };

    final key = colorName.toLowerCase();
    if (colorMap.containsKey(key)) return colorMap[key]!;

    // fallback deterministic color from name
    int hash = 0;
    for (var i = 0; i < key.length; i++) {
      hash = key.codeUnitAt(i) + ((hash << 5) - hash);
    }
    hash = hash.abs();
    final r = hash & 0xFF;
    final g = (hash >> 8) & 0xFF;
    final b = (hash >> 16) & 0xFF;
    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    final topImageHeight = 650.h;
    final iconSize = 18.sp;

    return Scaffold(
      backgroundColor: AppColors.darkWhite,
      body: NestedScrollView(
        // attach controller to the inner scrollable content
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              elevation: _showTitleInAppBar ? 1 : 0,
              backgroundColor: _showTitleInAppBar
                  ? Colors.white
                  : Colors.transparent,
              automaticallyImplyLeading: false,
              expandedHeight: topImageHeight,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: iconSize,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              title: _showTitleInAppBar
                  ? Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    )
                  : null,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  // We can use constraints to do extra effects if needed
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Main image container with rounded bottom corners
                        Container(
                          height: topImageHeight,
                          decoration: BoxDecoration(
                            color: AppColors.darkPrimary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r),
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: widget.product.images.isNotEmpty
                              ? Image.network(
                                  widget.product.images[_selectedImageIndex],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, err, stack) => Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50.sp,
                                    color: Colors.white,
                                  ),
                                ),
                        ),

                        // Thumbnails at top-right (adjust position if needed)
                        Positioned(
                          top: 40.h,
                          right: 10.w,
                          child: ThumbnailList(
                            images: widget.product.images,
                            selectedIndex: _selectedImageIndex,
                            onTap: (i) {
                              setState(() => _selectedImageIndex = i);
                            },
                          ),
                        ),

                        // small favorite icon bottom-left
                        Positioned(
                          bottom: 20.h,
                          left: 12.w,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 34.h,
                              width: 34.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ];
        },
        // Body: attach the same controller implicitly through NestedScrollView
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (big)
              Text(
                widget.product.title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6.h),
              // Price
              Text(
                "Rs ${widget.product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              // Description
              Text(
                "Description",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.h),
              Text(
                widget.product.description.replaceAll(RegExp(r'\s*\n\s*'), ' '),
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),

              // Colors
              if (widget.product.colors.isNotEmpty) ...[
                Text(
                  "Colors",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.colors.length,
                    itemBuilder: (context, index) {
                      final color = _getColorFromName(
                        widget.product.colors[index],
                      );
                      final selected = _selectedColorIndex == index;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedColorIndex = index),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // Sizes
              if (widget.product.sizes.isNotEmpty) ...[
                Text(
                  "Sizes",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: List.generate(widget.product.sizes.length, (index) {
                    final selected = _selectedSizeIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSizeIndex = index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.darkPrimary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: selected
                                ? AppColors.darkPrimary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          widget.product.sizes[index],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),
              ],

              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
