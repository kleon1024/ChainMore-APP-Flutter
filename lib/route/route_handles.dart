import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/main_page.dart';
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

var mainHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return MainPage();
    });

var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return HomePage();
    });

//var searchHandler = new Handler(
//    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
//      return SearchPage();
//    });
