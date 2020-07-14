import 'dart:async';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';
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
            "id INTEGER PRIMARY KEY,"
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
            "dirty_collect BOOLEAN DEFAULT false,"
            "dirty_modify BOOLEAN DEFAULT false,"
            "collected BOOLEAN DEFAULT false"
            ");");

        await db.execute("CREATE TABLE collection ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT"
            ");");

        await db.execute("CREATE TABLE domain ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "intro TEXT,"
            "deleting BOOLEAN,"
            "deleted BOOLEAN,"
            "create_time TEXT,"
            "modify_time TEXT,"
            "creator_id INTEGER"
            ");");

        await db.execute("CREATE TABLE type ("
            "media_id INTEGER PRIMARY KEY,"
            "media_name TEXT,"
            "resource_id INTEGER PRIMARY KEY,"
            "resource_name TEXT"
            ");");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print("Newer Version:$newVersion");
        print("Older Version:$oldVersion");
      },
    );
  }

  Future<List<ResourceBean>> getCollectedResources() async {
    final db = await database;
    var list = await db.query("resource", where: "collected = ?", whereArgs: [true]);
    return list.map((e) => ResourceBean.fromJson(e)).toList();
  }

  Future<List<ResourceBean>> getAllResources() async {
    final db = await database;
    var list = await db.query("resource");
    return list.map((e) => ResourceBean.fromJson(e)).toList();
  }

  Future<List<ResourceBean>> getCreatedResources(int id) async {
    final db = await database;
    var list = await db.query("resource", where: "author_id = ?", whereArgs: [id]);
    return list.map((e) => ResourceBean.fromJson(e)).toList();
  }

  Future updateResource(ResourceBean bean) async {
    final db = await database;
    await db.update("resource", bean.toJson(), where: "id = ?", whereArgs: [bean.id]);
    debugPrint("Update Resource:${bean.toJson()}");
  }

  Future updateResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.update("resource", bean.toJson(), where: "id = ?", whereArgs: [bean.id]);
    });
    final results = await batch.commit();
    debugPrint("Update Resources$results");
  }

  Future createResource(ResourceBean bean) async {
    final db = await database;
    await db.insert("resource", bean.toJson());
    debugPrint("Update Resource:${bean.toJson()}");
  }

  Future createResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.insert("resource", bean.toJson());
    });
    final results = await batch.commit();
    debugPrint("Update Resources$results");
  }
  
  Future removeResource(ResourceBean bean) async {
    final db = await database;
    await db.delete("resource", where: "id = ?", whereArgs: [bean.id]);
  }

  Future removeResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.delete("resource", where: "id = ?", whereArgs: [bean.id]);
    });
    await batch.commit();
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

  Future<List<ResourceMediaBean>> getAllTypes() async {
    final db = await database;
    var list = await db.query("type");
    return list.map((e) => ResourceMediaBean.fromJson(e)).toList();
  }

  Future createTypes(List<ResourceMediaBean> beans) async {
    final db = await database;

    db.delete("type");

    final batch = db.batch();
    for (var bean in beans) {
      batch.insert("type", bean.toJson());
    }

    final results = await batch.commit();
    debugPrint("Create Resource Media Result:$results");
  }
}
