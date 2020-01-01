import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/domain_search.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/sparkle.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/pages/domain/create_domain_page.dart';
import 'package:chainmore/pages/domain/domain_certify_page.dart';
import 'package:chainmore/pages/domain/domain_map_page.dart';
import 'package:chainmore/pages/domain/domain_page.dart';
import 'package:chainmore/pages/edit/edit_page.dart';
import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_detail_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/main_page.dart';
import 'package:chainmore/pages/post/post_page.dart';
import 'package:chainmore/pages/search/domain_search_page.dart';
import 'package:chainmore/pages/search/search_page.dart';
import 'package:chainmore/pages/splash_page.dart';
import 'package:chainmore/pages/user/user_page.dart';
import 'package:chainmore/pages/webview/web_view_page.dart';
import 'package:chainmore/utils/fluro_convert_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var splashHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return SplashPage();
});

var loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return LoginPage(LoginConfig.fromJson(FluroConvertUtils.string2map(data)));
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
  return SearchPage();
});

var domainSearchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return DomainSearchPage(
      DomainSearchData.fromJson(FluroConvertUtils.string2map(data)));
});

var domainCertifyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return DomainCertifyPage(Domain.fromJson(FluroConvertUtils.string2map(data)));
});

var domainCreateHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return CreateDomainPage();
});

var postHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return PostPage(Post.fromJson(FluroConvertUtils.string2map(data)));
});

var domainHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return DomainPage(Domain.fromJson(FluroConvertUtils.string2map(data)));
});

var domainMapHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return DomainMapPage(Domain.fromJson(FluroConvertUtils.string2map(data)));
    });

var webHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return WebViewPage(web: Web.fromJson(FluroConvertUtils.string2map(data)));
    });

var editHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return EditPage();
});

var userHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return UserPage(Author.fromJson(FluroConvertUtils.string2map(data)));
    });

var sparkleHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return SparkleDetailPage(Sparkle.fromJson(FluroConvertUtils.string2map(data)));
    });
