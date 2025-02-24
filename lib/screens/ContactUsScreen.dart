import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactUsScreen extends StatefulWidget {

  final String title;

  const ContactUsScreen({super.key, required this.title});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  // Function to launch the phone app with a specified phone number
  Future<void> _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await launcher.canLaunch(url)) {
      await launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to launch WhatsApp with a specified phone number
  Future<void> _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await launcher.canLaunch(whatsappUrl)) {
      await launcher.launch(whatsappUrl);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  // Function to launch Instagram
  Future<void> _launchInstagram() async {
    const instagramUrl = 'https://www.instagram.com/im_ragul7/#';
    if (await launcher.canLaunch(instagramUrl)) {
      await launcher.launch(instagramUrl);
    } else {
      throw 'Could not launch Instagram';
    }
  }

  // Function to launch Gmail
  Future<void> _launchGmail(String email) async {
    final gmailUrl = 'mailto:$email';
    if (await launcher.canLaunch(gmailUrl)) {
      await launcher.launch(gmailUrl);
    } else {
      throw 'Could not launch Gmail';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Support Us',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            Text(
              'Your support message goes here.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchPhone('+918056373718'); // Replace with your desired phone number
                  },
                  child: Image.asset('assets/contact_us/call_icon.png', width: 32, height: 32),
                ),
                InkWell(
                  onTap: () {
                    _launchWhatsApp('+918056373718'); // Replace with your desired WhatsApp number
                  },
                  child: Image.asset('assets/contact_us/whatsapp_icon.png', width: 50, height: 50),
                ),
                // InkWell(
                //   onTap: () {
                //     _launchInstagram();
                //   },
                //   child: Image.asset('assets/contact_us/instagram_icon.png', width: 32, height: 32),
                // ),
                InkWell(
                  onTap: () {
                    _launchGmail('rahulmass7703@gmail.com'); // Replace with your desired Gmail address
                  },
                  child: Image.asset('assets/contact_us/gmail_icon.png', width: 50, height: 50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}