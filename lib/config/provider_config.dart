import 'package:chainmore/page/pages.dart';
import 'package:chainmore/model/models.dart';

import 'package:chainmore/pages/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderConfig {
  static ProviderConfig _instance;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ProviderConfig._internal();

  ChangeNotifierProvider<GlobalModel> getGlobal(Widget child) {
    return ChangeNotifierProvider<GlobalModel>(
      create: (context) => GlobalModel(),
      child: child,
    );
  }

  ChangeNotifierProvider<MainPageModel> getMainPage() {
    return ChangeNotifierProvider<MainPageModel>(
      create: (context) => MainPageModel(),
      child: MainPage(),
    );
  }

  ChangeNotifierProvider<HomePageModel> getHomePage() {
    debugPrint("Create Home Page Model");
    return ChangeNotifierProvider<HomePageModel>(
      create: (context) => HomePageModel(),
      child: HomePage(),
    );
  }

  ChangeNotifierProvider<ExplorePageModel> getExplorePage() {
    debugPrint("Create Explore Page Model");
    return ChangeNotifierProvider<ExplorePageModel>(
      create: (context) => ExplorePageModel(),
      child: ExplorePage(),
    );
  }
  
  ChangeNotifierProvider<SearchPageModel> getSearchPage() {
    return ChangeNotifierProvider<SearchPageModel>(
      create: (context) => SearchPageModel(),
      child: SearchPage(),
    );
  }

}
