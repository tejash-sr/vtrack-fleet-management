import 'package:flutter/foundation.dart';
import 'api_service.dart';

class DashboardService extends ChangeNotifier {
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> _liveVehicles = [];
  List<Map<String, dynamic>> _liveLocations = [];
  bool _isLoading = false;

  Map<String, dynamic> get summary => _summary;
  List<Map<String, dynamic>> get vehicles => _vehicles;
  List<Map<String, dynamic>> get liveVehicles => _liveVehicles;
  List<Map<String, dynamic>> get liveLocations => _liveLocations;
  bool get isLoading => _isLoading;

  // Load dashboard summary
  Future<void> loadSummary() async {
    _isLoading = true;
    notifyListeners();

    try {
      _summary = await ApiService.getDashboardSummary();
    } catch (e) {
      debugPrint('Load summary error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load all vehicles
  Future<void> loadVehicles() async {
    _isLoading = true;
    notifyListeners();

    try {
      _vehicles = await ApiService.getVehicles();
    } catch (e) {
      debugPrint('Load vehicles error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load live vehicles
  Future<void> loadLiveVehicles() async {
    try {
      _liveVehicles = await ApiService.getLiveVehicles();
      notifyListeners();
    } catch (e) {
      debugPrint('Load live vehicles error: $e');
    }
  }

  // Load live locations
  Future<void> loadLiveLocations() async {
    try {
      _liveLocations = await ApiService.getLiveLocations();
      notifyListeners();
    } catch (e) {
      debugPrint('Load live locations error: $e');
    }
  }

  // Add new vehicle
  Future<bool> addVehicle({
    required String name,
    required String type,
    String? driverId,
  }) async {
    try {
      final result = await ApiService.addVehicle(
        name: name,
        type: type,
        driverId: driverId,
      );
      
      if (result != null) {
        await loadVehicles(); // Refresh vehicles list
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Add vehicle error: $e');
      return false;
    }
  }

  // Add new driver
  Future<bool> addDriver(String username, String password) async {
    try {
      final result = await ApiService.addDriver(username, password);
      return result != null;
    } catch (e) {
      debugPrint('Add driver error: $e');
      return false;
    }
  }

  // Assign driver to vehicle
  Future<bool> assignDriver(String vehicleId, String driverId) async {
    try {
      final result = await ApiService.assignDriver(vehicleId, driverId);
      
      if (result != null) {
        await loadVehicles(); // Refresh vehicles list
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Assign driver error: $e');
      return false;
    }
  }

  // Unassign driver from vehicle
  Future<bool> unassignDriver(String vehicleId) async {
    try {
      final result = await ApiService.unassignDriver(vehicleId);
      
      if (result != null) {
        await loadVehicles(); // Refresh vehicles list
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Unassign driver error: $e');
      return false;
    }
  }

  // Get trip history for a vehicle
  Future<Map<String, dynamic>?> getTripHistory(String vehicleId, String day) async {
    try {
      return await ApiService.getTripHistory(vehicleId, day);
    } catch (e) {
      debugPrint('Get trip history error: $e');
      return null;
    }
  }

  // Get trip route for a vehicle
  Future<Map<String, dynamic>?> getTripRoute(String vehicleId, String day) async {
    try {
      return await ApiService.getTripRoute(vehicleId, day);
    } catch (e) {
      debugPrint('Get trip route error: $e');
      return null;
    }
  }

  // Load all data
  Future<void> loadAllData() async {
    await Future.wait([
      loadSummary(),
      loadVehicles(),
      loadLiveVehicles(),
      loadLiveLocations(),
    ]);
  }
}

