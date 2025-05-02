import 'package:flutter/material.dart';
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
  String? idPhotoPath, // <-- make optional
}) async {
  // Proceed without using idPhotoPath


    isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      _farmer = Farmer(
        id: "generated_id_123",
        name: name,
        idNumber: idNumber,
        phone: phone,
        email: email,
        role: role,
        landSize: landSize,
        cropType: cropType,
        soilSelfieUrl: idPhotoPath, // ✅ Add this line
      );

      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
