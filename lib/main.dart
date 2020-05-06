import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/main_page.dart';
import 'package:chainmore/pages/splash_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/providers/update_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'utils/log_util.dart';

void main() {
  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  Application.setupLocator();
  LogUtil.init(tag: 'CHAIN_MORE');
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserModel>.value(
        value: UserModel(),
      ),
      ChangeNotifierProvider<EditModel>.value(
        value: EditModel(),
      ),
      ChangeNotifierProvider<DomainCreateModel>.value(
        value: DomainCreateModel(),
      ),
      ChangeNotifierProvider<CertifyModel>.value(
        value: CertifyModel(),
      ),
      ChangeNotifierProvider<UpdateModel>.value(
        value: UpdateModel(),
      ),
      ChangeNotifierProvider<SettingModel>.value(
        value: SettingModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class ScrollBehaviorNoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollBehaviorNoGlow(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'ChainMore',
      navigatorKey: Application.getIt<NavigateService>().key,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        splashColor: Colors.transparent,
        tooltipTheme: TooltipThemeData(verticalOffset: -100000),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: SplashPage(),
      onGenerateRoute: Application.router.generator,
    );
  }
}
