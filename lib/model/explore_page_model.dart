import 'package:chainmore/logic/explore_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ExplorePageModel extends ChangeNotifier {
  ExplorePageLogic logic;
  BuildContext context;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CancelToken cancelToken = CancelToken();

  GlobalModel globalModel;

  List cards = [];

  ExplorePageModel() {
    logic = ExplorePageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;

      Future.wait([
        logic.getRecommendations(),
      ]).then((value) {
        refresh();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    if(!cancelToken.isCancelled) cancelToken.cancel();
    globalModel.explorePageModel = null;
    debugPrint("Explore Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }


}