import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/freelancer/FreelancerDashboard.dart';
import 'package:flutter_supabase_local_service/freelancer/YourBookingScreen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



import '../screens/HomePage.dart';
import '../screens/HomeScreen.dart';
import '../screens/SettingScreen.dart';
import '../screens/auth/LoginScreen.dart';
import '../screens/auth/ProfileScreen.dart';
import '../screens/auth/RegisterScreen.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext parentContext;

  CustomDrawer({required this.parentContext});

  final supabase = Supabase.instance.client;
  final storage = FlutterSecureStorage();

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await storage.delete(key: 'session');
    Navigator.pushReplacement(
      parentContext,
      MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home')),
    );
  }

  Future<String?> getUserRole() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabase
        .from('user_roles')
        .select('roles(id, name)')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? response['roles']['name'] as String? : null;
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Drawer(
      child: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          final role = snapshot.data;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.userMetadata?['name'] ?? "Guest"),
                accountEmail: Text(user?.email ?? "No Email"),
                currentAccountPicture: CircleAvatar(child: Icon(Icons.person, size: 40)),
              ),

              // Common for all logged-in users
              if (user != null) ...[
                // ListTile(
                //   leading: Icon(Icons.home),
                //   title: Text('Home'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home')));
                //   },
                // ),
              ],

              // Role-based rendering
              if (role == 'admin') ...[
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Customers Management'),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     parentContext,
                    //     MaterialPageRoute(builder: (context) => CustomerManagementScreen(title: 'Customers Management'))
                    // );
                  },
                ),

              ] else if (role == 'delivery') ...[

                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (context) => FreelancerDashboard(title: 'Freelaner Dashboard'),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Your Booking'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (context) => YourBookingScreen(title: 'Your Bookings', filter: 'all',),
                      ),
                    );
                  },
                ),

              ] else if (role == 'customer') ...[

                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Bookings'),
                  onTap: () {
                    // Navigate to HomePage first and pass the selected index for MyBookings
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(initialTabIndex: 1), // Open "Bookings" tab
                      ),
                          (route) => false, // Removes all previous routes from the stack
                    );
                  },
                ),

            ],


              // Logout option for authenticated users
              if (user != null) ...[
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(title: 'Profile'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (context) => SettingScreen(title: 'Settings'),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: signOut,
                ),
              ] else ...[
                // Guest users: Login & Register
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pushReplacement(
                      parentContext,
                      MaterialPageRoute(builder: (context) => LoginScreen(title: 'Login')),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.app_registration),
                  title: Text('Register'),
                  onTap: () {
                    Navigator.pushReplacement(
                      parentContext,
                      MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}