class SubCategory {

  int id;
  String name;
  String image_path;

  SubCategory({
    required this.id,
    required this.name,
    required this.image_path,
  });

  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name =json['name'],
        image_path=json['image_path'];
}