import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _role = '';
  String get role => _role;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourbackendapi.com/login'), // Replace with your backend API URL
        body: json.encode({
          'email': email,
          'password': password,
          'role': role,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _isAuthenticated = true;
          _role = role;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourbackendapi.com/register'), // Replace with your backend API URL
        body: json.encode({
          'email': email,
          'password': password,
          'role': role,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          _isAuthenticated = true;
          _role = role;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _role = '';
    notifyListeners();
  }
}
