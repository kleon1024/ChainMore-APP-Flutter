import 'dart:convert';
import 'dart:io';

import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/interceptors/error.dart';
import 'package:chainmore/network/interceptors/response.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
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

  //static final String baseUrl = 'http://192.168.3.5:5000';
  static final String baseUrl = 'https://api.chainmore.fun';

  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl', followRedirects: false))
      ..interceptors.add(ResponseInterceptors())
      ..interceptors.add(ErrorInterceptors(_dio));
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  static Future<Response> get(String url) async {
    Response response;
    try {
      final headers = {
        'Host': url.split('/')[2],
        'Content-Type': 'text/html; charset=utf-8',
        'Connection': 'keep-alive',
        'Transfer-Encoding': 'chunked',
        'gear': 1,
        'Access-Control-Request-Method': 'GET',
        'Origin': url.split('/').getRange(0, 3).join('/'),
        'User-Agent':
            'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50',
        'Access-Control-Request-Headers': 'range',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'Sec-Fetch-Site': 'cross-site',
        'Sec-Fetch-Mode': 'cors',
        'Referer': url,
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language': 'zh-CN,zh;q=0.9'
      };
      debugPrint(headers.toString());
      response = await _dio.request(url,
          options: Options(followRedirects: false, headers: headers, validateStatus: (status) { return status < 500; }));

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 302 || response.statusCode == 301) {
        String newUrl = response.headers['Location'][0];
        debugPrint('Redirect to ' + newUrl);
        if (newUrl.startsWith('http')) {
          return get(newUrl);
        }
      }
    } catch (e) {
      debugPrint("fuck");
      debugPrint(e.toString());
    }
    return response;
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
      } else if (e.response != null &&
          e.response.statusCode > 400 &&
          e.response.statusCode < 404) {
        relogin = true;
      } else if (refresh) {
        _reLogin(context);
      }
    } finally {
      if (context != null && isShowLoading) {
        Loading.hideLoading(context);
      }
    }

    if (context != null && response != null) {
      if (response.data["code"] == 20001) {
        Utils.showToast(context, "用户名或密码错误");
      } else if (response.data["code"] == 20100) {
        Utils.showToast(context, "邮箱已存在");
      } else if (response.data["code"] == 20101) {
        Utils.showToast(context, "用户名已存在");
      } else if (response.data["code"] == 20102) {
        Utils.showToast(context, "用户名或密码错误");
      }
    }

    if (context != null && relogin) {
      UserModel userModel = Provider.of<UserModel>(context);
      if (userModel.isLoggedIn()) {
        var res = await userModel.refreshLogin(context: context);
        if (res == null) {
          _reLogin(context);
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

  static void _reLogin(context) {
    Future.delayed(Duration(milliseconds: 200), () {
//      Application.getIt<NavigateService>().popAndPushNamed(Routes.login);
      NavigatorUtil.goLoginPage(context,
          data: LoginConfig(initial: true), clearStack: true);
      Utils.showToast(context, '登录失效，请重新登录');
    });
  }
}
