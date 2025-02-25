import 'package:flutter/material.dart';

class CustomLocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String address;

  const CustomLocationAppBar({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        address,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis, // Prevents text overflow
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
