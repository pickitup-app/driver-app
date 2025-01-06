import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:pickitupdriver/screens/login_page.dart'; // Import halaman login
import 'package:pickitupdriver/screens/home.dart';

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
      initialRoute: '/', // Route awal

      /*
        Routes: Inisialisasi semua yang berkaitan dengan
      */
      routes: {
        '/': (context) => Home(), // Halaman login sebagai default
      },
    );
  }
}
