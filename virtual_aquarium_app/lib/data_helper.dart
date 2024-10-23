import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DataHelper {
  static final DataHelper _instance = DataHelper._internal();
  factory DataHelper() => _instance;

  DataHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'aquarium.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fishCount INTEGER,
            fishColor TEXT,
            fishSpeed REAL
          )
        ''');
      },
    );
  }

  Future<void> saveSettings(int fishCount, String fishColor, double fishSpeed) async {
    final dbClient = await db;
    await dbClient.delete('settings'); // Clear previous settings
    await dbClient.insert(
      'settings',
      {
        'fishCount': fishCount,
        'fishColor': fishColor,
        'fishSpeed': fishSpeed,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final dbClient = await db;
    final settings = await dbClient.query('settings', limit: 1);
    if (settings.isNotEmpty) {
      return settings.first;
    } else {
      return null;
    }
  }
}
