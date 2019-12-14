import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/main_page.dart';
import 'package:chainmore/route/route_handles.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
//import 'package:netease_cloud_music/pages/login_page.dart';
//import 'package:netease_cloud_music/route/route_handles.dart';

class Routes {
  static String root = "/";
  static String main = "/main";
  static String home = "/home";
  static String login = "/login";
  static String search = "/search";
  static String post = "/post";
  static String domain = "/domain";
  static String edit = "/edit";
  static String domainSearch = "/search/domain";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return MainPage();
    });
    router.define(root, handler: splashHandler);
    router.define(login, handler: loginHandler);
    router.define(main, handler: mainHandler);
    router.define(home, handler: homeHandler);
    router.define(search, handler: searchHandler);
    router.define(post, handler: postHandler);
    router.define(domain, handler: domainHandler);
    router.define(edit, handler: editHandler);
    router.define(domainSearch, handler: domainSearchHandler);
  }
}
