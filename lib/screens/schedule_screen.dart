import 'package:flutter/material.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background dengan pola
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1FCE4),
              image: DecorationImage(
                image:
                    AssetImage('assets/images/topographic.png'), // Pola latar
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten Utama
          ListView(
            padding: EdgeInsets.zero, // Menghilangkan padding bawaan ListView
            children: [
              // Header dengan tanggal
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBE1C3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "July",
                                style: GoogleFonts.balooBhai2(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "17",
                                style: GoogleFonts.balooBhai2(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Monday,",
                              style: GoogleFonts.balooBhai2(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "July 17th 2025",
                              style: GoogleFonts.balooBhai2(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Schedule",
                            style: GoogleFonts.balooBhai2(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Done",
                            style: GoogleFonts.balooBhai2(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Daftar Jadwal
              ...List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        index == 0
                            ? "15.00"
                            : index == 1
                                ? "17.00"
                                : "18.00",
                        style: GoogleFonts.balooBhai2(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        "Jalan Sentul No 29292, RT 07 / RW 19999",
                        style: GoogleFonts.balooBhai2(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      bottomNavigationBar:
          custom_nav.BottomNavBar(), // Navbar dari komponen Anda
    );
  }
}
