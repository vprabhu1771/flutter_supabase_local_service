import 'package:flutter/material.dart';

import 'CurrentAddressMapScreen.dart';

class CustomLocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String address;

  final double latitude;
  final double longitude;

  const CustomLocationAppBar({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        child:  Text(
          address,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis, // Prevents text overflow
        ),
        onTap: () {
          print("abcd");

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrentAddressMapScreen(latitude: this.latitude, longitude: this.longitude,))
          );
        },
      ),
      centerTitle: true,        // Center the title properly
      titleSpacing: 0,          // Adjust title spacing to avoid overlap
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
