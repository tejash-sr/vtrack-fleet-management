import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _managerData;
  bool _isLoading = false;
  
  Map<String, dynamic>? get user => _user;
  Map<String, dynamic>? get managerData => _managerData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  
  AuthService() {
    // Check if user is already logged in
    _checkExistingAuth();
  }
  
  Future<void> _checkExistingAuth() async {
    if (ApiService.token != null && ApiService.userId != null) {
      _user = {
        'id': ApiService.userId,
        'username': 'Manager',
        'role': ApiService.userRole,
      };
      _managerData = {
        'username': 'Manager',
        'role': ApiService.userRole,
        'status': 'online',
      };
      notifyListeners();
    }
  }
  
  Future<String?> signInWithUsernameAndPassword(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await ApiService.login(username, password);
      
      if (result != null) {
        _user = result['user'];
        _managerData = {
          'username': result['user']['username'],
          'role': result['user']['role'],
          'status': 'online',
        };
        return null; // Success
      } else {
        return 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      debugPrint('Sign in error: $e');
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    try {
      ApiService.clearAuthData();
      _user = null;
      _managerData = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }
}
