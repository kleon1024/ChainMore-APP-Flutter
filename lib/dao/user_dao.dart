import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/keys.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/page/main/auth_page.dart';
import 'package:chainmore/utils/shared_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class UserDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  String accessToken = "";
  String refreshToken = "";

  bool isLoggedIn = false;
  int id = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) async {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;

      this.isLoggedIn = await SharedUtil.instance.getBoolean(Keys.isLoggedIn);
      this.accessToken = await SharedUtil.instance.getString(Keys.accessToken);
      this.refreshToken =
          await SharedUtil.instance.getString(Keys.refreshToken);
      this.refreshAccessToken();

      Future.wait([]).then((value) {
        syncAll();
        refresh();
      });
    }
  }

  void refreshAccessToken() {
    print("Refresh Access Token");
    print(this.isLoggedIn);

    if (this.isLoggedIn) {
      Options options =
          Options(headers: {"Authorization": "Bearer " + refreshToken});

      ApiService.instance.refreshAccessToken(
          options: options,
          success: (data) {
            this.accessToken = data["access_token"];
            this.refreshToken = data["refresh_token"];
          },
          error: (err) {
            int statusCode = int.tryParse(err) ?? 0;
            if (statusCode == 401) {
              Navigator.of(this.context)
                  .push(new CupertinoPageRoute(builder: (ctx) {
                return AuthPage();
              }));
            }
          },
          failed: () {});
    } else {
      Navigator.of(this.context).push(new CupertinoPageRoute(builder: (ctx) {
        return AuthPage();
      }));
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
