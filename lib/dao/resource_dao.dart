import 'dart:math';

import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class ResourceDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<ResourceBean> resources = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([this.initResources()]).then((value) {
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
    List<ResourceBean> rawResources;

    if (Utils.isMocking) {
      rawResources = await Mock.getResourceBeans(3);
    } else {
      rawResources = await DBProvider.db.getAllResources();
    }

    /// Fake Data
    if (rawResources == null) return;
    resources.clear();
    resources.addAll(rawResources);
  }

  getAllResources() {
    return resources;
  }

  void refresh() {
    notifyListeners();
  }
}
