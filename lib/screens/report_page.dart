import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import '../services/api_service.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerAddressController =
      TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  Map<String, dynamic>? currentOrder;
  bool isLoading = false;
  String errorMessage = '';
  bool isDetectingOrder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Attempt to load order from route arguments first.
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('order')) {
      setState(() {
        currentOrder = args['order'];
        _populateOrderData();
      });
    } else {
      // If no order was passed (e.g. from navbar), auto-detect the current order.
      _detectCurrentOrder();
    }
  }

  // Populate the text controllers with order details using the new address fields.
  void _populateOrderData() {
    if (currentOrder != null) {
      // Address details are now extracted from the nested user object.
      final user = currentOrder!['user'] ?? {};
      final streetName = user['street_name'] ?? '';
      final rt = user['rt'] ?? '';
      final rw = user['rw'] ?? '';
      final postalCode =
          user['postal_code'] != null ? user['postal_code'].toString() : '';
      _customerNameController.text = user['name'] ?? '';
      _customerAddressController.text =
          '$streetName, RT: $rt, RW: $rw, Postal Code: $postalCode';
    }
  }

  // Automatically detect current order for the logged in driver.
  Future<void> _detectCurrentOrder() async {
    setState(() {
      isDetectingOrder = true;
    });
    try {
      final userData = await ApiService().getUserData();
      final driverId = int.tryParse(userData['id'] ?? '0');
      if (driverId == null) {
        setState(() {
          errorMessage = 'Driver information not available.';
          isDetectingOrder = false;
        });
        return;
      }
      final orders = await ApiService().getAssignedOrders(driverId);
      // Only consider orders that are not completed or reported.
      final activeOrders = orders
          .where((order) =>
              order['status'] != 'completed' && order['status'] != 'reported')
          .toList();
      if (activeOrders.isNotEmpty) {
        setState(() {
          currentOrder = activeOrders.first;
          _populateOrderData();
        });
      } else {
        setState(() {
          errorMessage = 'No active orders found for reporting.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error detecting order: $e';
      });
    } finally {
      setState(() {
        isDetectingOrder = false;
      });
    }
  }

  Future<void> _submitReport() async {
    if (currentOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No order information available to report')),
      );
      return;
    }
    if (_problemController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a problem description')),
      );
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final userData = await ApiService().getUserData();
      final driverId = int.tryParse(userData['id'] ?? '0');
      if (driverId == null) {
        setState(() {
          errorMessage = 'Driver information not available.';
          isLoading = false;
        });
        return;
      }
      final result = await ApiService().submitReport(
        currentOrder!['id'],
        driverId,
        _problemController.text,
      );
      setState(() {
        isLoading = false;
      });
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report submitted successfully')),
        );
        // After successful report submission, return true to trigger order refresh.
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  Widget _buildNoOrderContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDetectingOrder
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No order data detected.\n\n'
                    'Please select an order from the Home page to report if available.',
                    style: GoogleFonts.balooBhai2(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    ),
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.balooBhai2(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (errorMessage.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: GoogleFonts.balooBhai2(
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
                ],
              ),
      ),
    );
  }

  Widget _buildReportForm() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Report Problem',
                  style: GoogleFonts.balooBhai2(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.brown, width: 3),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Display Order ID
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Order #${currentOrder!['id']}',
                          style: GoogleFonts.balooBhai2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Customer Name Field
                      Text(
                        'Customer Name:',
                        style: GoogleFonts.balooBhai2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      _buildTextField(
                        controller: _customerNameController,
                        enabled: false,
                      ),
                      SizedBox(height: 16),
                      // Customer Address Field (uses new formatting)
                      Text(
                        'Customer Address:',
                        style: GoogleFonts.balooBhai2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      _buildTextField(
                        controller: _customerAddressController,
                        enabled: false,
                      ),
                      SizedBox(height: 16),
                      // Problem Description Field
                      Text(
                        'Problem (Please provide a detailed description):',
                        style: GoogleFonts.balooBhai2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      _buildTextField(
                        controller: _problemController,
                        maxLines: 4,
                        hintText: 'Describe the problem you encountered...',
                      ),
                      if (errorMessage.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.balooBhai2(
                              color: Colors.red.shade800,
                            ),
                          ),
                        ),
                      SizedBox(height: 24),
                      // Submit Report Button
                      Center(
                        child: isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submitReport,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Submit Report',
                                  style: GoogleFonts.balooBhai2(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    int maxLines = 1,
    bool enabled = true,
    TextEditingController? controller,
    String hintText = 'Type a text :',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.grey.shade200 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.balooBhai2(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6D9773),
          image: DecorationImage(
            image: AssetImage('assets/images/topographic-light.png'),
            fit: BoxFit.cover,
          ),
        ),
        child:
            currentOrder == null ? _buildNoOrderContent() : _buildReportForm(),
      ),
      bottomNavigationBar: custom_nav.BottomNavBar(),
    );
  }
}
