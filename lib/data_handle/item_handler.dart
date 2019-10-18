import 'dart:async';

import 'package:sqflite/sqflite.dart';
import './model/item.dart';
import 'package:path/path.dart';

class ItemHandler {
  static final ItemHandler _instance = new ItemHandler.internal();

  factory ItemHandler() => _instance;

  final String tableItem = 'Item';
  final String columnId = 'id';
  final String columnText = 'text';
  final String columnTime = 'time';
  final String columnAlertTime = 'alert_time';
  final String columnCommet = 'commet';
  final String columnCategory = 'category';

  static Database _db;

  ItemHandler.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();

    return _db;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'item.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
create table $tableItem ( 
  $columnId integer primary key autoincrement, 
  $columnText text not null,
  $columnTime text not null,
  $columnAlertTime text,
  $columnCommet text,
  $columnCategory text)
''').then((v) => print('created'));
  }

  Future<Item> insert(Item item) async {
    var dbClient = await db;
    item.id = await dbClient.insert(tableItem, item.toMap());
    return item;
  }

  Future<Item> getItem(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        tableItem,
        columns: [columnId, columnText, columnTime, columnAlertTime, columnCommet, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Item.fromMap(maps.first);
    }

    return null;
  }

  Future<List> getAll() async {
    var dbClient = await db;
    List<Item> listItem;
    List<Map> listMap = await dbClient.rawQuery('SELECT * FROM $tableItem');

    for (int _i = 0; _i < listMap.length; _i++) {
      listItem[_i] = Item.fromMap(listMap[_i]);
    }
    return listItem;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableItem, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Item item) async {
    var dbClient = await db;
    return await dbClient.update(tableItem, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  } 
}