import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/models/Freelancer.dart';
import 'package:flutter_supabase_local_service/screens/service/MyBookingScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/SubCategory.dart';
import './BookServiceScreen.dart';

class FreelancerScreen extends StatefulWidget {
  final SubCategory subCategory;

  const FreelancerScreen({super.key, required this.subCategory});

  @override
  State<FreelancerScreen> createState() => _FreelancerScreenState();
}

class _FreelancerScreenState extends State<FreelancerScreen> {
  final supabase = Supabase.instance.client;

  List<Freelancer> users = [];
  bool isLoading = true;

  late String subCategoryName;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await supabase
          .from('freelancer')
          .select('user_id, users(*), sub_category:sub_categories(*)')
          .eq('sub_category_id', widget.subCategory.id);

      print('Raw data from Supabase: $response'); // Debugging output

      // Access the first item if the response is a list
      if (response.isNotEmpty) {
        final subCategory = response[0]['sub_category']; // Access sub_category object
        subCategoryName = subCategory['name']; // Get the name field

        print('Sub-category Name: $subCategoryName');
      }

      List<Freelancer> fetchedUsers = response
          .map<Freelancer>((row) => Freelancer.fromJson(row))
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
                  builder: (context) => BookServiceScreen(freelanceId: user.id, subcategory: subCategoryName),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
