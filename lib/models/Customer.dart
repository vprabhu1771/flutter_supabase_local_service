class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image_path;
  final String createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image_path,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image_path: json['image_path'],
      createdAt: json['created_at'],
    );
  }
}