import 'User.dart';

class UserSubCategory {
  final String user_id;
  final User user;

  UserSubCategory({
    required this.user_id,
    required this.user
  });


  factory UserSubCategory.fromJson(Map<String, dynamic> json) {
    return UserSubCategory(
      user_id: json['user_id'],
      user: User.fromJson(json['users']),
    );
  }
}