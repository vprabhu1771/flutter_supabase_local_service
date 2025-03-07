import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Booking.dart';
import '../widgets/CustomDrawer.dart';

class YourBookingScreen extends StatefulWidget {
  final String title;
  final String filter;

  const YourBookingScreen({super.key, required this.title, required this.filter});

  @override
  State<YourBookingScreen> createState() => _YourBookingScreenState();
}

class _YourBookingScreenState extends State<YourBookingScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? userId;
  late String selectedFilter;
  late Future<List<Booking>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    userId = supabase.auth.currentUser?.id;
    selectedFilter = widget.filter;
    _fetchBookings();
  }

  void _fetchBookings() {
    setState(() {
      bookingsFuture = selectedFilter == 'all'
          ? _fetchAllBookings()
          : _fetchBookingsByStatus(status: selectedFilter);
    });
  }

  Future<List<Booking>> _fetchAllBookings() async {
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

    if (response is List) {
      return response.map((data) => Booking.fromJson(data)).toList();
    }
    return [];
  }

  Future<List<Booking>> _fetchBookingsByStatus({required String status}) async {
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
        .eq('status', status)
        .order('booking_date', ascending: false);

    if (response is List) {
      return response.map((data) => Booking.fromJson(data)).toList();
    }
    return [];
  }

  Future<void> _updateBookingStatus(int bookingId, String newStatus) async {
    await supabase.from('service_bookings').update({'status': newStatus}).eq('id', bookingId);
    _fetchBookings();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              icon: Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black),
              underline: SizedBox(),
              items: [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'canceled', child: Text('Canceled')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                  _fetchBookings();
                });
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(parentContext: context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Booking>>(
          future: bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No bookings found.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
            }

            final bookings = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final providerName = booking.freelancer.user.name;
                final providerEmail = booking.freelancer.user.email;
                final bookingDate = booking.bookingDate;
                final status = booking.status;

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadowColor: Colors.black54,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://gravatar.com/avatar/$providerEmail'),
                      radius: 30,
                    ),
                    title: Text(providerName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Date: $bookingDate', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 8),
                        Chip(
                          label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white)),
                          backgroundColor: _getStatusColor(status),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (newStatus) async {
                        await _updateBookingStatus(booking.id, newStatus);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'confirmed', child: Text('Confirm')),
                        PopupMenuItem(value: 'pending', child: Text('Pending')),
                        PopupMenuItem(value: 'canceled', child: Text('Cancel')),
                      ],
                      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
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
