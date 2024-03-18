import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._();

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS your_table (
            id INTEGER PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertData(List<dynamic> data) async {
    final db = await database;
    final jsonData = jsonEncode(data); // Serialize the data to JSON
    await db.insert('your_table', {'data': jsonData});
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('your_table');
    return maps;
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete('your_table', where: 'id = ?', whereArgs: [id]);
  }
}
