import 'dart:async';

import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/logic/home_page_logic.dart';
import 'package:chainmore/logic/main_page_logic.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainPageModel extends ChangeNotifier {
  MainPageLogic logic;
  BuildContext context;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CancelToken cancelToken = CancelToken();
  GlobalModel _globalModel;

  final homePage = ProviderConfig.getInstance().getHomePage();
  final explorePage = ProviderConfig.getInstance().getExplorePage();

  StreamSubscription intentDataStreamSubscription;

  int currentStreamCount = 0;
  int maxStreamCount = 0;

  int currentIndex = 0;

  MainPageModel() {
    logic = MainPageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;

      /// TODO Check Version Update
      this._globalModel = globalModel;

      Provider.of<ResourceCreationPageModel>(context)
        ..setContext(context, globalModel: globalModel);

      Provider.of<DomainCreationPageModel>(context)
        ..setContext(context, globalModel: globalModel);

      Provider.of<CollectionCreationPageModel>(context)
        ..setContext(context, globalModel: globalModel);

      Future.wait([
        logic.initTextOrUrlIntent(),
      ]).then((value) {
        refresh();
      });

    }
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.mainPageModel = null;
    intentDataStreamSubscription.cancel();
    debugPrint("MainPageModel Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
