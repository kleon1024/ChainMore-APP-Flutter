import 'dart:async';

import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(
    ez.EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('zh', 'CN')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: ProviderConfig.getInstance().getGlobal(MyApp()),
    ),
  );
}

class ScrollBehaviorNoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyAppState();

}
class MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return ScrollConfiguration(
          // Remove Scroll Glow
          behavior: ScrollBehaviorNoGlow(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: ez.tr("app_title"),
//      navigatorKey: Application.getIt<NavigateService>().key,
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        tooltipTheme: TooltipThemeData(verticalOffset: -100000),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 18),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        splashFactory: NoSplashFactory(),
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: HexColor("#303030"),
        tooltipTheme: TooltipThemeData(verticalOffset: -100000),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 18),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        splashFactory: NoSplashFactory(),
      ),
      home: goPage(),
//      onGenerateRoute: Application.router.generator,
    );
  }

  Widget goPage() {
    return ProviderConfig.getInstance().getMainPage();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(
        controller: controller,
        referenceBox: referenceBox,
      );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
