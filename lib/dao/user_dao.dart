import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class UserDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  String accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1OTUxOTc0MjYsIm5iZiI6MTU5NTE5NzQyNiwianRpIjoiZjk5YTliMWQtMzQzMC00Mjc1LTk3ODgtMGIxMjY1YmE1Y2M2IiwiZXhwIjoxNTk1MjA0NjI2LCJpZGVudGl0eSI6ImtsZW9uIiwiZnJlc2giOmZhbHNlLCJ0eXBlIjoiYWNjZXNzIn0.gI3fyXMNz4zpNKWO1TjeFrlwjHmpuuOTdwl_-y9m8v4";
  String refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1OTUxOTc0MjYsIm5iZiI6MTU5NTE5NzQyNiwianRpIjoiNDcyZTA1YjYtMzMyYS00NDliLTgzNTEtNzJjOWVmNDQwMmEzIiwiZXhwIjoxNTk3Nzg5NDI2LCJpZGVudGl0eSI6ImtsZW9uIiwidHlwZSI6InJlZnJlc2gifQ.6TzZYLWPn4LQm5ITERVrNH4k9b0xSdkFCpNm2FmLHio";

  bool isLoggedIn = false;


  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.isLoggedIn = false;
      this.context = context;
      this._globalModel = globalModel;
      this.isLoggedIn = true;
//      Future.wait([
//
//      ]).then((value) {
//        refresh();
//      });

    }
  }

  Options buildOptions(BuildContext context) {
    if(this.isLoggedIn) {
      Options options = Options(
          headers: {"Authorization": "Bearer " + accessToken});
      return options;
    } else {
      /// TODO refresh or login
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.homePageModel = null;
    debugPrint("User Dao Destroyed");
  }


  void refresh() {
    notifyListeners();
  }

}
