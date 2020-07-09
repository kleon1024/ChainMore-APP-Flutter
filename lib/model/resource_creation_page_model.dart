import 'package:chainmore/logic/resource_creation_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceCreationPageModel extends ChangeNotifier {
  ResourceCreationPageLogic logic;
  BuildContext context;

  GlobalModel globalModel;

  ResourceCreationPageModel() {
    logic = ResourceCreationPageLogic(this);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController uriEditingController = TextEditingController();
  final TextEditingController titleEditingController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode uriFocusNode = FocusNode();
  final double padding = ScreenUtil().setWidth(15);
  final int maxUriLength = 512;
  final int maxTitleLength = 30;

  bool isPaid = false;
  bool isLoading = false;
  bool isChecking = false;

  String urlExists = "";
  String lastUrl = "";

  int selectedMediaTypeId = 1;
  int selectedResourceTypeId = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;
      this.uriFocusNode.addListener(logic.onSubmit);

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
