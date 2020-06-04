import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const todoTable = 'todoList';
  static const id = 'id';
  static const name = 'name';
  static const desk = 'desk';
  static const isDeleted = 'isDeleted';

  Future<void> createTodoTable(Database db) async {
    final todoSql = '''CREATE TABLE $todoTable
    (
      $id INTEGER PRIMARY KEY,
      $name TEXT,
      $desk TEXT,
      $isDeleted BIT NOT NULL
    )''';

    await db.execute(todoSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
//      await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('todoList_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTodoTable(db);
  }
}