import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/models/UserSubCategory.dart';
import 'package:flutter_supabase_local_service/screens/BookingScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/SubCategory.dart';
import 'BookServiceScreen.dart';

class FreelancerScreen extends StatefulWidget {
  final SubCategory subCategory;

  const FreelancerScreen({super.key, required this.subCategory});

  @override
  State<FreelancerScreen> createState() => _FreelancerScreenState();
}

class _FreelancerScreenState extends State<FreelancerScreen> {
  final supabase = Supabase.instance.client;

  List<UserSubCategory> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await supabase
          .from('freelancer')
          .select('user_id, users(*)')
          .eq('sub_category_id', widget.subCategory.id);

      print('Raw data from Supabase: $response'); // Debugging output

      List<UserSubCategory> fetchedUsers = response
          .map<UserSubCategory>((row) => UserSubCategory.fromJson(row))
          .toList();

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subCategory.name)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No users available"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index].user; // Assuming UserSubCategory has a `user` field
          return ListTile(
            leading: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://gravatar.com/avatar/${user!.email}'), // Replace with the user's image URL
            ),
            title: Text(user.name),

            onTap: () {

              Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookServiceScreen(freelanceId: user.id,),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
