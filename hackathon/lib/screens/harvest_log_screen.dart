import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http; // Uncomment when enabling cloud sync

class HarvestLog {
  final String cropName;
  final int quantity;
  final String date;
  String syncStatus; // "Pending" or "Synced"

  HarvestLog({
    required this.cropName,
    required this.quantity,
    required this.date,
    this.syncStatus = "Pending",
  });

  Map<String, dynamic> toJson() => {
        'cropName': cropName,
        'quantity': quantity,
        'date': date,
        'syncStatus': syncStatus,
      };

  static HarvestLog fromJson(Map<String, dynamic> json) => HarvestLog(
        cropName: json['cropName'],
        quantity: json['quantity'],
        date: json['date'],
        syncStatus: json['syncStatus'],
      );
}

class HarvestLogScreen extends StatefulWidget {
  @override
  _HarvestLogScreenState createState() => _HarvestLogScreenState();
}

class _HarvestLogScreenState extends State<HarvestLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<HarvestLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsJson = prefs.getString('harvestLogs');
    if (logsJson != null) {
      final List decoded = json.decode(logsJson);
      setState(() {
        _logs = decoded.map((e) => HarvestLog.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> logList =
        _logs.map((e) => e.toJson()).toList();
    prefs.setString('harvestLogs', json.encode(logList));
  }

  void _addLog() {
    if (_formKey.currentState!.validate()) {
      final newLog = HarvestLog(
        cropName: _cropController.text,
        quantity: int.parse(_quantityController.text),
        date: _selectedDate.toIso8601String().split('T').first,
      );

      setState(() {
        _logs.add(newLog);
      });

      _saveLogs();

      _cropController.clear();
      _quantityController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harvest logged (pending sync)')),
      );
    }
  }

  void _simulateSync() async {
    setState(() {
      for (var log in _logs) {
        log.syncStatus = "Synced"; // Simulate offline sync
      }
    });

    // Optional: Enable cloud sync
    // for (var log in _logs) {
    //   if (log.syncStatus == "Pending") {
    //     await _syncToServer(log);
    //   }
    // }

    _saveLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All logs synced!')),
    );
  }

  // Uncomment this when enabling backend sync
  /*
  Future<void> _syncToServer(HarvestLog log) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-server.com/api/sync-harvest'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(log.toJson()),
      );

      if (response.statusCode == 200) {
        log.syncStatus = "Synced";
      } else {
        print('Failed to sync: ${log.cropName}');
      }
    } catch (e) {
      print('Sync error: $e');
    }
  }
  */

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Harvest Logging')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildForm(),
              const SizedBox(height: 20),
              Expanded(child: _buildLogList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _simulateSync,
          icon: const Icon(Icons.sync),
          label: const Text('Sync All'),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cropController,
            decoration: const InputDecoration(labelText: 'Crop Name'),
            validator: (value) => value!.isEmpty ? 'Enter crop name' : null,
          ),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity (kg)'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Date: ${_selectedDate.toLocal().toIso8601String().split('T').first}'),
              TextButton(
                onPressed: _pickDate,
                child: const Text('Choose Date'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addLog,
            child: const Text('Add Harvest'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogList() {
    if (_logs.isEmpty) {
      return const Center(child: Text('No harvests logged yet.'));
    }
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final isSynced = log.syncStatus == "Synced";
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: Icon(Icons.agriculture,
                color: isSynced ? Colors.green : Colors.orange),
            title: Text('${log.cropName} - ${log.quantity}kg'),
            subtitle: Text('Date: ${log.date}'),
            trailing: Text(
              log.syncStatus,
              style: TextStyle(
                color: isSynced ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
