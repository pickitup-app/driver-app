import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  // Fungsi login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': androidInfo.model,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        final userData = responseData['data']['user'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', userData['id']);
        await prefs.setString('user_name', userData['name']);
        await prefs.setString('user_email', userData['email']);
        await prefs.setString('user_phone_number', userData['phone_number']);

        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'An error occurred during login',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Mendapatkan data user dari SharedPreferences
  Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('user_id')?.toString(),
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
      'phone_number': prefs.getString('user_phone_number'),
    };
  }

  // Mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Mendapatkan assigned orders untuk driver tertentu
  Future<List<dynamic>> getAssignedOrders(int driverId) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$apiBaseUrl/get-assigned-orders/$driverId');
      print('Fetching assigned orders from: $url');
      print('Using token: $token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final orders = responseData['data'] as List<dynamic>;
        print('Number of orders received: ${orders.length}');
        return orders;
      } else {
        print('Failed to load orders, status code: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error in getAssignedOrders: $e');
      rethrow;
    }
  }

  // Get scheduled orders (grouped by date)
  Future<Map<String, List<dynamic>>> getScheduledOrders(int driverId) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$apiBaseUrl/get-scheduled-orders/$driverId');
      print('Fetching scheduled orders from: $url');
      print('Using token: $token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final Map<String, dynamic> ordersMap = responseData['data'];

        Map<String, List<dynamic>> typedOrdersMap = {};
        ordersMap.forEach((key, value) {
          typedOrdersMap[key] = List<dynamic>.from(value);
        });

        print('Scheduled orders received for ${typedOrdersMap.length} days');
        return typedOrdersMap;
      } else {
        print(
            'Failed to load scheduled orders, status code: ${response.statusCode}');
        throw Exception('Failed to load scheduled orders');
      }
    } catch (e) {
      print('Error in getScheduledOrders: $e');
      rethrow;
    }
  }

  // Update order status dengan status yang diberikan
  Future<Map<String, dynamic>> updateOrderStatus(
      dynamic orderId, String status) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$apiBaseUrl/update-order-status/$orderId');

      print('Updating order status to $status using url: $url');
      print('Using token: $token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      print('Update order status response status: ${response.statusCode}');
      print('Update order status response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update order status',
        };
      }
    } catch (e) {
      print('Error in updateOrderStatus: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Legacy method - sekarang menggunakan updateOrderStatus
  Future<void> completeOrder(dynamic orderId) async {
    final result = await updateOrderStatus(orderId, 'completed');
    if (!result['success']) {
      throw Exception(result['message']);
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone_number');
  }

  // Submit report. Setelah report berhasil, order akan diupdate status menjadi 'reported'
  Future<Map<String, dynamic>> submitReport(
      int orderId, int driverId, String problem) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$apiBaseUrl/submit-report/$orderId');
      print('Submitting report to: $url');
      print('Using token: $token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'driver_id': driverId,
          'order_id': orderId,
          'problem': problem,
        }),
      );

      print('Submit report response status: ${response.statusCode}');
      print('Submit report response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to submit report',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Method untuk mengambil data profile dari API.
  // Endpoint: $apiBaseUrl/get-profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      final url = Uri.parse('$apiBaseUrl/get-profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Fetching profile from: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Mengembalikan object driver yang termuat dengan data tambahan:
        // total_days, total_orders, total_reports.
        return responseData['data'];
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error in getProfile: $e');
      throw Exception('Error fetching profile data: $e');
    }
  }
}
