class Category {
  final String title;

  Category({required this.title});

  factory Category.fromString(String categoryTitle) {
    return Category(title: categoryTitle);
  }
}

class CategoryResponse {
  final List<Category> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJsonList(List<dynamic> json) {
    return CategoryResponse(
      categories: json
          .map((cat) => Category.fromString(cat.toString()))
          .toList(),
    );
  }
}
