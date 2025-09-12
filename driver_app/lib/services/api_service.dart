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

  // Get vehicles assigned to current driver
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

  // Start trip
  static Future<Map<String, dynamic>?> startTrip(String vehicleId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips/start'),
        headers: _headers,
        body: jsonEncode({'vehicleId': vehicleId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to start trip');
      }
    } catch (e) {
      debugPrint('Start trip error: $e');
      return null;
    }
  }

  // Update location
  static Future<Map<String, dynamic>?> updateLocation({
    required String vehicleId,
    required double lat,
    required double lng,
    double? speed,
    double? heading,
    double? accuracy,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips/location'),
        headers: _headers,
        body: jsonEncode({
          'vehicleId': vehicleId,
          'lat': lat,
          'lng': lng,
          'speed': speed,
          'heading': heading,
          'accuracy': accuracy,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to update location');
      }
    } catch (e) {
      debugPrint('Update location error: $e');
      return null;
    }
  }

  // End trip
  static Future<Map<String, dynamic>?> endTrip(String vehicleId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips/end'),
        headers: _headers,
        body: jsonEncode({'vehicleId': vehicleId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to end trip');
      }
    } catch (e) {
      debugPrint('End trip error: $e');
      return null;
    }
  }

  // Get trip history
  static Future<List<Map<String, dynamic>>> getTripHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips/history'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load trip history');
      }
    } catch (e) {
      debugPrint('Get trip history error: $e');
      return [];
    }
  }
}

