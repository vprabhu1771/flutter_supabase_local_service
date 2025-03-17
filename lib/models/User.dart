class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }
}

