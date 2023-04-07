// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:testa/models/task.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? db;
  static const int version = 1;
  static const String tableName = "Remiders";
  static Future<void> initDb() async {
    if (db != null) {
      return print("error");
    }
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      String path = join(documentsDirectory.path, "Reminder.db");
      db = await openDatabase(
        path,
        version: version,
        onOpen: ((db) {}),
        onCreate: (db, version) async {
          print("creating a new one");
          await db.execute(
            "CREATE TABLE $tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING, note TEXT, date STRING,"
            "startTime STRING, endTime STRING,"
            "repeat STRING,"
            "color INTEGER,"
            "isCompleted INTEGER)",
          );
        },
      );
      print(path);

      print("Table created");
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Reminder? reminder) async {
    print("insert function called");
    return await db?.insert(tableName, reminder!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await db!.query(tableName);
  }

  static delete(Reminder reminder) async {
    print("delete function called");
    await db!.delete(tableName, where: "id=?", whereArgs: [reminder.id]);
  }

  static update(int id) async {
    print("update function called");
    return await db!
        .rawUpdate("""UPDATE Remiders SET isCompleted = ? WHERE id = ?
    """, [1, id]);
  }
}
