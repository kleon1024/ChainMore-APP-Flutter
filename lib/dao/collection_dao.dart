import 'dart:math';

import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class CollectionDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<CollectionBean> collections = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([
        this.initResources(),
      ]).then((value) {
        refresh();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.homePageModel = null;
    debugPrint("Resource Model Destroyed");
  }

  /// Logic
  Future initResources() async {
    List<CollectionBean> rawCollections;

    if (Utils.isMocking) {
      rawCollections = await Mock.getCollectionBeans(3);
    } else {
      rawCollections = await DBProvider.db.getAllCollections();
    }

    /// Fake Data
    if (rawCollections == null) return;
    collections.clear();
    collections.addAll(rawCollections);
    debugPrint("Resource Bean Inited");
  }

  getAllResources() {
    return collections;
  }

  void refresh() {
    notifyListeners();
  }
}
