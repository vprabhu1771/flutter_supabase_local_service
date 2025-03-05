import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/Booking.dart';
import '../../widgets/CustomDrawer.dart';

class BookingScreen extends StatefulWidget {
  final String title;

  const BookingScreen({super.key, required this.title});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Booking>> _fetchBookings() async {
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

    if (response != null && response is List) {
      return response.map((data) => Booking.fromJson(data)).toList();
    }
    return [];
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
          future: _fetchBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('No bookings found.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
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
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      // backgroundColor: Colors.blue.shade100,
                      // child: Text(providerName[0].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),

                      backgroundImage: NetworkImage('https://gravatar.com/avatar/$providerEmail'), // Replace with the user's image URL
                    ),
                    title: Text(providerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Date: $bookingDate', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 4),
                        Chip(
                          label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white)),
                          backgroundColor: status == 'confirmed' ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                    trailing: Icon(
                      status == 'confirmed' ? Icons.check_circle : Icons.pending,
                      color: status == 'confirmed' ? Colors.green : Colors.orange,
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

