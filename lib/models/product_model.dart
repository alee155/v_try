class Product {
  final String id;
  final String url;
  final String category;
  final List<String> colors;
  final String description;
  final double price;
  final List<String> sizes;
  final String title;
  final List<String> images;
  final String gender;

  Product({
    required this.id,
    required this.url,
    required this.category,
    required this.colors,
    required this.description,
    required this.price,
    required this.sizes,
    required this.title,
    required this.images,
    required this.gender,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle colors list
    List<String> colorsList = [];
    if (json['colors'] != null) {
      colorsList = List<String>.from(
        json['colors'].map((color) => color.toString()),
      );
    }

    // Handle sizes list
    List<String> sizesList = [];
    if (json['sizes'] != null) {
      sizesList = List<String>.from(
        json['sizes'].map((size) => size.toString()),
      );
    }

    // Handle images list
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(
        json['images'].map((image) => image.toString()),
      );
    }

    // Parse price from string to double
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    return Product(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      category: json['category'] ?? '',
      colors: colorsList,
      description: json['description'] ?? '',
      price: parsedPrice,
      sizes: sizesList,
      title: json['title'] ?? '',
      images: imagesList,
      gender: json['gender'] ?? '',
    );
  }
}

class ProductResponse {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<Product> products;

  ProductResponse({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    List<Product> productsList = [];
    if (json['products'] != null) {
      productsList = List<Product>.from(
        json['products'].map((product) => Product.fromJson(product)),
      );
    }

    return ProductResponse(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      products: productsList,
    );
  }
}
