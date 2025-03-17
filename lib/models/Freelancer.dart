import 'User.dart';

class Freelancer {
  final int id;
  final User user;
  final String user_id;
  final int subCategoryId;

  Freelancer({
    required this.id,
    required this.user,
    required this.user_id,
    required this.subCategoryId,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      id: json['id'],
      user: User.fromJson(json['users']),
      user_id: json['user_id'],
      subCategoryId: json['sub_category_id'],
    );
  }
}