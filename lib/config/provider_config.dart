import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/domain_detail_page.dart';
import 'package:chainmore/page/pages.dart';
import 'package:chainmore/model/models.dart';
import 'package:chainmore/pages/domain/domain_detail_page.dart';
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
        ChangeNotifierProvider<CollectionDao>.value(value: CollectionDao()),
        ChangeNotifierProvider<DomainDao>.value(value: DomainDao()),
        ChangeNotifierProvider<UserDao>.value(value: UserDao()),
        ChangeNotifierProvider<SearchPageModel>.value(value: SearchPageModel()),
        ChangeNotifierProvider<ResourceCreationPageModel>.value(
            value: ResourceCreationPageModel()),
        ChangeNotifierProvider<CollectionCreationPageModel>.value(
          value: CollectionCreationPageModel()),
        ChangeNotifierProvider<DomainCreationPageModel>.value(
          value: DomainCreationPageModel()),
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
    return ChangeNotifierProvider<HomePageModel>(
      create: (context) => HomePageModel(),
      child: HomePage(),
    );
  }

  ChangeNotifierProvider<ExplorePageModel> getExplorePage() {
    return ChangeNotifierProvider<ExplorePageModel>(
      create: (context) => ExplorePageModel(),
      child: ExplorePage(),
    );
  }

  ChangeNotifierProvider<DomainDetailPageModel> getDomainDetailPage(DomainBean bean) {
    return ChangeNotifierProvider<DomainDetailPageModel>(
      create: (context) => DomainDetailPageModel(bean),
      child: DomainDetailPage(),
    );
  }
}
