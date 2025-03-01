import 'package:flutter/material.dart';
import '../widgets/CustomDrawer.dart';

class FreelancerDashboard extends StatefulWidget {

  final String title;

  const FreelancerDashboard({super.key, required this.title});

  @override
  State<FreelancerDashboard> createState() => _FreelancerDashboardState();
}

class _FreelancerDashboardState extends State<FreelancerDashboard> {

  final int assignedDeliveries = 8;
  final double earnings = 1250.50;
  final int pendingOrders = 3;
  final int completedOrders = 5;

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
            _buildSummaryCard(
              icon: Icons.delivery_dining,
              title: 'Assigned Deliveries',
              value: '$assignedDeliveries',
              color: Colors.blueAccent,
            ),
            SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.attach_money,
              title: 'Earnings Today',
              value: '₹${earnings.toStringAsFixed(2)}',
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
            Text('Orders Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStatus(
                  label: 'Pending',
                  count: pendingOrders,
                  color: Colors.orange,
                  icon: Icons.pending_actions,
                ),
                _buildOrderStatus(
                  label: 'Completed',
                  count: completedOrders,
                  color: Colors.green,
                  icon: Icons.check_circle_outline,
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