import 'User.dart';

class Freelancer {
  final String user_id;
  final User user;

  Freelancer({
    required this.user_id,
    required this.user
  });


  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      user_id: json['user_id'],
      user: User.fromJson(json['users']),
    );
  }
}