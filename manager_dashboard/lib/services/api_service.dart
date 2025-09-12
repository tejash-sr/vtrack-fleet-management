import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static String? _token;
  static String? _userId;
  static String? _userRole;

  static String? get token => _token;
  static String? get userId => _userId;
  static String? get userRole => _userRole;

  static void setAuthData(String token, String userId, String userRole) {
    _token = token;
    _userId = userId;
    _userRole = userRole;
  }

  static void clearAuthData() {
    _token = null;
    _userId = null;
    _userRole = null;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Authentication
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setAuthData(data['token'], data['user']['id'], data['user']['role']);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  // Add new driver (Admin only)
  static Future<Map<String, dynamic>?> addDriver(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to add driver');
      }
    } catch (e) {
      debugPrint('Add driver error: $e');
      return null;
    }
  }

  // Get all vehicles
  static Future<List<Map<String, dynamic>>> getVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load vehicles');
      }
    } catch (e) {
      debugPrint('Get vehicles error: $e');
      return [];
    }
  }

  // Add new vehicle
  static Future<Map<String, dynamic>?> addVehicle({
    required String name,
    required String type,
    String? driverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'type': type,
          'driverId': driverId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to add vehicle');
      }
    } catch (e) {
      debugPrint('Add vehicle error: $e');
      return null;
    }
  }

  // Assign driver to vehicle
  static Future<Map<String, dynamic>?> assignDriver(String vehicleId, String driverId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/vehicles/$vehicleId/assign-driver/$driverId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to assign driver');
      }
    } catch (e) {
      debugPrint('Assign driver error: $e');
      return null;
    }
  }

  // Unassign driver from vehicle
  static Future<Map<String, dynamic>?> unassignDriver(String vehicleId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/vehicles/$vehicleId/unassign-driver'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to unassign driver');
      }
    } catch (e) {
      debugPrint('Unassign driver error: $e');
      return null;
    }
  }

  // Get dashboard summary
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/summary'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load dashboard summary');
      }
    } catch (e) {
      debugPrint('Get dashboard summary error: $e');
      return {};
    }
  }

  // Get live vehicles
  static Future<List<Map<String, dynamic>>> getLiveVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/live-vehicles'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load live vehicles');
      }
    } catch (e) {
      debugPrint('Get live vehicles error: $e');
      return [];
    }
  }

  // Get trip history for a vehicle
  static Future<Map<String, dynamic>?> getTripHistory(String vehicleId, String day) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/trip-history/$vehicleId/$day'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return null; // No trip found
      } else {
        throw Exception('Failed to load trip history');
      }
    } catch (e) {
      debugPrint('Get trip history error: $e');
      return null;
    }
  }

  // Get live locations
  static Future<List<Map<String, dynamic>>> getLiveLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips/live'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load live locations');
      }
    } catch (e) {
      debugPrint('Get live locations error: $e');
      return [];
    }
  }

  // Get trip route
  static Future<Map<String, dynamic>?> getTripRoute(String vehicleId, String day) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips/route/$vehicleId/$day'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return null; // No route found
      } else {
        throw Exception('Failed to load trip route');
      }
    } catch (e) {
      debugPrint('Get trip route error: $e');
      return null;
    }
  }
}

