import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancerDetailScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String? imagePath;

  const FreelancerDetailScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
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
      appBar: AppBar(
        title: Text("${widget.name} (Freelancer)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  widget.imagePath ?? 'https://gravatar.com/avatar/${widget.email}',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Info Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person, "Name", widget.name),
                    _buildInfoRow(Icons.email, "Email", widget.email),
                    _buildInfoRow(Icons.phone, "Phone", widget.phone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Call Button
            ElevatedButton.icon(
              onPressed: () => _callFreelancer(widget.phone),
              icon: Icon(Icons.phone, color: Colors.white),
              label: Text("Call Now"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget for Info Rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
