class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String image_path;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image_path
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        image_path = json['image_path'];
}