import 'package:flutter/material.dart';
import '../widgets/CustomDrawer.dart';

class BookingScreen extends StatefulWidget {

  final String title;

  const BookingScreen({super.key, required this.title});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      // drawer: CustomDrawer(parentContext: context),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}