import 'dart:math';

import 'package:chainmore/json/resource.dart';
import 'package:chainmore/logic/resource_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class ResourceModel extends ChangeNotifier {
  /// Model
  BuildContext context;
  ResourceLogic logic;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<ResourceBean> resources = [];

  List<ChangeNotifierCallBack> callbacks = [];

  ResourceModel() {
    logic = ResourceLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([logic.getResources()]);
    }
  }

  void registerCallback(ChangeNotifierCallBack callback) {
    callbacks.add(callback);
  }

  void traverseCallbacks() {
    callbacks.forEach((element) {
      element(this);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.homePageModel = null;
    debugPrint("Resource Model Destroyed");
  }

  /// Logic

}
