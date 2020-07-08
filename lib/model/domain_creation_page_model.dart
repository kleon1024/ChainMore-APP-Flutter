import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/logic/collection_creation_page_logic.dart';
import 'package:chainmore/logic/domain_creation_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DomainCreationPageModel extends ChangeNotifier {
  DomainCreationPageLogic logic;
  BuildContext context;

  GlobalModel globalModel;

  DomainCreationPageModel() {
    logic = DomainCreationPageLogic(this);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController titleEditingController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final double padding = ScreenUtil().setWidth(15);

  final List<ResourceBean> resources = [];

  bool isPaid = false;
  bool isLoading = false;

  String lastUrl = "";

  int selectedMediaTypeId = 1;
  int selectedCollectionTypeId = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;

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
    debugPrint("Domain Creation Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
