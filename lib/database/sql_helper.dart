import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE water(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        waterTaken INTEGER,
        date TEXT
      )
      """);
  }
// id: the id of a item
// title, waterTaken: name and waterTaken of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'swastha.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(int waterTaken, String date) async {
    final db = await SQLHelper.db();
    final list = await SQLHelper.getItem(date);
    if (list.length == 1) {
      final result = await SQLHelper.updateItem(
          date, waterTaken + (list[0]['waterTaken'] as int));
      return result;
    } else {
      final data = {'waterTaken': waterTaken, 'date': date};
      final id = await db.insert('water', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    }
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();

    return db.query('water', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(String date) async {
    final db = await SQLHelper.db();
    return db.query('water', where: "date = ?", whereArgs: [date], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
    String date,
    int waterTaken,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'waterTaken': waterTaken,
    };

    final result =
        await db.update('water', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("water", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
