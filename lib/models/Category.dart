class Category {

  int id;
  String name;
  String image_path;

  Category({
    required this.id,
    required this.name,
    required this.image_path,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name =json['name'],
        image_path=json['image_path'];
}