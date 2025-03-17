import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ServiceBookingSuccessScreen.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

class BookServiceScreen extends ConsumerWidget {
  final String freelanceId;
  final String subcategory;
  final SupabaseClient supabase = Supabase.instance.client;

  BookServiceScreen({required this.freelanceId, required this.subcategory, Key? key})
      : super(key: key);

  Future<void> _bookService(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedDateProvider);
    final selectedTime = ref.read(selectedTimeProvider);

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final customerId = supabase.auth.currentUser!.id;
    final providerId = freelanceId;
    final subCategoryId = 1;

    try {
      final providerResponse = await supabase
          .from('freelancer')
          .select("*, freelancer:users(*)")
          .eq('user_id', freelanceId)
          .single();

      final user = providerResponse['freelancer'];
      final freelancerName = user['name'];

      String formattedDate =
          "${DateFormat('yyyy-MM-dd').format(selectedDate)} ${selectedTime.format(context)}";

      final response = await supabase.from('service_bookings').insert({
        'customer_id': customerId,
        'freelancer_id': providerResponse['id'],
        'freelancer_user_id': providerResponse['user_id'],
        'sub_category_id': subCategoryId,
        'booking_date': formattedDate,
        'status': 'pending',
      });

      if (response == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ServiceBookingSuccessScreen(
              title: 'Booking Success',
              serviceName: '',
              serviceProviderName: freelancerName,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${response.error.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Book a Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Name: $subcategory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                _buildDatePicker(context, ref, selectedDate),
                SizedBox(height: 16),
                _buildTimePicker(context, ref, selectedTime),
                SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: () => _bookService(context, ref),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Book Now', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, WidgetRef ref, DateTime? selectedDate) {
    return _buildPicker(
      context,
      title: 'Select Date',
      value: selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(selectedDate),
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
    );
  }

  Widget _buildTimePicker(BuildContext context, WidgetRef ref, TimeOfDay? selectedTime) {
    return _buildPicker(
      context,
      title: 'Select Time',
      value: selectedTime == null ? 'Select Time' : selectedTime.format(context),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          ref.read(selectedTimeProvider.notifier).state = pickedTime;
        }
      },
    );
  }

  Widget _buildPicker(BuildContext context, {required String title, required String value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
                Icon(Icons.calendar_today, color: Colors.blueAccent),
              ],
            ),
          ),
        ),
      ],
    );
  }
}