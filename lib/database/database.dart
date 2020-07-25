import 'dart:async';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';
import 'package:chainmore/utils/utils.dart';
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
            "title TEXT,"
            "description TEXT,"
            "author_id INTEGER,"
            "head_id INTEGER,"
            "reply_id INTEGER,"
            "domain_id INTEGER,"
            "domain_title TEXT,"
            "indicator TEXT,"
            "type_id INTEGER,"
            "create_time TEXT,"
            "modify_time TEXT,"
            "deleted BOOLEAN,"
            "dirty_collect BOOLEAN DEFAULT false,"
            "dirty_modify BOOLEAN DEFAULT false,"
            "collected BOOLEAN DEFAULT false"
            ");");

        await db.execute("CREATE TABLE domain ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "intro TEXT,"
            "creator_id INTEGER,"
            "create_time TEXT,"
            "modify_time TEXT,"
            "deleting BOOLEAN DEFAULT false,"
            "deleted BOOLEAN DEFAULT false,"
            "dirty_collect BOOLEAN DEFAULT false,"
            "dirty_mark BOOLEAN DEFAULT false,"
            "marked BOOLEAN DEFAULT false,"
            "certified BOOLEAN DEFAULT false"
            ");");

        await db.execute("CREATE TABLE type ("
            "id INTEGER PRIMARY KEY,"
            "media_id INTEGER,"
            "media_name TEXT,"
            "resource_id INTEGER,"
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
    var list = await db.query("resource",
        orderBy: "modify_time DESC", where: "collected = ?", whereArgs: [1]);
    return list
        .map(
            (e) => ResourceBean.fromJson(Utils.sqlIntToBool(e, ResourceBean())))
        .toList();
  }

  Future<List<ResourceBean>> getAllResources() async {
    final db = await database;
    var list = await db.query("resource", orderBy: "modify_time DESC");
    return list
        .map(
            (e) => ResourceBean.fromJson(Utils.sqlIntToBool(e, ResourceBean())))
        .toList();
  }

  Future<List<ResourceBean>> getCreatedResources(int id) async {
    final db = await database;
    var list =
        await db.query("resource", where: "author_id = ?", whereArgs: [id]);
    return list
        .map(
            (e) => ResourceBean.fromJson(Utils.sqlIntToBool(e, ResourceBean())))
        .toList();
  }

  Future<List<ResourceBean>> getResources(int id) async {
    final db = await database;
    var list = await db.query("resource", where: "id = ?", whereArgs: [id]);
    return list
        .map(
            (e) => ResourceBean.fromJson(Utils.sqlIntToBool(e, ResourceBean())))
        .toList();
  }

  Future updateResource(ResourceBean bean) async {
    final db = await database;
    await db.update("resource", Utils.sqlBoolToInt(bean.toJson()),
        where: "id = ?", whereArgs: [bean.id]);
    debugPrint("Update Resource:${bean.toJson()}");
  }

  Future updateResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.update("resource", Utils.sqlBoolToInt(bean.toJson()),
          where: "id = ?", whereArgs: [bean.id]);
    });
    final results = await batch.commit();
    debugPrint("Update Resources$results");
  }

  Future createResource(ResourceBean bean) async {
    final db = await database;
    await db.insert("resource", Utils.sqlBoolToInt(bean.toJson()));
    debugPrint("Update Resource:${bean.toJson()}");
  }

  Future createResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.insert("resource", Utils.sqlBoolToInt(bean.toJson()));
    });
    final results = await batch.commit();
    debugPrint("Create Resources$results");
  }

  Future removeResources(List<ResourceBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.delete("resource", where: "id = ?", whereArgs: [bean.id]);
    });
    await batch.commit();
  }

  Future removeResource(ResourceBean bean) async {
    final db = await database;
    await db.delete("resource", where: "id = ?", whereArgs: [bean.id]);
  }

  Future createTypes(List<ResourceMediaBean> beans) async {
    final db = await database;

    db.delete("type");

    final batch = db.batch();
    for (var bean in beans) {
      batch.insert("type", Utils.sqlBoolToInt(bean.toJson()));
    }

    final results = await batch.commit();
    debugPrint("Create Resource Media Result:$results");
  }

  Future<List<ResourceMediaBean>> getAllTypes() async {
    final db = await database;
    var list = await db.query("type");
    return list.map((e) => ResourceMediaBean.fromJson(e)).toList();
  }

  Future<List<DomainBean>> getAllDomains() async {
    final db = await database;
    var list = await db.query("domain", orderBy: "modify_time DESC");
    return list
        .map((e) => DomainBean.fromJson(Utils.sqlIntToBool(e, DomainBean())))
        .toList();
  }

  Future<List<DomainBean>> getMarkedDomains() async {
    final db = await database;
    var list = await db.query("domain", orderBy: "modify_time DESC", where: "marked = ?", whereArgs: [1]);
    return list
        .map((e) => DomainBean.fromJson(Utils.sqlIntToBool(e, DomainBean())))
        .toList();
  }

  Future createDomains(List<DomainBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.insert("domain", Utils.sqlBoolToInt(bean.toJson()));
    });
    final results = await batch.commit();
    debugPrint("Create Domains$results");
  }

  Future createDomain(DomainBean bean) async {
    final db = await database;
    await db.insert("domain", Utils.sqlBoolToInt(bean.toJson()));
    debugPrint("Update Domain:${bean.toJson()}");
  }

  Future updateDomains(List<DomainBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.update("domain", Utils.sqlBoolToInt(bean.toJson()),
          where: "id = ?", whereArgs: [bean.id]);
    });
    final results = await batch.commit();
    debugPrint("Update Domains$results");
  }

  Future updateDomain(DomainBean bean) async {
    final db = await database;
    await db.update("domain", Utils.sqlBoolToInt(bean.toJson()),
        where: "id = ?", whereArgs: [bean.id]);
    debugPrint("Update Domain:${bean.toJson()}");
  }

  Future removeDomains(List<DomainBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.delete("domain", where: "id = ?", whereArgs: [bean.id]);
    });
    await batch.commit();
  }

  Future removeDomain(DomainBean bean) async {
    final db = await database;
    await db.delete("domain", where: "id = ?", whereArgs: [bean.id]);
  }

  Future<List<CollectionBean>> getAllCollections() async {
    final db = await database;
    var list = await db.query("collection", orderBy: "modify_time DESC");
    return list
        .map((e) =>
            CollectionBean.fromJson(Utils.sqlIntToBool(e, CollectionBean())))
        .toList();
  }

  Future<List<CollectionBean>> getCollectedCollections() async {
    final db = await database;
    var list =
        await db.query("collection", orderBy: "modify_time DESC", where: "collected = ?", whereArgs: [1]);
    return list
        .map((e) =>
            CollectionBean.fromJson(Utils.sqlIntToBool(e, CollectionBean())))
        .toList();
  }

  Future createCollections(List<CollectionBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.insert("collection", Utils.sqlBoolToInt(bean.toJson()));
    });
    final results = await batch.commit();
    debugPrint("Create Collections$results");
  }

  Future createCollection(CollectionBean bean) async {
    final db = await database;
    await db.insert("collection", Utils.sqlBoolToInt(bean.toJson()));
    debugPrint("Update Collection:${bean.toJson()}");
  }

  Future updateCollections(List<CollectionBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.update("collection", Utils.sqlBoolToInt(bean.toJson()),
          where: "id = ?", whereArgs: [bean.id]);
    });
    final results = await batch.commit();
    debugPrint("Update Collections$results");
  }

  Future updateCollection(CollectionBean bean) async {
    final db = await database;
    await db.update("collection", Utils.sqlBoolToInt(bean.toJson()),
        where: "id = ?", whereArgs: [bean.id]);
    debugPrint("Update Collection:${bean.toJson()}");
  }

  Future removeCollections(List<CollectionBean> beans) async {
    final db = await database;
    final batch = db.batch();
    beans.forEach((bean) {
      batch.delete("collection", where: "id = ?", whereArgs: [bean.id]);
    });
    await batch.commit();
  }

  Future removeCollection(CollectionBean bean) async {
    final db = await database;
    await db.delete("collection", where: "id = ?", whereArgs: [bean.id]);
  }
}
