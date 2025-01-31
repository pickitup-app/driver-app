import 'package:flutter/material.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/topographic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero, // Menghilangkan padding bawaan ListView
            children: [
              // Header section
              Container(
                height: 280.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/truck_home.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Customer details section
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer Name:',
                                      style: GoogleFonts.balooBhai2(
                                          color: Color(0xFFBB8A52),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('Customer 123'),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Customer Phone:',
                                      style: GoogleFonts.balooBhai2(
                                          fontSize: 22,
                                          color: Color(0xFFBB8A52),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('8XXXXXX898'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Type:',
                                      style: GoogleFonts.balooBhai2(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        'Normal',
                                        style: GoogleFonts.balooBhai2(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Address section
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address:',
                              style: GoogleFonts.balooBhai2(
                                  color: Color(0xFFBB8A52),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            const SizedBox(height: 16),
                            // Street Address Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Street Address',
                                  style: GoogleFonts.balooBhai2(
                                      fontSize: 19, color: Color(0xFFBB8A52)),
                                ),
                                const SizedBox(height: 4),
                                Text('Jalan Sentul no 29292',
                                    style: GoogleFonts.balooBhai2(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // RT / RW and Postal Code
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RT / RW',
                                      style: GoogleFonts.balooBhai2(
                                          fontSize: 19,
                                          color: Color(0xFFBB8A52)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('07 / 07',
                                        style: GoogleFonts.balooBhai2(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Postal Code',
                                      style: GoogleFonts.balooBhai2(
                                          fontSize: 19,
                                          color: Color(0xFFBB8A52)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('19999',
                                        style: GoogleFonts.balooBhai2(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Pick Up Time and Map Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Maximum Pick Up Time: 14.00',
                                      style:
                                          GoogleFonts.balooBhai2(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.map,
                                          color: Colors.blue),
                                      tooltip: 'Open Location',
                                    ),
                                    Text(
                                      'Open Location With',
                                      style: GoogleFonts.balooBhai2(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Slide to complete button
                    SlideToAct(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: custom_nav.BottomNavBar(),
    );
  }
}

class SlideToAct extends StatefulWidget {
  @override
  _SlideToActState createState() => _SlideToActState();
}

class _SlideToActState extends State<SlideToAct> {
  double _dragPosition = 0.0;
  final double _dragThreshold = 0.85;

  void _onDragEnd() {
    if (_dragPosition >= _dragThreshold) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order Completed!")),
      );
      setState(() {
        _dragPosition = 0.0;
      });
    } else {
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF6D9773),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              _dragPosition >= _dragThreshold
                  ? "Order Completed!"
                  : "Already Done?",
              style: GoogleFonts.balooBhai2(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left:
                _dragPosition * (MediaQuery.of(context).size.width * 0.9 - 60),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragPosition += details.primaryDelta! /
                      (MediaQuery.of(context).size.width * 0.9);
                  if (_dragPosition < 0) _dragPosition = 0;
                  if (_dragPosition > 1) _dragPosition = 1;
                });
              },
              onHorizontalDragEnd: (details) {
                _onDragEnd();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFFFBA00),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
