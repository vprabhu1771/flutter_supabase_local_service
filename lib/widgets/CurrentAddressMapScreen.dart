import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentAddressMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const CurrentAddressMapScreen({super.key, required this.latitude, required this.longitude});

  @override
  _CurrentAddressMapScreenState createState() => _CurrentAddressMapScreenState();
}

class _CurrentAddressMapScreenState extends State<CurrentAddressMapScreen> {
  late GoogleMapController _mapController;
  late LatLng _location;

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.latitude, widget.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _location,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("selected-location"),
            position: _location,
            infoWindow: InfoWindow(title: "Selected Location"),
          ),
        },
      ),
    );
  }
}
