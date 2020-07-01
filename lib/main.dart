import 'package:chainmore/config/provider_config.dart';
import 'file:///D:/project/ChainMore/ChainMore-APP-Flutter/lib/pages/old_main_page.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    EasyLocalization(
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

class MyApp extends StatelessWidget {
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
      title: 'ChainMore',
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
      ),
      home: goPage(),
//      onGenerateRoute: Application.router.generator,
    );
  }

  Widget goPage() {
    return ProviderConfig.getInstance().getMainPage();
  }
}
