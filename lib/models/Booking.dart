import 'package:intl/intl.dart';

import 'Customer.dart';
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