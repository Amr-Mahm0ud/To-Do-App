import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int version = 1;
  static const String table = 'Tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      print('already exist');
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(
          path,
          version: version,
          onCreate: (Database db, int version) async {
            await db.execute(
              'CREATE TABLE $table('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)',
            );
          },
        );
        print('done');
      } catch (e) {
        Get.snackbar('Error', 'An error ocurred');
      }
    }
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(table, task.toJson());
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    return await _db!.delete(table);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(table);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE $table
      SET isCompleted = ?
      WHERE id =?
      ''', [1, id]);
  }
}
