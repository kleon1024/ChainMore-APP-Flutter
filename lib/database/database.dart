import 'dart:async';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "chainmore.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        print("Current Version:$version");
        await db.execute("CREATE TABLE resource ("
            "local_id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "id INTEGER,"
            "title TEXT,"
            "url TEXT,"
            "external BOOLEAN,"
            "free BOOLEAN,"
            "resource_type_id INTEGER,"
            "media_type_id INTEGER,"
            "author_id INTEGER,"
            "create_time TEXT,"
            "modify_time TEXT,"
            "deleted BOOLEAN,"
            "dirty BOOLEAN,"
            "update_time TEXT"
            ");"
            "CREATE TABLE collection ("
            "local_id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "id INTEGER,"
            "title TEXT"
            ");");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print("Newer Version:$newVersion");
        print("Older Version:$oldVersion");
      },
    );
  }

  Future<List<ResourceBean>> getAllResources() async {
    final db = await database;
    var list = await db.query("resource");
    return list.map((e) => ResourceBean.fromJson(e)).toList();
  }

  Future<List<CollectionBean>> getAllCollections() async {
    final db = await database;
    var list = await db.query("collection");
    return list.map((e) => CollectionBean.fromJson(e)).toList();
  }

  Future<List<DomainBean>> getAllDomains() async {
    final db = await database;
    var list = await db.query("domain");
    return list.map((e) => DomainBean.fromJson(e)).toList();
  }
}
