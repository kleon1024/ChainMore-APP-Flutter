import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/logic/global_logic.dart';
import 'package:chainmore/model/explore_page_model.dart';

import 'package:chainmore/model/models.dart';

import 'package:flutter/material.dart';

class GlobalModel extends ChangeNotifier {
  GlobalLogic logic;
  BuildContext context;

  String appName = 'ChainMore';

  MainPageModel mainPageModel;
  HomePageModel homePageModel;
  ExplorePageModel explorePageModel;
  SearchPageModel searchPageModel;

  ResourceDao createdResourceDao;

  String currentLanguageCode;
  String currentCountryCode;
  Locale currentLocale;

  GlobalModel() {
    logic = GlobalLogic(this);
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      Future.wait([
        logic.getAppName(),
        logic.getCurrentLanguageCode(),
        logic.getCurrentCountryCode(),
      ]).then((value) {
        if (currentLanguageCode == null || currentCountryCode == null) {
          currentLocale = Localizations.localeOf(context);
          currentLanguageCode = currentLocale.languageCode;
          currentCountryCode = currentLocale.countryCode;
        } else {
          currentLocale = Locale(currentLanguageCode, currentCountryCode);
        }
        refresh();
      });
    }
  }

  void setMainPageModel(MainPageModel mainPageModel) {
    if (this.mainPageModel == null) {
      this.mainPageModel = mainPageModel;
      debugPrint("Set Main Page Model [Global Model]");
    }
  }

  void setHomePageModel(HomePageModel homePageModel) {
    if (this.homePageModel == null) {
      this.homePageModel = homePageModel;
      debugPrint("Set Home Page Model [Global Model]");
    }
  }

  void setExplorePageModel(ExplorePageModel explorePageModel) {
    if (this.explorePageModel == null) {
      this.explorePageModel = explorePageModel;
      debugPrint("Set Explore Page Model [Global Model]");
    }
  }

  void setSearchPageModel(SearchPageModel searchPageModel) {
    if (this.searchPageModel == null) {
      this.searchPageModel = searchPageModel;
      debugPrint("Set Search Page Model [Global Model]");
    }
  }

  void setResourceModel(ResourceDao resourceModel) {
    if (this.createdResourceDao == null) {
      this.createdResourceDao = resourceModel;
      debugPrint("Set Resource Model [Global Model]");
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
