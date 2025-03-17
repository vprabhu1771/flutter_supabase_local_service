class SubCategory {
  final int id;
  final String name;
  final String createdAt;
  final String image_path;
  final int categoryId;

  SubCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.image_path,
    required this.categoryId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      image_path: json['image_path'],
      categoryId: json['category_id'],
    );
  }
}