import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/splash_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return SplashPage();
    });

var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return LoginPage();
    });
//
//// 跳转到主页
//var homeHandler = new Handler(
//    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
//      return HomePage();
//    });
//
//// 跳转到搜索页面
//var searchHandler = new Handler(
//    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
//      return SearchPage();
//    });
