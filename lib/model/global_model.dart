import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/logic/global_logic.dart';
import 'package:chainmore/model/explore_page_model.dart';

import 'package:chainmore/model/models.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalModel extends ChangeNotifier {
  GlobalLogic logic;
  BuildContext context;

  String appName = 'ChainMore';

  MainPageModel mainPageModel;
  HomePageModel homePageModel;
  ExplorePageModel explorePageModel;
  SearchPageModel searchPageModel;

  ResourceDao resourceDao;
  CollectionDao collectionDao;
  DomainDao domainDao;

  String currentLanguageCode;
  String currentCountryCode;
  Locale currentLocale;

  /// {name: id}
  Map<String, int> resourceTypeMap = {};
  /// {id: name}
  Map<int, String> resourceTypeIdMap = {};
  /// {name: id}
  Map<String, int> mediaTypeMap = {};
  /// {id: name}
  Map<int, String> mediaTypeIdMap = {};
  /// {name: media}
  Map<String, List<String>> resourceMediaMap = {};
  /// {language: language}
  Map<String, String> resourceLanguageMap = {};
  /// {language: name}
  Map<String, String> mediaLanguageMap = {};
  /// []
  List resourceMediaList = [];

  GlobalModel() {
    logic = GlobalLogic(this);
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      context.locale = Locale('zh', 'CN');

      ScreenUtil.instance = ScreenUtil()..init(context);
      NetUtils.init();

      Future.wait([
        logic.getAppName(),
        logic.getCurrentLanguageCode(),
        logic.getCurrentCountryCode(),
//        logic.getResourceMediaType(),
        logic.getResourceMediaTypeRemote(),
      ]).then((value) {
        if (currentLanguageCode == null || currentCountryCode == null) {
          currentLocale = Localizations.localeOf(context);
          currentLanguageCode = currentLocale.languageCode;
          currentCountryCode = currentLocale.countryCode;
        } else {
          currentLocale = Locale(currentLanguageCode, currentCountryCode);
        }

        refresh();

        debugPrint("Global Model Initialized");
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

  void setResourceDao(ResourceDao resourceDao) {
    if (this.resourceDao == null) {
      this.resourceDao = resourceDao;
      debugPrint("Set Resource Model [Global Model]");
    }
  }

  void setCollectionDao(CollectionDao collectionDao) {
    if (this.collectionDao == null) {
      this.collectionDao = collectionDao;
      debugPrint("Set Collection Dao [Global Model]");
    }
  }

  void setDomainDao(DomainDao domainDao) {
    if (this.domainDao == null) {
      this.domainDao = domainDao;
      debugPrint("Set Domain Dao [Global Model]");
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
