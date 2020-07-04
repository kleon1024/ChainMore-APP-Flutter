
import 'package:chainmore/logic/search_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchPageModel extends ChangeNotifier {
  SearchPageLogic logic;
  BuildContext context;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CancelToken cancelToken = CancelToken();

  GlobalModel _globalModel;

  List cards = [];

  SearchPageModel() {
    logic = SearchPageLogic(this);
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
    if(!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.searchPageModel = null;
    debugPrint("Search Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }


}