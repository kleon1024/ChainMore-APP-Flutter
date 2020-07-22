import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/logic/collection_creation_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionCreationPageModel extends ChangeNotifier {
  CollectionCreationPageLogic logic;
  BuildContext context;

  GlobalModel globalModel;

  CollectionCreationPageModel() {
    logic = CollectionCreationPageLogic(this);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController descEditingController = TextEditingController();
  final TextEditingController titleEditingController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  double padding;

  final int maxDescLength = 256;
  final int maxTitleLength = 30;

  final List<ResourceBean> resources = [];
  final int resourceLimit = 16;
  final List<DomainBean> domains = [];
  final int domainLimit = 1;

  bool isPaid = false;
  bool isLoading = false;

  String lastUrl = "";

  int selectedMediaTypeId = 1;
  int selectedCollectionTypeId = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;
      this.padding = ScreenUtil().setWidth(15);

      Future.wait([]).then((value) {
        refresh();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    globalModel.homePageModel = null;
    debugPrint("Home Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
