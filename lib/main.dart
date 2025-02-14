import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:pickitupdriver/screens/login_page.dart'; // Import halaman login
import 'package:pickitupdriver/screens/home.dart';
import 'package:pickitupdriver/screens/profile_page.dart';
import 'package:pickitupdriver/screens/report_page.dart';
import 'package:pickitupdriver/screens/schedule_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.balooBhai2TextTheme(),
      ),
      initialRoute: '/login', // Route awal
      /*
        Routes: Inisialisasi semua yang berkaitan dengan
      */
      routes: {
        // disable login to make it easier
        '/login': (context) => LoginPage(), // Halaman login
        '/': (context) => Home(), // Halaman login sebagai default
        '/profile': (context) => ProfileScreen(),
        '/report': (context) => ReportPage(),
        '/schedule': (context) => ScheduleScreen(),
      },
    );
  }
}
