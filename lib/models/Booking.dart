import 'package:intl/intl.dart';

import 'Freelancer.dart';
import 'SubCategory.dart';

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

  // ✅ Format the date properly
  String get formattedBookingDate {
    try {
      DateTime dateTime = DateTime.parse(bookingDate); // Parse date
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime); // Format date
    } catch (e) {
      return bookingDate; // Return original if parsing fails
    }
  }
}

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String image_path;
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

