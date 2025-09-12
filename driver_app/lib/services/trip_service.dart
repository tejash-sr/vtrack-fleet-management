import 'package:flutter/foundation.dart';
import 'api_service.dart';

class TripService extends ChangeNotifier {
  String? _currentTripId;
  String? _currentVehicleId;
  bool _isTripActive = false;
  double _totalDistance = 0.0;
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> _tripHistory = [];

  String? get currentTripId => _currentTripId;
  String? get currentVehicleId => _currentVehicleId;
  bool get isTripActive => _isTripActive;
  double get totalDistance => _totalDistance;
  List<Map<String, dynamic>> get vehicles => _vehicles;
  List<Map<String, dynamic>> get tripHistory => _tripHistory;

  // Load vehicles assigned to current driver
  Future<void> loadVehicles() async {
    try {
      _vehicles = await ApiService.getVehicles();
      notifyListeners();
    } catch (e) {
      debugPrint('Load vehicles error: $e');
    }
  }

  // Start a new trip
  Future<String?> startTrip(String vehicleId) async {
    try {
      final result = await ApiService.startTrip(vehicleId);
      if (result != null) {
        _currentTripId = result['trip']['_id'];
        _currentVehicleId = vehicleId;
        _isTripActive = true;
        _totalDistance = 0.0;
        notifyListeners();
        return _currentTripId;
      }
      return null;
    } catch (e) {
      debugPrint('Start trip error: $e');
      return null;
    }
  }

  // Update location during trip
  Future<bool> updateLocation({
    required double lat,
    required double lng,
    double? speed,
    double? heading,
    double? accuracy,
  }) async {
    if (!_isTripActive || _currentVehicleId == null) return false;

    try {
      final result = await ApiService.updateLocation(
        vehicleId: _currentVehicleId!,
        lat: lat,
        lng: lng,
        speed: speed,
        heading: heading,
        accuracy: accuracy,
      );

      if (result != null) {
        _totalDistance = result['distanceTravelled'] ?? 0.0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update location error: $e');
      return false;
    }
  }

  // End current trip
  Future<bool> endTrip() async {
    if (!_isTripActive || _currentVehicleId == null) return false;

    try {
      final result = await ApiService.endTrip(_currentVehicleId!);
      if (result != null) {
        _currentTripId = null;
        _currentVehicleId = null;
        _isTripActive = false;
        _totalDistance = 0.0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('End trip error: $e');
      return false;
    }
  }

  // Load trip history
  Future<void> loadTripHistory() async {
    try {
      _tripHistory = await ApiService.getTripHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Load trip history error: $e');
    }
  }

  // Reset trip data
  void resetTrip() {
    _currentTripId = null;
    _currentVehicleId = null;
    _isTripActive = false;
    _totalDistance = 0.0;
    notifyListeners();
  }
}

