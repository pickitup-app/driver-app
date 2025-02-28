import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import '../services/api_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? driverId;
  List<dynamic> orders = [];
  bool loadingOrders = true;
  String errorMessage = '';

  // Order status progression
  final List<String> statusProgression = [
    'scheduled',
    'confirmed',
    'on_the_way',
    'completed'
  ];

  // Display text for each status
  final Map<String, String> statusDisplayText = {
    'scheduled': 'Slide to Confirm Pickup',
    'confirmed': 'Slide to Start Delivery',
    'on_the_way': 'Slide to Complete Delivery',
    'completed': 'Order Completed!',
  };

  @override
  void initState() {
    super.initState();
    loadDriverAndFetchOrders();
  }

  // Load driver id from storage and fetch orders
  Future<void> loadDriverAndFetchOrders() async {
    try {
      final userData = await ApiService().getUserData();
      if (userData['id'] != null) {
        driverId = int.tryParse(userData['id']!);
        if (driverId != null) {
          await fetchOrders();
        } else {
          setState(() {
            errorMessage = 'Invalid driver id.';
            loadingOrders = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Driver not logged in.';
          loadingOrders = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading driver information: $e';
        loadingOrders = false;
      });
    }
  }

  // Fetch assigned orders for the driver while skipping orders with status 'completed' or 'reported'
  Future<void> fetchOrders() async {
    if (driverId == null) {
      setState(() {
        errorMessage = 'Driver id is not set';
        loadingOrders = false;
      });
      return;
    }
    try {
      final result = await ApiService().getAssignedOrders(driverId!);
      // Filter out orders with status 'completed' or 'reported'
      final nonCompletedOrders = result
          .where((order) =>
              order['status'] != 'completed' && order['status'] != 'reported')
          .toList();
      setState(() {
        orders = nonCompletedOrders;
        loadingOrders = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching orders: $e';
        loadingOrders = false;
      });
    }
  }

  // Get next status in progression
  String getNextStatus(String currentStatus) {
    int currentIndex = statusProgression.indexOf(currentStatus);
    if (currentIndex < 0 || currentIndex >= statusProgression.length - 1) {
      return 'completed';
    }
    return statusProgression[currentIndex + 1];
  }

  // Update order status and progress to the next state
  Future<void> progressOrderStatus() async {
    if (orders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No orders available.")),
      );
      return;
    }

    final currentOrder = orders.first;
    final orderId = currentOrder['id'];
    final currentStatus = currentOrder['status'] ?? 'scheduled';
    final nextStatus = getNextStatus(currentStatus);

    try {
      final result = await ApiService().updateOrderStatus(orderId, nextStatus);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Order status updated to ${nextStatus.replaceAll('_', ' ')}")),
        );

        // If order is completed or reported, remove it from the list
        if (nextStatus == 'completed' || nextStatus == 'reported') {
          setState(() {
            orders.removeAt(0);
          });
        } else {
          setState(() {
            orders[0]['status'] = nextStatus;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to update order status: ${result['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order status: $e")),
      );
    }
  }

  // Build UI with order details and report button
  Widget buildOrderDetails() {
    if (loadingOrders) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }
    if (orders.isEmpty) {
      return const Center(child: Text("No orders available"));
    }

    final currentOrder = orders.first;
    final user = currentOrder['user'] ?? {};
    final streetAddress =
        currentOrder['street_address'] ?? 'Jalan Sentul no 29292';
    final rtRw = currentOrder['rt_rw'] ?? '07 / 07';
    final postalCode = currentOrder['postal_code'] ?? '19999';
    final pickUpTime = currentOrder['time_slot'] ?? '17:00';
    final currentStatus = currentOrder['status'] ?? 'scheduled';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: _getStatusColor(currentStatus),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            "Status: ${_getDisplayStatus(currentStatus)}",
            style: GoogleFonts.balooBhai2(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Customer information
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Name:',
                      style: GoogleFonts.balooBhai2(
                        color: const Color(0xFFBB8A52),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user['name'] ?? 'Customer Name'),
                    const SizedBox(height: 8),
                    Text(
                      'Customer Phone:',
                      style: GoogleFonts.balooBhai2(
                        fontSize: 22,
                        color: const Color(0xFFBB8A52),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user['phone_number'] ?? 'Phone Number'),
                  ],
                ),
                // Order type information
                Column(
                  children: [
                    Text(
                      'Type:',
                      style: GoogleFonts.balooBhai2(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: currentOrder['is_urgent'] == 1
                            ? Colors.red
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        currentOrder['is_urgent'] == 1 ? 'Urgent' : 'Normal',
                        style: GoogleFonts.balooBhai2(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                    color: const Color(0xFFBB8A52),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                // Street Address Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Street Address',
                      style: GoogleFonts.balooBhai2(
                        fontSize: 19,
                        color: const Color(0xFFBB8A52),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      streetAddress,
                      style: GoogleFonts.balooBhai2(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                            color: const Color(0xFFBB8A52),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rtRw,
                          style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Postal Code',
                          style: GoogleFonts.balooBhai2(
                            fontSize: 19,
                            color: const Color(0xFFBB8A52),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          postalCode,
                          style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pick Up Time and Map button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Maximum Pick Up Time: $pickUpTime',
                          style: GoogleFonts.balooBhai2(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Implement map opening functionality here if needed
                          },
                          icon: const Icon(Icons.map, color: Colors.blue),
                          tooltip: 'Open Location',
                        ),
                        Text(
                          'Open Location With',
                          style: GoogleFonts.balooBhai2(
                            fontSize: 12,
                            color: Colors.blue,
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
        // Slide to Update order status widget and Report Problem button
        if (orders.isNotEmpty)
          Column(
            children: [
              SlideToAct(
                text:
                    statusDisplayText[orders.first['status'] ?? 'scheduled'] ??
                        'Slide to Update',
                onSlideComplete: () async {
                  await progressOrderStatus();
                },
              ),
              const SizedBox(height: 12),
              // "Report Problem" Button
              Container(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.report_problem, color: Colors.white),
                  label: Text(
                    'Report Problem with this Order',
                    style: GoogleFonts.balooBhai2(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    // Navigate to the report page with the current order details.
                    final result = await Navigator.pushNamed(
                      context,
                      '/report',
                      arguments: {'order': orders.first},
                    );
                    // If the report was successful, refresh the orders list.
                    if (result == true) {
                      await fetchOrders();
                    }
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _getDisplayStatus(String status) {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'confirmed':
        return 'Confirmed';
      case 'on_the_way':
        return 'On The Way';
      case 'completed':
        return 'Completed';
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'on_the_way':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/topographic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header with truck image
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
                    buildOrderDetails(),
                    const SizedBox(height: 16),
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

// SlideToAct widget implementation
class SlideToAct extends StatefulWidget {
  final Future<void> Function() onSlideComplete;
  final String text;

  const SlideToAct({
    Key? key,
    required this.onSlideComplete,
    required this.text,
  }) : super(key: key);

  @override
  _SlideToActState createState() => _SlideToActState();
}

class _SlideToActState extends State<SlideToAct> {
  double _dragPosition = 0.0;
  final double _dragThreshold = 0.85;

  void _onDragEnd() async {
    if (_dragPosition >= _dragThreshold) {
      await widget.onSlideComplete();
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
    final width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      width: width,
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
                  ? "Release to confirm!"
                  : widget.text,
              style: GoogleFonts.balooBhai2(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left: _dragPosition * (width - 60),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragPosition += details.primaryDelta! / width;
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
                  color: const Color(0xFFFFBA00),
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
