import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper db = DatabaseHelper();

  static Future<Database> initizateDb() async {
    databaseFactory = databaseFactoryFfi;
    var databasesPath = await databaseFactory.getDatabasesPath();
    String path = join(databasesPath, 'ecashier.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await createTables(db);
    });

    return database;
  }

  static Future<void> deleteDatabase() =>
      databaseFactory.deleteDatabase('ecashier.db');

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS Menus (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        price INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )      
      """);
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.initizateDb();
    return db.query('Menus', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.initizateDb();
    return db.query('Menus', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> insertItem(
      String? title, String? description, int? price) async {
    final db = await DatabaseHelper.initizateDb();
    final data = {'title': title, 'description': description, 'price': price};
    final res = await db.insert('Menus', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return res;
  }

  static Future<int> updateItem(
      int? id, String? title, String? description, int? price) async {
    final db = await DatabaseHelper.initizateDb();
    final data = {
      'title': title,
      'description': description,
      'price': price,
      'createdAt': DateTime.now().toString()
    };
    final res = await db.update(
      'Menus',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  static Future<void> deleteItem(int? id) async {
    final db = await DatabaseHelper.initizateDb();
    try {
      await db.delete("Menus", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
