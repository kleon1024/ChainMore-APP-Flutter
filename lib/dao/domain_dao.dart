import 'dart:math';

import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class DomainDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<DomainBean> domains = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([
        this.initDomains(),
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
  Future initDomains() async {
    List<DomainBean> rawDomains;

    if (Utils.isMocking) {
      rawDomains = await Mock.getDomainBeans(3);
    } else {
      rawDomains = await DBProvider.db.getAllDomains();
    }

    /// Fake Data
    if (rawDomains == null) return;
    domains.clear();
    domains.addAll(rawDomains);
    debugPrint("Domain Bean Inited");
  }

  getAllDomains() {
    return domains;
  }

  void refresh() {
    notifyListeners();
  }
}
