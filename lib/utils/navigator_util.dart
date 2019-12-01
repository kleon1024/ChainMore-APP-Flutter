import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/post.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/utils/fluro_convert_utils.dart';

import '../application.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.material);
  }

  static void goLoginPage(BuildContext context, {bool clearStack = true}) {
    _navigateTo(context, Routes.login, clearStack: clearStack);
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

  static void goPostPage(BuildContext context,
  {@required Post data}) {
    _navigateTo(context,
      "${Routes.post}?data=${FluroConvertUtils.object2string(data)}");
  }

  static void goDomainPage(BuildContext context,
      {@required Domain data}) {
    _navigateTo(context,
        "${Routes.domain}?data=${FluroConvertUtils.object2string(data)}");
  }

  static void goEditPage(BuildContext context) {
    _navigateTo(context, Routes.edit);
  }
}
