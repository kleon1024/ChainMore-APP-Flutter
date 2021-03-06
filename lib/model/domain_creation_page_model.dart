import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/logic/collection_creation_page_logic.dart';
import 'package:chainmore/logic/domain_creation_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DomainState {
  create,
  modify
}

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
  final TextEditingController introEditingController = TextEditingController();
  final FocusNode introFocusNode = FocusNode();
  double padding;

  DomainState mode = DomainState.create;

  DomainBean domain;

  final List<DomainBean> depDomains = [];
  final List<DomainBean> aggDomains = [];

  final int depDomainLimit = 8;
  final int aggDomainLimit = 1;

  final int maxTitleLength = 16;
  final int maxIntroLength = 128;

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
    debugPrint("Domain Creation Page Model Destroyed");
  }

  void setDomain(DomainBean domain) {
    this.domain = domain;
    this.titleEditingController.text = domain.title;
    this.introEditingController.text = domain.intro;
  }

  void refresh() {
    notifyListeners();
  }
}
