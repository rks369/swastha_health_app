import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:swastha/models/data_model.dart';

class SQLHelper {
  static sql.Database? _database;

  static String todayKey() => DateFormat('dd/MM/yyyy').format(DateTime.now());

  static Future<void> _createMeta(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS meta(
        key TEXT PRIMARY KEY,
        value TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return _database ??= await sql.openDatabase(
      'swastha.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await database.execute("""CREATE TABLE swastha(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        date TEXT,
        day INTEGER,
        water INTEGER,
        calories INTEGER,
        steps INTEGER,
        sleep INTEGER
      )
      """);
        await _createMeta(database);
      },
      onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
        if (oldVersion < 2) await _createMeta(database);
      },
    );
  }

  static Future<Map<String, dynamic>> _ensureToday() async {
    final db = await SQLHelper.db();
    final date = todayKey();
    final rows = await db.query(
      'swastha',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (rows.isNotEmpty) return rows.first;

    final empty = DataModel(date, DateTime.now().weekday, 0, 0, 0, 0);
    final id = await db.insert('swastha', empty.toMap());
    return {...empty.toMap(), 'id': id};
  }

  /// Adds the water, calories and sleep of [delta] to today's totals.
  static Future<void> addIntake(DataModel delta) async {
    final db = await SQLHelper.db();
    final today = await _ensureToday();
    int next(String column, int add) {
      final value = ((today[column] as int?) ?? 0) + add;
      return value < 0 ? 0 : value;
    }

    await db.update(
      'swastha',
      {
        'water': next('water', delta.water),
        'calories': next('calories', delta.calories),
        'sleep': next('sleep', delta.sleep),
      },
      where: 'id = ?',
      whereArgs: [today['id']],
    );
  }

  static Future<void> setSteps(int steps) async {
    final db = await SQLHelper.db();
    final today = await _ensureToday();
    await db.update(
      'swastha',
      {'steps': steps},
      where: 'id = ?',
      whereArgs: [today['id']],
    );
  }

  static Future<List<Map<String, dynamic>>> getTodayData() async {
    return [await _ensureToday()];
  }

  /// The most recent seven days, oldest first.
  static Future<List<Map<String, dynamic>>> getWeeklyData() async {
    await _ensureToday();
    final db = await SQLHelper.db();
    final rows = await db.query('swastha', orderBy: 'id DESC', limit: 7);
    return rows.reversed.toList();
  }

  static Future<String?> getMeta(String key) async {
    final db = await SQLHelper.db();
    final rows = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  static Future<void> setMeta(String key, String value) async {
    final db = await SQLHelper.db();
    await db.insert('meta', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
