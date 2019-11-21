import 'dart:io';

import 'package:chainmore/route/routes.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/model/user.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';

import '../application.dart';
import 'custom_log_interceptor.dart';

class NetUtils {
  static Dio _dio;
  static final String baseUrl = 'http://192.168.3.5';

  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl:3000', followRedirects: false))
      ..interceptors.add(CookieManager(cj))
      ..interceptors
          .add(CustomLogInterceptor(responseBody: true, requestBody: true));
  }

  static Future<Response> _get(
    BuildContext context,
    String url, {
    Map<String, dynamic> params,
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio.get(url, queryParameters: params);
    } on DioError catch (e) {
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response != null) {
        if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
          _reLogin();
          return Future.error(Response(data: -1));
        } else {
          return Future.value(e.response);
        }
      } else {
        return Future.error(Response(data: -1));
      }
    } finally {
      Loading.hideLoading(context);
    }
  }

  static void _reLogin() {
    Future.delayed(Duration(milliseconds: 200), () {
      Application.getIt<NavigateService>().popAndPushNamed(Routes.login);
      Utils.showToast('登录失效，请重新登录');
    });
  }

  static Future<User> login(
      BuildContext context, String username, String password) async {
    var response = await _get(context, '/v1/auth/login', params: {
      'username': username,
      'password': password,
    });

    return User.fromJson(response.data);
  }

  static logout(BuildContext context) async {
    return await _get(context, '/v1/auth/logout')
        .catchError((e) {
          Utils.showToast('登出失败');
    });
  }

  static Future<Response> refreshLogin(BuildContext context) async {
    return await _get(context, '/login/refresh', isShowLoading: false)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });
  }

}