import 'dart:async';

import 'package:sqflite/sqflite.dart';
import './model/item.dart';
import 'package:path/path.dart';

class ItemHandler {
  factory ItemHandler() => new ItemHandler.internal();
  Database _db;

  final String tableItem = 'Item';
  final String columnId = 'id';
  final String columnText = 'text';
  final String columnTime = 'time';
  final String columnAlertTime = 'alert_time';
  final String columnAlert = 'alert';
  final String columnCommet = 'commet';
  final String columnCategory = 'category';

  ItemHandler.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await open();

    return _db;
  }

  Future open() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'item.db');

    var db = await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute('''
CREATE TABLE $tableItem(
  $columnId INTEGER PRIMARY KEY AUTO_INCREMENT, 
  $columnText TEXT NOT NULL, 
  $columnTime TEXT NOT NULL, 
  $columnAlertTime TEXT, 
  $columnAlert INTEGER, 
  $columnCommet TEXT, 
  $columnCategory TEXT)
''');
    });

    return db;
  }

  Future<Item> insert(Item item) async {
    var _db = await db;
    item.id = await _db.insert(tableItem, item.toMap());
    return item;
  }

  Future<int> getCount() async {
    var _db = await db;
    return Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM $tableItem'));
  }

  Future<Item> getItem(int id) async {
    var _db = await db;
    List<Map> result = await _db.query(tableItem,
        columns: [columnId, columnText, columnTime, columnAlertTime, columnAlert, columnCommet, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return Item.fromSql(result.first);
    }

    return null;
  }

  Future<List<Item>> getAll() async {
    var _db = await db;
    List<Item> listItem = [];
    List<Map> listMap = await _db.rawQuery('SELECT * FROM $tableItem');

    listMap.forEach((item) => listItem.add(Item.fromMap(item)));
    return listItem;
  }

  Future<int> delete(int id) async {
    var _db = await db;
    return await _db.delete(tableItem, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteALL() async {
    var _db = await db;
    return await _db.delete(tableItem, where: '1 = 1');
  }

  Future<int> update(Item item) async {
    var _db = await db;
    return await _db.update(tableItem, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var _db = await db;
    _db.close();
  }
}
