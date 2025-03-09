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

      if (response.isNotEmpty) {
        final subCategory = response[0]['sub_category'];
        subCategoryName = subCategory['name'];
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
      appBar: AppBar(
        title: Text(widget.subCategory.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No freelancers available", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index].user;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(
                  user?.image_path ?? 'https://gravatar.com/avatar/${user!.email}',
                ),
              ),
              title: Text(
                "${user.name} (Freelancer)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Tap to book this freelancer"),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookServiceScreen(
                      freelanceId: user.id,
                      subcategory: subCategoryName,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}