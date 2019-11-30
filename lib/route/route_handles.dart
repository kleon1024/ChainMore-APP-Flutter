import 'package:chainmore/models/post.dart';
import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/main_page.dart';
import 'package:chainmore/pages/post_page/post_page.dart';
import 'package:chainmore/pages/splash_page.dart';
import 'package:chainmore/utils/fluro_convert_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var splashHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return SplashPage();
    });

var loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return LoginPage();
    });

var mainHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return MainPage();
    });

var homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return HomePage();
    });

var searchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return HomePage();
    });

var postHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return PostPage(Post.fromJson(FluroConvertUtils.string2map(data)));
    });
