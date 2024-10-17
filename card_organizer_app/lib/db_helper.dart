import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _db;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'card_organizer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Folders (
            id INTEGER PRIMARY KEY,
            folder_name TEXT,
            card_count INTEGER DEFAULT 0,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        db.execute('''
          CREATE TABLE Cards (
            id INTEGER PRIMARY KEY,
            name TEXT,
            suit TEXT,
            image_url TEXT,
            folder_id INTEGER,
            FOREIGN KEY(folder_id) REFERENCES Folders(id)
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    final db = await database;
    return await db.query('Folders');
  }

  Future<List<Map<String, dynamic>>> getCardsForFolder(int folderId) async {
    final db = await database;
    return await db.query('Cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<void> insertCard(Map<String, dynamic> cardData) async {
    final db = await database;
    await db.insert('Cards', cardData);
    await db.rawUpdate(
      'UPDATE Folders SET card_count = card_count + 1 WHERE id = ?',
      [cardData['folder_id']],
    );
  }

  Future<void> deleteCard(int cardId) async {
    final db = await database;
    await db.delete('Cards', where: 'id = ?', whereArgs: [cardId]);
  }
}
