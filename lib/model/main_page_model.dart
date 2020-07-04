import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/logic/home_page_logic.dart';
import 'package:chainmore/logic/main_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPageModel extends ChangeNotifier {
  MainPageLogic logic;
  BuildContext context;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CancelToken cancelToken = CancelToken();
  GlobalModel _globalModel;

  final homePage = ProviderConfig.getInstance().getHomePage();
  final explorePage = ProviderConfig.getInstance().getExplorePage();

  int currentIndex = 0;

  MainPageModel() {
    logic = MainPageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;

      /// TODO Check Version Update
      this._globalModel = globalModel;

//      refresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.mainPageModel = null;
    debugPrint("MainPageModel Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
