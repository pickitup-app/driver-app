import 'package:flutter/material.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6D9773),
          image: DecorationImage(
            image: AssetImage(
                'assets/images/topographic-light.png'), // Tambahkan gambar background
            fit: BoxFit.cover, // Menutupi seluruh background
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title Outside the Form Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Report Page',
                      style: GoogleFonts.balooBhai2(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Sedikit transparan
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.brown, width: 3),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Customer Name Field
                      Text(
                        'Customer Name:',
                        style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800),
                      ),
                      _buildTextField(),
                      SizedBox(height: 16),

                      // Customer Address Field
                      Text(
                        'Customer Address:',
                        style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800),
                      ),
                      _buildTextField(),
                      SizedBox(height: 16),

                      // Problem Description Field
                      Text(
                        'Problem (Please provide a detailed description):',
                        style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800),
                      ),
                      _buildTextField(maxLines: 4),
                      SizedBox(height: 24),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement submit action here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'Submit',
                            style: GoogleFonts.balooBhai2(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          custom_nav.BottomNavBar(), // Menggunakan BottomNavBar yang diimpor
    );
  }

  Widget _buildTextField({int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type a text :',
          hintStyle:
              GoogleFonts.balooBhai2(fontSize: 14, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
