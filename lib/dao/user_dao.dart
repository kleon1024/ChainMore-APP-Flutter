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

  String accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1OTUyNDQ4NjIsIm5iZiI6MTU5NTI0NDg2MiwianRpIjoiYWI1YTU5MjEtMDA2ZC00MmM0LTllNjEtOTcyNmZlYjRhN2ZkIiwiZXhwIjoxNjA1NjEyODYyLCJpZGVudGl0eSI6ImtsZW9uIiwiZnJlc2giOmZhbHNlLCJ0eXBlIjoiYWNjZXNzIn0.NnBHekj3SHQgUmoJr5EbM8hxGDdjTzoKY2RqBWTS9fU";
  String refreshToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1OTUxOTc0MjYsIm5iZiI6MTU5NTE5NzQyNiwianRpIjoiNDcyZTA1YjYtMzMyYS00NDliLTgzNTEtNzJjOWVmNDQwMmEzIiwiZXhwIjoxNTk3Nzg5NDI2LCJpZGVudGl0eSI6ImtsZW9uIiwidHlwZSI6InJlZnJlc2gifQ.6TzZYLWPn4LQm5ITERVrNH4k9b0xSdkFCpNm2FmLHio";

  bool isLoggedIn = false;
  int id = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.isLoggedIn = false;
      this.context = context;
      this._globalModel = globalModel;
      this.isLoggedIn = true;
      Future.wait([]).then((value) {
        syncAll();
        refresh();
      });
    }
  }

  void refreshAccessToken() {
    if (this.isLoggedIn) {
      Options options =
          Options(headers: {"Authorization": "Bearer " + refreshToken});

      ApiService.instance.refreshAccessToken(
          options: options,
          success: (data) {
            this.accessToken = data["access_token"];
            this.refreshToken = data["refresh_token"];
          },
          error: (err) {},
          failed: () {});
    } else {
      /// TODO: push to login page
    }
  }

  Future<Options> buildOptions() async {
    if (this.isLoggedIn) {
      Options options =
          Options(headers: {"Authorization": "Bearer " + accessToken});
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

  Future syncAll() async {
    if (this.isLoggedIn) {
      _globalModel.resourceDao.syncResources();
      _globalModel.domainDao.syncDomains();
      _globalModel.collectionDao.syncCollections();
    }
  }
}
