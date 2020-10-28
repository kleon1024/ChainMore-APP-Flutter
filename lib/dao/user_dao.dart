import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/keys.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/page/main/auth/auth_page.dart';
import 'package:chainmore/utils/shared_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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

  setAccessToken(String accessToken) {
    this.accessToken = accessToken;
    SharedUtil.instance.saveString(Keys.accessToken, this.accessToken);
  }

  setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
    SharedUtil.instance.saveString(Keys.refreshToken, this.refreshToken);
  }

  setIsLoggedIn(bool isLoggedIn) {
    this.isLoggedIn = isLoggedIn;
    SharedUtil.instance.saveBoolean(Keys.isLoggedIn, this.isLoggedIn);
  }

  signIn(String username, String password) async {
    Options options = Options();
    final Map<String, String> params = {
      'username': username,
      'password': password,
    };
    await ApiService.instance.signIn(
        options: options,
        params: params,
        success: (data) {
          setAccessToken(data["access_token"]);
          setRefreshToken(data["refresh_token"]);
          setIsLoggedIn(true);
          Utils.showToast(context, tr("success_sign_in"));
        },
        error: (err) {
          int statusCode = int.tryParse(err) ?? 0;
          if (statusCode > 0) {
            Utils.showToast(context, tr("warn_sign_in_failed"));
          } else {
            Utils.showToast(context, tr("err_network"));
          }
        });
  }

  refreshAccessToken() {
    if (this.isLoggedIn) {
      Options options =
          Options(headers: {"Authorization": "Bearer " + refreshToken});

      ApiService.instance.refreshAccessToken(
          options: options,
          success: (data) {
            setAccessToken(data["access_token"]);
            setRefreshToken(data["refresh_token"]);
            setIsLoggedIn(true);
          },
          error: (err) {
            int statusCode = int.tryParse(err) ?? 0;
            if (statusCode == 401) {
              setIsLoggedIn(false);

              Navigator.of(this.context)
                  .push(new CupertinoPageRoute(builder: (ctx) {
                return AuthPage();
              }));
            }
          });
    } else {
      setIsLoggedIn(false);

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
      return Options();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.userDao = null;
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
