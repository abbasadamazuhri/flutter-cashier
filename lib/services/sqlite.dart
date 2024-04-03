import 'package:flutter_ecashier/models/menu.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String databaseName = "database.db";
  static Database? db;

  static Future<Database> initizateDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return db ??
        await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          await createTables(db);
        });
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS Menus (
        Id TEXT NOT NULL,
        Title TEXT NOT NULL,
        Description TEXT NOT NULL,
      )      
      """);
  }

  static Future<int> createItem(Menu data) async {
    final db = await SqliteService.initizateDb();
    final id = await db.insert('Menus', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Menu>> getItems() async {
    final db = await SqliteService.initizateDb();
    final List<Map<String, Object?>> queryResult = await db.query('Menus');
    return queryResult.map((e) => Menu.fromMap(e)).toList();
  }
}
