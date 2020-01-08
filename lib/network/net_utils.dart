import 'dart:convert';
import 'dart:io';

import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/interceptors/error.dart';
import 'package:chainmore/network/interceptors/response.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/route/routes.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../application.dart';
import '../utils/custom_log_interceptor.dart';

class NetUtils {
  static Dio _dio;
  static final String baseUrl = 'https://api.kleon.space';

  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl', followRedirects: false))
      ..interceptors.add(ResponseInterceptors())
      ..interceptors.add(ErrorInterceptors(_dio))
      ..interceptors
          .add(CustomLogInterceptor(responseBody: true, requestBody: true));
  }

  static Future<Response> request(String method, String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> data,
      Map<String, dynamic> headers,
      bool isShowLoading = true,
      bool refresh = false,
      BuildContext context}) async {
    if (context != null && isShowLoading) Loading.showLoading(context);
    String accessToken = "";
    UserModel userModel;
    if (context != null) {
      userModel = Provider.of<UserModel>(context);
      if (refresh) {
        accessToken = userModel.getRefreshToken();
      } else {
        accessToken = userModel.getAccessToken();
      }
    }

    Response response;
    Options options = Options(method: method);
    if (headers != null) {
      options.headers = headers;
    }

    if (accessToken != "") {
      options.headers["Authorization"] = "Bearer " + accessToken;
    }

    bool relogin = false;

    try {
      response = await _dio.request(url,
          queryParameters: params, data: data, options: options);
    } on DioError catch (e) {
      print(e);
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response.statusCode > 400 && e.response.statusCode < 404) {
        relogin = true;
      } else {
        return Future.error(Response(data: -1));
      }
    } finally {
      if (context != null && isShowLoading) {
        Loading.hideLoading(context);
      }
    }

    if (context != null && relogin) {
      UserModel userModel = Provider.of<UserModel>(context);
      if (userModel.isLoggedIn()) {
        var res = await userModel.refreshLogin(context: context);
        if (res == null) {
          _reLogin();
          return Future.error(Response(data: -1));
        }

        response = await request(method, url,
            params: params,
            data: data,
            headers: headers,
            context: context,
            refresh: refresh,
            isShowLoading: isShowLoading);
      }
      return response;
    } else {
      return response;
    }
  }

  static void _reLogin() {
    Future.delayed(Duration(milliseconds: 200), () {
      Application.getIt<NavigateService>().popAndPushNamed(Routes.login);
      Utils.showToast('登录失效，请重新登录');
    });
  }
}
