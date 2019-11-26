import 'dart:convert';
import 'dart:io';

import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/interceptors/error.dart';
import 'package:chainmore/network/interceptors/response.dart';
import 'package:chainmore/route/routes.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';

import '../application.dart';
import '../utils/custom_log_interceptor.dart';

class NetUtils {
  static Dio _dio;
  static final String baseUrl = 'http://192.168.3.5';

  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl:5000', followRedirects: false))
      ..interceptors.add(ResponseInterceptors())
      ..interceptors.add(ErrorInterceptors(_dio))
      ..interceptors
          .add(CustomLogInterceptor(responseBody: true, requestBody: true));
  }

  static Future<Response> request(
      String method, BuildContext context, String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> data,
      Map<String, dynamic> headers,
      bool isShowLoading = true}) async {
    if (isShowLoading) Loading.showLoading(context);
    Response response;
    Options options = Options(method: method);
    if (headers != null) {
      options.headers = headers;
    }

    try {
      response = await _dio.request(url,
          queryParameters: params, data: data, options: options);
    } on DioError catch (e) {
      print(e);
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response != null) {
        if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
          API.reLogin();
          return Future.error(Response(data: -1));
        } else {
          return Future.error(Response(data: -1));
        }
      } else {
        return Future.error(Response(data: -1));
      }
    } finally {
      Loading.hideLoading(context);
    }

    return response;
  }
}
