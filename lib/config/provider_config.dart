import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
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

  MultiProvider getGlobal(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalModel>.value(value: GlobalModel()),
        ChangeNotifierProvider<ResourceDao>.value(value: ResourceDao()),
      ],
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

  ChangeNotifierProvider<ResourceCreationPageModel> getResourceCreationPage() {
    return ChangeNotifierProvider<ResourceCreationPageModel>(
      create: (context) => ResourceCreationPageModel(),
      child: ResourceCreationPage(),
    );
  }
}
