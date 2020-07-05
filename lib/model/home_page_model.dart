import 'package:chainmore/logic/home_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/provider/created_resource_view_model.dart';
import 'package:chainmore/provider/view_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePageModel extends ChangeNotifier {
  HomePageLogic logic;
  BuildContext context;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();

  CancelToken cancelToken = CancelToken();

  GlobalModel _globalModel;

  List<Widget> elements = [];

  HomePageModel() {
    logic = HomePageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;

      Future.wait([
        logic.addResourceView(),
        logic.addCollectionView(),
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
    _globalModel.homePageModel = null;
    debugPrint("Home Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
