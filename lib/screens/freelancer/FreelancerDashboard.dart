import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/CustomDrawer.dart';
import 'FreelancerYourBookingScreen.dart';

final SupabaseClient supabase = Supabase.instance.client;

class FreelancerDashboard extends StatefulWidget {

  final String title;

  const FreelancerDashboard({super.key, required this.title});

  @override
  State<FreelancerDashboard> createState() => _FreelancerDashboardState();
}

class _FreelancerDashboardState extends State<FreelancerDashboard> {

  late String userId;
  final int assignedDeliveries = 8;
  late double earnings = 0;
  late int pendingBookings = 0;
  late int confirmedBookings = 0;
  late int canceledBookings = 0;


  @override
  void initState() {
    super.initState();

    setState(() {
      userId = supabase.auth.currentUser!.id; // Replace with actual logged-in user ID
    });

    fetchEarnings();

    fetchServiceBooking();
  }

  fetchEarnings() async {
    if (userId == null) return;

    try {
      final response = await supabase
          .from('service_bookings')
          .select('amount')
          .eq('freelancer_user_id', userId)
          .eq('status', 'confirmed');

      if (response != null && response.isNotEmpty) {
        double totalEarnings = response.fold(0.0, (sum, booking) => sum + (booking['amount'] ?? 0.0));

        setState(() {
          earnings = totalEarnings;
        });
      } else {
        setState(() {
          earnings = 0.0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
    }
  }

  fetchServiceBooking() async {
    if (userId == null) return; // Ensure userId is not null

    try {
      final response = await supabase
          .from('service_bookings')
          .select('id, status') // Fetch only required fields for performance
          .eq('freelancer_user_id', userId);

      // print(response.toString());

      if (response != null && response.isNotEmpty) {
        int pending = response.where((booking) => booking['status'] == 'pending').length;
        int confirmed = response.where((booking) => booking['status'] == 'confirmed').length;
        int canceled = response.where((booking) => booking['status'] == 'canceled').length;

        setState(() {
          pendingBookings = pending;
          confirmedBookings = confirmed;
          canceledBookings = canceled;
        });

        print(pending);
        print(confirmed);
        print(canceled);
      } else {
        setState(() {
          pendingBookings = 0;
          confirmedBookings = 0;
          canceledBookings = 0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(parentContext: context),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // _buildSummaryCard(
            //   icon: Icons.delivery_dining,
            //   title: 'Assigned Deliveries',
            //   value: '$assignedDeliveries',
            //   color: Colors.blueAccent,
            // ),
            SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.attach_money,
              title: 'Earnings Today',
              value: '₹ ${earnings.toStringAsFixed(2)}',
              color: Colors.green,
            ),
            SizedBox(height: 16),
            _buildOrdersOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  Widget _buildOrdersOverview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bookings Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FreelancerYourBookingScreen(title: 'Your Bookings', filter: 'pending'))
                    );
                  },
                  child: _buildOrderStatus(
                    label: 'Pending',
                    count: pendingBookings,
                    color: Colors.orange,
                    icon: Icons.pending_actions,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FreelancerYourBookingScreen(title: 'Your Bookings', filter: 'completed'))
                    );
                  },
                  child: _buildOrderStatus(
                    label: 'Completed',
                    count: confirmedBookings,
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FreelancerYourBookingScreen(title: 'Your Bookings', filter: 'canceled'))
                    );
                  },
                  child:_buildOrderStatus(
                    label: 'Canceled',
                    count: canceledBookings,
                    color: Colors.red,
                    icon: Icons.cancel_outlined, // More appropriate icon for cancellation
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}