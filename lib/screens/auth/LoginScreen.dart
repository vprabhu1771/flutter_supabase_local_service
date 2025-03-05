import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../admin/AdminDashboard.dart';
import '../../freelancer/FreelancerDashboard.dart';
import '../HomePage.dart';
import 'RegisterScreen.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  final String title;

  const LoginScreen({super.key, required this.title});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Map<String, String> _roleMap = {
    'Customer': 'customer',
    'Freelancer': 'delivery',
    'Admin': 'admin',
  };

  String _selectedRole = 'admin'; // Default value stored

  final storage = FlutterSecureStorage(); // Secure storage instance
  bool _isPasswordVisible = false; // Track password visibility
  String? userId;

  @override
  void initState() {
    super.initState();
    emailController.text = "admin@gmail.com";
    passwordController.text = "admin@123";
  }

  Future<void> fetchUserRole(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_roles')
          .select('roles(id, name)')
          .eq('user_id', userId)
          .maybeSingle(); // Avoids crash if no rows are found

      if (response != null && response['roles'] != null) {
        final role = response['roles']['name'];
        navigateBasedOnRole(role);
      } else {
        print("No role found for user: $userId");
      }
    } catch (e) {
      print("Error fetching role: $e");
    }
  }

  void navigateBasedOnRole(String role) {
    if (role == 'admin') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AdminDashboard(title: "Admin Dashboard")));
    } else if (role == 'customer') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } else if (role == 'delivery') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => FreelancerDashboard(title: "Freelancer Dashboard")));
    }
  }

  Future<void> signIn() async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.session != null) {
        // Save session data securely
        await storage.write(key: 'session', value: response.session!.accessToken);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );

        setState(() {
          userId = supabase.auth.currentUser?.id;
        });

        if (userId != null) {
          fetchUserRole(userId!);
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo at the Top
            Image.asset(
              'assets/splash_logo.jpg', // Make sure to add your logo in assets folder
              height: 100,
            ),
            SizedBox(height: 20),

            Text(
              "Login",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 20),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roleMap.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.value, // Pass the actual value
                  child: Text(entry.key), // Display user-friendly name
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Select Role",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });

                // Set email & password based on role selection
                if (_selectedRole == 'customer') {
                  emailController.text = "mani_maran@gmail.com";
                  passwordController.text = "admin@123";
                } else if (_selectedRole == 'delivery') {
                  emailController.text = "prabhu@gmail.com";
                  passwordController.text = "admin@123";
                } else if (_selectedRole == 'admin') {
                  emailController.text = "admin@gmail.com";
                  passwordController.text = "admin@123";
                }
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: signIn,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(title: 'Register'),
                  ),
                );
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
