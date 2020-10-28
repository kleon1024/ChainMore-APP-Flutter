import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/logic/domain_detail_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class DomainDetailPageModel extends ChangeNotifier {
  DomainDetailPageLogic logic;
  BuildContext context;

  final map = {};
  final stack = [];

  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();
  final EasyRefreshController controller = EasyRefreshController();
  final appbarScrollController = ScrollController();

  CancelToken cancelToken = CancelToken();

  GlobalModel globalModel;

  List<CollectionBean> elements = [];

  final List<DomainBean> depDomains = [];
  final List<DomainBean> aggDomains = [];
  final List<DomainBean> learnDomains = [];

  bool loadLearnDomains = false;

  int limit = 10;
  int offset = 1;
  String order = "time_desc";

  bool noMoreLoad = false;

  DomainBean domain;

  DomainDetailPageModel() {
    logic = DomainDetailPageLogic(this);
  }

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    debugPrint("Domain Detail Page Model Destroyed");
  }

  void refresh() {
    debugPrint("refresh");
    notifyListeners();
  }

  void reset() {
    this.domain = null;
    this.elements.clear();
    this.depDomains.clear();
    this.aggDomains.clear();
    this.learnDomains.clear();
    this.loadLearnDomains = false;
    this.limit = 10;
    this.offset = 1;
    this.order = "time_desc";
    this.noMoreLoad = false;
  }

  void set(snapshot) {
    this.domain = DomainBean.fromJson(snapshot["domain"]);
    this.elements.addAll(List<CollectionBean>.from(
        snapshot["elements"].map((e) => CollectionBean.fromJson(e)).toList()));
    this.depDomains.addAll(List<DomainBean>.from(
        snapshot["depDomains"].map((e) => DomainBean.fromJson(e)).toList()));
    this.aggDomains.addAll(List<DomainBean>.from(
        snapshot["aggDomains"].map((e) => DomainBean.fromJson(e)).toList()));
    this.learnDomains.addAll(List<DomainBean>.from(
        snapshot["learnDomains"].map((e) => DomainBean.fromJson(e)).toList()));
    this.loadLearnDomains = snapshot["loadLearnDomains"];
    this.limit = snapshot["limit"];
    this.offset = snapshot["offset"];
    this.order = snapshot["order"];
    this.noMoreLoad = snapshot["noMoreLoad"];
  }

  void push(DomainBean bean) {
    if (this.domain != null) {
      this.stack.add(this.domain.id);
      debugPrint(this.stack.toString());
      if (this.map.containsKey(bean.id)) {
        debugPrint("set id: " + bean.id.toString());
        this.set(this.map[bean.id]);
      } else {
        debugPrint("not found id: " + bean.id.toString());
        debugPrint("reset and set to: " + bean.id.toString());
        this.map[this.domain.id] = {
          "domain": this.domain.toJson(),
          "elements": this.elements.map((e) => e.toJson()).toList(),
          "depDomains": this.depDomains.map((e) => e.toJson()).toList(),
          "aggDomains": this.aggDomains.map((e) => e.toJson()).toList(),
          "learnDomains": this.learnDomains.map((e) => e.toJson()).toList(),
          "loadLearnDomains": this.loadLearnDomains,
          "limit": this.limit,
          "offset": this.offset,
          "order": this.order,
          "noMoreLoad": this.noMoreLoad,
        };
        this.reset();
        this.domain = bean;
        this.logic.refreshCollections();
        this.logic.getDomainRelations();
      }
    } else {
      this.reset();
      this.domain = bean;
      this.logic.refreshCollections();
      this.logic.getDomainRelations();
    }
  }

  void pop() {
    if (this.stack.isNotEmpty) {
      final lastId = this.stack.removeLast();
      debugPrint("stack not empty:" + lastId.toString());
      if (this.map.containsKey(lastId)) {
        final snapshot = this.map[lastId];
        this.reset();
        debugPrint("reset to: " + lastId.toString());
        this.set(snapshot);
        this.refresh();
      }
    } else {
      this.reset();
      this.map.clear();
    }
  }
}
