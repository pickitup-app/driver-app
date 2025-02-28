import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickitupdriver/components/bottom_navbar.dart' as custom_nav;
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart' as intl;

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, List<dynamic>> schedulesByDate = {};
  bool isLoading = true;
  String errorMessage = '';
  int? driverId;
  DateTime selectedDate = DateTime.now();
  String activeTab = 'upcoming'; // 'upcoming' or 'completed'

  @override
  void initState() {
    super.initState();
    loadDriverAndFetchSchedules();
  }

  // Load the driver id and fetch schedules
  Future<void> loadDriverAndFetchSchedules() async {
    try {
      final userData = await ApiService().getUserData();
      if (userData['id'] != null) {
        driverId = int.tryParse(userData['id']!);
        if (driverId != null) {
          await fetchSchedules();
        } else {
          setState(() {
            errorMessage = 'Invalid driver id.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Driver not logged in.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading driver information: $e';
        isLoading = false;
      });
    }
  }

  // Fetch schedules from API
  Future<void> fetchSchedules() async {
    if (driverId == null) {
      setState(() {
        errorMessage = 'Driver id is not set';
        isLoading = false;
      });
      return;
    }

    try {
      final schedulesData = await ApiService().getScheduledOrders(driverId!);
      setState(() {
        schedulesByDate = schedulesData;
        isLoading = false;

        // If there are schedules, select the first date
        if (schedulesByDate.isNotEmpty) {
          final firstDate = schedulesByDate.keys.first;
          selectedDate = DateTime.parse(firstDate);
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching schedules: $e';
        isLoading = false;
      });
    }
  }

  // Format time from date string (e.g., "2025-02-27 14:30:00" -> "14:30")
  // If dateTimeString is null or empty, return "17.00"
  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "17.00";
    }
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return intl.DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  // Get day name (e.g., "Monday")
  String getDayName(DateTime date) {
    return intl.DateFormat('EEEE').format(date);
  }

  // Get month name (e.g., "July")
  String getMonthName(DateTime date) {
    return intl.DateFormat('MMMM').format(date);
  }

  // Get day with suffix (e.g., "17th")
  String getDayWithSuffix(DateTime date) {
    int day = date.day;
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Selected date formatted for display
    final formattedDate =
        '${getDayName(selectedDate)}, ${getMonthName(selectedDate)} ${getDayWithSuffix(selectedDate)} ${selectedDate.year}';

    // Get orders for the selected date
    final String selectedDateString =
        intl.DateFormat('yyyy-MM-dd').format(selectedDate);

    // Get orders for the selected date from fetched schedules
    List<dynamic> ordersForSelectedDate =
        schedulesByDate[selectedDateString] ?? [];

    // For "completed" tab, filter orders with status "completed"
    // For "upcoming" tab (Schedule), filter out orders with status "completed"
    if (activeTab == 'completed') {
      ordersForSelectedDate = ordersForSelectedDate
          .where((order) => order['status'] == 'completed')
          .toList();
    } else {
      ordersForSelectedDate = ordersForSelectedDate
          .where((order) => order['status'] != 'completed')
          .toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background with pattern
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1FCE4),
              image: DecorationImage(
                image: AssetImage('assets/images/topographic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Header with date and tabs
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          getMonthName(selectedDate)
                                              .substring(0, 3),
                                          style: GoogleFonts.balooBhai2(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "${selectedDate.day}",
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
                                        "${getDayName(selectedDate)},",
                                        style: GoogleFonts.balooBhai2(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        formattedDate.split(',')[1].trim(),
                                        style: GoogleFonts.balooBhai2(
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        activeTab = 'upcoming';
                                      });
                                    },
                                    child: Text(
                                      "Schedule",
                                      style: GoogleFonts.balooBhai2(
                                        color: activeTab == 'upcoming'
                                            ? Colors.orange
                                            : Colors.grey,
                                        fontWeight: activeTab == 'upcoming'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        activeTab = 'completed';
                                      });
                                    },
                                    child: Text(
                                      "Done",
                                      style: GoogleFonts.balooBhai2(
                                        color: activeTab == 'completed'
                                            ? Colors.orange
                                            : Colors.grey,
                                        fontWeight: activeTab == 'completed'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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

                        // Date selector (horizontal scrolling)
                        if (schedulesByDate.isNotEmpty)
                          Container(
                            height: 70,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: schedulesByDate.length,
                              itemBuilder: (context, index) {
                                final dateString =
                                    schedulesByDate.keys.elementAt(index);
                                final date = DateTime.parse(dateString);
                                final isSelected = DateFormat('yyyy-MM-dd')
                                        .format(selectedDate) ==
                                    dateString;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    },
                                    child: Container(
                                      width: 60,
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.orange
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            intl.DateFormat('MMM').format(date),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${date.day}',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Empty state for no schedules or no orders
                        if (ordersForSelectedDate.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No schedules found",
                                    style: GoogleFonts.balooBhai2(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Schedules list for the selected date
                        if (ordersForSelectedDate.isNotEmpty)
                          ...ordersForSelectedDate.map((order) {
                            // For "completed" tab, show custom header layout.
                            if (activeTab == 'completed') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Maximum Pickup Time
                                        Text(
                                          "Maximum Pickup Time: ${formatTime(order['pickup_time'] ?? '')}",
                                          style: GoogleFonts.balooBhai2(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Status Order
                                        Text(
                                          "Status Order: ${order['status'] ?? 'Urgent/Scheduled'}",
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        // Customer Name
                                        Text(
                                          "Customer Name: ${order['user']?['name'] ?? 'Unknown'}",
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        // Phone Number
                                        Text(
                                          "Phone Number: ${order['user']?['phone_number'] ?? 'N/A'}",
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Default layout for "upcoming" orders with address from user data.
                              final user = order['user'] ?? {};
                              final address =
                                  '${user['street_name'] ?? 'No address'}, RT ${user['rt'] ?? ''}, RW ${user['rw'] ?? ''}';
                              final pickupTime =
                                  formatTime(order['time_slot'] ?? '');
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  elevation: 4,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16.0),
                                    title: Text(
                                      pickupTime,
                                      style: GoogleFonts.balooBhai2(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          address,
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Customer: ${user['name'] ?? 'Unknown'}',
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Phone: ${user['phone_number'] ?? 'N/A'}',
                                          style: GoogleFonts.balooBhai2(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 8),
                                        // Order status badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            order['status'] ?? 'scheduled',
                                            style: GoogleFonts.balooBhai2(
                                              color: Colors.green[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.navigate_next,
                                          color: Colors.orange),
                                      onPressed: () {
                                        // Navigate to order details or start navigation
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                      ],
                    ),
        ],
      ),
      bottomNavigationBar: custom_nav.BottomNavBar(),
    );
  }
}
