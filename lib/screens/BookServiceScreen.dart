import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/screens/BookingScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);

class BookServiceScreen extends ConsumerWidget {

  final String freelanceId;

  final SupabaseClient supabase = Supabase.instance.client;

  BookServiceScreen({required this.freelanceId, Key? key}) : super(key: key);

  Future<void> _bookService(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedDateProvider);
    final selectedTimeSlot = ref.read(selectedTimeSlotProvider);

    if (selectedDate == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select date and time slot')));
      return;
    }

    final customerId = supabase.auth.currentUser!.id; // Replace with actual logged-in user ID
    final providerId = freelanceId; // Replace with selected provider ID
    final subCategoryId = 1; // Replace with the actual subcategory ID

    try {
      final response = await supabase.from('service_bookings').insert({
        'customer_id': customerId,
        'provider_id': providerId,
        'sub_category_id': subCategoryId,
        'booking_date': "${DateFormat('yyyy-MM-dd').format(selectedDate)} $selectedTimeSlot",
        'status': 'pending',
      });

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service booked successfully!')));

        Navigator.pop(context);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookingScreen(title: 'Bookings'),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking failed: ${response.error.message}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTimeSlot = ref.watch(selectedTimeSlotProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Book a Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  ref.read(selectedDateProvider.notifier).state = pickedDate;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                child: Text(selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(selectedDate)),
              ),
            ),
            SizedBox(height: 16),

            Text('Select Time Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedTimeSlot,
              isExpanded: true,
              hint: Text('Choose a time slot'),
              items: [
                DropdownMenuItem(value: '09:00 AM', child: Text('09:00 AM')),
                DropdownMenuItem(value: '10:00 AM', child: Text('10:00 AM')),
                DropdownMenuItem(value: '11:00 AM', child: Text('11:00 AM')),
                DropdownMenuItem(value: '12:00 PM', child: Text('12:00 PM')),
                DropdownMenuItem(value: '02:00 PM', child: Text('02:00 PM')),
                DropdownMenuItem(value: '03:00 PM', child: Text('03:00 PM')),
                DropdownMenuItem(value: '04:00 PM', child: Text('04:00 PM')),
                DropdownMenuItem(value: '05:00 PM', child: Text('05:00 PM')),
                DropdownMenuItem(value: '06:00 PM', child: Text('06:00 PM')),
              ],
              onChanged: (value) => ref.read(selectedTimeSlotProvider.notifier).state = value,
            ),
            SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () => _bookService(context, ref),
                child: Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
