import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/farmer.dart';

class FarmerProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;

  Farmer? _farmer;
  Farmer? get farmer => _farmer;

  Future<void> register({
    required String name,
    required String idNumber,
    required String phone,
    required String password,
    required String role,
    required String email,
    double? landSize,
    String? cropType,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://agripay-later-backend-gdg-hackathon.onrender.com/api/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'idNumber': idNumber,
          'phone': phone,
          'password': password,
          'role': role,
          'email': email,
          'landSize': landSize,
          'cropType': cropType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        _farmer = Farmer(
          id: data['id'],
          name: data['name'],
          idNumber: data['idNumber'],
          phone: data['phone'],
          email: data['email'],
          role: data['role'],
          landSize: data['landSize']?.toDouble(),
          cropType: data['cropType'],
        );

        error = null;
      } else {
        error = 'Registration failed: ${response.body}';
      }
    } catch (e) {
      error = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
