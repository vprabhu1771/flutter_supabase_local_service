import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/Booking.dart';
import '../../../widgets/CustomDrawer.dart';
import 'FreelancerDetailScreen.dart';

class MyBookingScreen extends StatefulWidget {
  final String title;

  const MyBookingScreen({super.key, required this.title});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Booking>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = _fetchBookings();
  }

  Future<List<Booking>> _fetchBookings() async {
    try {
      final response = await supabase
          .from('service_bookings')
          .select('''
            id,
            booking_date,
            status,
            customer:users(*),
            freelancer:freelancer(*, users(*)),
            sub_category:sub_categories(*)
          ''')
          .order('booking_date', ascending: false);

      print("Fetched Bookings: $response"); // Debug print

      if (response is List) {
        return response.map((data) => Booking.fromJson(data)).toList();
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
    return [];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(parentContext: context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Booking>>(
          future: _futureBookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No bookings found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            final bookings = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final providerName = booking.freelancer.user.name;
                final providerEmail = booking.freelancer.user.email;
                final providerPhone = booking.freelancer.user.phone;
                final status = booking.status;
                final bookingDate = booking.formattedBookingDate;
                final avatarUrl = booking.customer?.image_path ??
                    'https://gravatar.com/avatar/${Uri.encodeComponent(booking.customer?.email ?? '')}';

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FreelancerDetailScreen(
                          name: providerName,
                          email: providerEmail,
                          phone: providerPhone,
                          imagePath: avatarUrl,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: NetworkImage(avatarUrl),
                        onBackgroundImageError: (_, __) => null,
                      ),
                      title: Text(
                        "$providerName (${booking.subCategory.name})",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('Date: $bookingDate', style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 4),
                          Chip(
                            label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white)),
                            backgroundColor: _getStatusColor(status),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
