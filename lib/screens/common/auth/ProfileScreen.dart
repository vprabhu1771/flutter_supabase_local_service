import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../customer/HomeScreen.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final storage = FlutterSecureStorage(); // Secure storage instance

  final user = supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await storage.delete(key: 'session');

    // Navigate to login screen and remove all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // builder: (context) => LoginScreen(title: 'Login'),
        builder: (context) => HomeScreen(title: 'Home'),
      ),
    );
  }

  String _location = "Press the button to get location";
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _location = "Fetching location...";
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = "Location services are disabled.";
          _isLoading = false;
        });
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = "Location permissions are denied.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location =
          "Location permissions are permanently denied. Please enable them in settings.";
          _isLoading = false;
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      await _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _location = "Error: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _location =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _location = "No address available for this location.";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Failed to get address: $e";
      });
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image View
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://gravatar.com/avatar/${user!.email}'), // Replace with the user's image URL
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),

              // Profile Details List
              ListTile(
                leading: Icon(Icons.person),
                title: Text(user?.userMetadata?['name']), // Replace with dynamic user name
                trailing: Icon(Icons.edit),
                onTap: () {
                  // Handle the edit profile action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.email),
                title: Text(user!.email ?? ""), // Replace with dynamic user name
                // trailing: Icon(Icons.edit),
                onTap: () {
                  // Handle the edit profile action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.phone),
                title: Text(user?.userMetadata?['phone']), // Replace with dynamic phone number
                onTap: () {
                  // Handle phone number action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.location_on),
                title: Text( user?.userMetadata?['address'] ?? 'Unkown'), // Replace with dynamic address
                onTap: () {
                  // Handle address action
                },
              ),
              const Divider(),

              // Logout Button (Red color)
              TextButton(
                onPressed: () {

                  signOut();

                  // Handle logout action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );

                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}