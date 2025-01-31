import 'package:flutter/material.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Column(
        children: [
          // Header Profile
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Color(0xFF0C3A2D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF6D9773)),
                ),
                SizedBox(height: 10),
                Text(
                  'Driver 123',
                  style: GoogleFonts.balooBhai2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.greenAccent),
                    SizedBox(width: 5),
                    Text('Online',
                        style: GoogleFonts.balooBhai2(color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          // Statistics Section
          StatsCard(
              title: 'Total Days Work:',
              value: '450 Days',
              width: MediaQuery.of(context).size.width * 0.9),
          StatsCard(
              title: 'Total Customer:',
              value: '223 People',
              width: MediaQuery.of(context).size.width * 0.9),
          StatsCard(
              title: 'Total Trash Collected:',
              value: '590 Trash',
              width: MediaQuery.of(context).size.width * 0.9),
          SizedBox(height: 20),
          // Monthly Pickups Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '“ You\'ve completed 40 pick ups this month. Keep up the great work!”',
              textAlign: TextAlign.center,
              style: GoogleFonts.balooBhai2(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
          ),
          Spacer(),
          // Bottom Navigation Bar
          custom_nav.BottomNavBar(), // Memanggil navbar dari file terpisah
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const StatsCard(
      {required this.title, required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        width: width,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFF0C3A2D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.balooBhai2(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.balooBhai2(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
