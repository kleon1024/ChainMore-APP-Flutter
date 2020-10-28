import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/logic/collection_detail_page_logic.dart';
import 'package:chainmore/logic/domain_detail_page_logic.dart';
import 'package:chainmore/logic/resource_detail_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ResourceDetailPageModel extends ChangeNotifier {
  ResourceDetailPageLogic logic;
  BuildContext context;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();
  final EasyRefreshController controller = EasyRefreshController();
  final appbarScrollController = ScrollController();

  CancelToken cancelToken = CancelToken();

  int limit = 10;
  int offset = 1;
  String order = "time_desc";
  bool noMoreLoad = false;

  GlobalModel globalModel;

  ResourceBean resource;

  List<CollectionBean> collections = [];

  ResourceDetailPageModel(this.resource) {
    logic = ResourceDetailPageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;

      Future.wait([
        logic.refreshCollections(),
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
    debugPrint("Domain Detail Page Model Destroyed");
  }

  void refresh() {
    debugPrint("refresh");
    notifyListeners();
  }
}
