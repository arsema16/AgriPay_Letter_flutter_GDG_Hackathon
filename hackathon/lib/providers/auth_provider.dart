import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _role = ''; // To store the role of the user
  String get role => _role; // Expose the role to be used in UI

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password, String role) async {
    try {
      // Simulate a network request for login (replace with actual API call)
      await Future.delayed(Duration(seconds: 2)); // Simulating network delay

      // Example authentication logic with role
      if (email == 'farmer@example.com' && password == 'password123' && role == 'farmer') {
        _isAuthenticated = true;
        _role = 'farmer'; // Assign the role after login
        notifyListeners();
        return true;
      } else if (email == 'admin@example.com' && password == 'password123' && role == 'admin') {
        _isAuthenticated = true;
        _role = 'admin'; // Assign the role after login
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String role) async {
    try {
      // Simulate a network request for registration (replace with actual API call)
      await Future.delayed(Duration(seconds: 2)); // Simulating network delay

      // Example registration logic (mocked)
      if (email.isNotEmpty && password.length > 5) {
        _isAuthenticated = true; // Assume registration is successful
        _role = role; // Assign the role during registration
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _role = ''; // Clear the role during logout
    notifyListeners();
  }
}
