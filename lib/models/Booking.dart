class Booking {
  final int id;
  final String bookingDate;
  final String status;
  final Customer customer;
  final Freelancer freelancer;
  final SubCategory subCategory;

  Booking({
    required this.id,
    required this.bookingDate,
    required this.status,
    required this.customer,
    required this.freelancer,
    required this.subCategory,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingDate: json['booking_date'],
      status: json['status'],
      customer: Customer.fromJson(json['customer']),
      freelancer: Freelancer.fromJson(json['freelancer']),
      subCategory: SubCategory.fromJson(json['sub_category']),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }
}

class Freelancer {
  final int id;
  final User user;
  final String userId;
  final int subCategoryId;

  Freelancer({
    required this.id,
    required this.user,
    required this.userId,
    required this.subCategoryId,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      id: json['id'],
      user: User.fromJson(json['users']),
      userId: json['user_id'],
      subCategoryId: json['sub_category_id'],
    );
  }
}

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

class SubCategory {
  final int id;
  final String name;
  final String createdAt;
  final String imagePath;
  final int categoryId;

  SubCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.imagePath,
    required this.categoryId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      imagePath: json['image_path'],
      categoryId: json['category_id'],
    );
  }
}