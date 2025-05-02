// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/input_option.dart';

class ApiService {
  static const _base = 'https://api.agripaylater.com';

  Future<void> registerFarmer(Map<String, String> data, String imagePath) async {
    final uri = Uri.parse('$_base/farmers');
    final req = http.MultipartRequest('POST', uri)
      ..fields.addAll(data)
      ..files.add(await http.MultipartFile.fromPath('soilSelfie', imagePath));
    final resp = await req.send();
    if (resp.statusCode >= 400) throw Exception('Registration failed');
  }

  Future<List<InputOption>> fetchInputOptions(double landSize, String cropType) async {
    final uri = Uri.parse('$_base/loan/options?land=$landSize&crop=$cropType');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to load options');
    final List jsonList = jsonDecode(resp.body);
    return jsonList.map((j) => InputOption(name: j['name'], maxLoan: j['maxLoan'])).toList();
  }

  Future<void> requestLoan(String farmerId, String inputName) async {
    final uri = Uri.parse('$_base/loan/request');
    final resp = await http.post(uri, body: {'farmerId': farmerId, 'input': inputName});
    if (resp.statusCode >= 400) throw Exception('Loan request failed');
  }
}
