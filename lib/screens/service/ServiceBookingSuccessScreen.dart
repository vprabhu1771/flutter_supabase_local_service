import 'package:flutter/material.dart';

import '../HomePage.dart';
import 'MyBookingScreen.dart';

class ServiceBookingSuccessScreen extends StatelessWidget {
  final String title;
  final String serviceName;
  final String serviceProviderName;

  const ServiceBookingSuccessScreen({
    Key? key,
    required this.title,
    required this.serviceName,
    required this.serviceProviderName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'Booking Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'You have successfully booked $serviceName with $serviceProviderName.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  // Navigate to HomePage first and pass the selected index for MyBookings
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(initialTabIndex: 1), // Open "Bookings" tab
                    ),
                        (route) => false, // Removes all previous routes from the stack
                  );

                  // Add a small delay to allow HomePage to build before switching tab
                  // Future.delayed(Duration(milliseconds: 1000), () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MyBookingScreen(title: 'Bookings'),
                  //     ),
                  //   );
                  // });
                },
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}