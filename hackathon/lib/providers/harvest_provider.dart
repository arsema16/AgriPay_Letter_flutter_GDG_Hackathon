// harvest_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';

class HarvestProvider extends ChangeNotifier {
  Database? _db;
  bool _syncing = false;

  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'harvest.db');
    _db = await openDatabase(path, version: 1,
      onCreate: (db, v) => db.execute(
        'CREATE TABLE logs(id INTEGER PRIMARY KEY, amount REAL, synced INTEGER)'
      )
    );
  }

  Future<void> addLog(double amount) async {
    await _db!.insert('logs', {'amount': amount, 'synced': 0});
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchLogs() async {
    return _db!.query('logs', orderBy: 'id DESC');
  }

  Future<void> sync() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return;
    _syncing = true; notifyListeners();

    final unsynced = await _db!.query('logs', where: 'synced=0');
    for (var row in unsynced) {
      // TODO: call API to upload row['amount']
      await _db!.update('logs', {'synced': 1}, where: 'id=?', whereArgs: [row['id']]);
    }

    _syncing = false; notifyListeners();
  }

  bool get isSyncing => _syncing;
}
