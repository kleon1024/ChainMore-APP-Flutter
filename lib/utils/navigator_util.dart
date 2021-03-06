import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/domain_search.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/sparkle.dart';
import 'package:chainmore/models/web.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/utils/fluro_convert_utils.dart';

import '../application.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 500),
      RouteTransitionsBuilder transitionBuilder}) {
    return Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.native);
  }
  static goPage(BuildContext context, String path) {
    return _navigateTo(context, path);
  }

  static void goLoginPage(BuildContext context,
      {@required LoginConfig data, bool clearStack = false}) {
    _navigateTo(context,
        "${Routes.login}?data=${FluroConvertUtils.object2string(data)}",
        clearStack: clearStack);
  }

  static void goHomePage(BuildContext context) {
    _navigateTo(context, Routes.home, clearStack: true);
  }

  static void goMainPage(BuildContext context) {
    _navigateTo(context, Routes.main, clearStack: true);
  }

  static void goSearchPage(BuildContext context) {
    _navigateTo(context, Routes.search);
  }

  static void goDomainSearchPage(BuildContext context,
      {@required DomainSearchData data}) {
    _navigateTo(context,
        "${Routes.domainSearch}?data=${FluroConvertUtils.object2string(data)}");
  }

  static goDomainCertifyPage(BuildContext context, {@required Domain data}) {
    return _navigateTo(context,
        "${Routes.domainCertify}?data=${FluroConvertUtils.object2string(data)}");
  }

  static goDomainCreatePage(BuildContext context) {
    return _navigateTo(context, Routes.domainCreate);
  }

  static goPostPage(BuildContext context, {@required Post data}) {
    return _navigateTo(context,
        "${Routes.post}?data=${FluroConvertUtils.object2string(data)}");
  }

//  static void goDomainPage(BuildContext context, {@required Domain data}) {
//    _navigateTo(context,
//        "${Routes.domain}?data=${FluroConvertUtils.object2string(data)}");
//  }

  static goDomainDetailPage(BuildContext context) {
    return _navigateTo(context, Routes.domain);
  }

  static goUserPage(BuildContext context, {@required Author data}) {
    _navigateTo(context,
        "${Routes.user}?data=${FluroConvertUtils.object2string(data)}");
  }

  static goEditPage(BuildContext context) {
    return _navigateTo(context, Routes.edit);
  }

  static goWebViewPage(BuildContext context, {@required Web web}) {
    return _navigateTo(
        context, "${Routes.web}?data=${FluroConvertUtils.object2string(web)}");
  }

  static goDomainMapPage(BuildContext context, {@required Domain data}) {
    return _navigateTo(context,
        "${Routes.domainMap}?data=${FluroConvertUtils.object2string(data)}");
  }

  static goSparkleDetailPage(BuildContext context, {@required Sparkle data}) {
    return _navigateTo(context,
        "${Routes.sparkle}?data=${FluroConvertUtils.object2string(data)}");
  }

  static goExploreRoadmapPage(BuildContext context) {
    return _navigateTo(context, Routes.exploreRoadmap);
  }

  static goExploreDomainPage(BuildContext context) {
    return _navigateTo(context, Routes.exploreDomain);
  }

  static goExplorePage(BuildContext context) {
    return _navigateTo(context, Routes.explore);
  }

  static goRoadmapDetailPage(BuildContext context) {
    return _navigateTo(context, Routes.roadmap);
  }

  static goSettingPage(BuildContext context) {
    return _navigateTo(context, Routes.setting);
  }

  static goNewResourcePage(BuildContext context) {
    return _navigateTo(context, Routes.newResource);
  }

}
