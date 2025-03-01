import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/screens/CategoryScreen.dart';
import 'package:flutter_supabase_local_service/screens/HomeScreen.dart';
import 'package:geolocator/geolocator.dart';

import '../services/LocationService.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/CustomLocationAppBar.dart';
import 'BookingScreen.dart';
import '../screens/auth/ProfileScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // Tabs and corresponding titles
  final List<Widget> _tabs = [
    CategoryScreen(title: "Home"),
    BookingScreen(title: "Bookings"),
    ProfileScreen(title: 'Profile'),
  ];

  final List<String> _tabTitles = [
    "Home",
    "Bookings",
    "Profile",
    // "Updates",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  final LocationService _locationService = LocationService();
  String _location = "Press the button to get location";
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _location = "Fetching location...";
    });

    try {
      Position? position = await _locationService.getCurrentPosition();
      if (position != null) {
        String address = await _locationService.getAddressFromPosition(position);
        setState(() => _location = address);
      }
    } catch (e) {
      setState(() => _location = "Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(parentContext: context,),
      appBar: CustomLocationAppBar(address: _location),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}