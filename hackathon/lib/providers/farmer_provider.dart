import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/farmer.dart';

class FarmerProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  Farmer? _farmer;
  Farmer? get farmer => _farmer;

  WebSocketChannel? _channel;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://agripay-later-backend-gdg-hackathon.onrender.com/ws/register'),
    );

    _channel!.stream.listen(
      (message) {
        final responseData = jsonDecode(message);

        if (responseData['status'] == 'success') {
          final data = responseData['data'];
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
          error = responseData['message'] ?? 'Unknown error occurred';
        }

        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        error = 'WebSocket error: $e';
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void register({
    required String name,
    required String idNumber,
    required String phone,
    required String password,
    required String role,
    required String email,
    double? landSize,
    String? cropType,
  }) {
    if (_channel == null) {
      connect();
    }

    isLoading = true;
    error = null;
    notifyListeners();

    final registerData = {
      'action': 'register',
      'payload': {
        'name': name,
        'idNumber': idNumber,
        'phone': phone,
        'password': password,
        'role': role,
        'email': email,
        if (landSize != null) 'land_size': landSize,
        if (cropType != null) 'crop_type': cropType,
      }
    };

    _channel!.sink.add(jsonEncode(registerData));
  }

  void disposeConnection() {
    _channel?.sink.close();
    _channel = null;
  }
}
