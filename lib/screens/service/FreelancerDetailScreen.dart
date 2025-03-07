import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancerDetailScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const FreelancerDetailScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<FreelancerDetailScreen> createState() => _FreelancerDetailScreenState();
}

class _FreelancerDetailScreenState extends State<FreelancerDetailScreen> {
  void _callFreelancer(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://gravatar.com/avatar/${widget.email}'),
              ),
            ),
            const SizedBox(height: 16),
            Text("Name: ${widget.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Email: ${widget.email}", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Phone: ${widget.phone}",
                style: TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _callFreelancer(widget.phone),
                icon: Icon(Icons.phone),
                label: Text("Call Now"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
