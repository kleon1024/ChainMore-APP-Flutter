import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/logic/auth_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AuthState {
  MAIN,
  VALIDATE_PHONE,
  SIGN_IN,
  SIGN_UP,
}

class AuthPageModel extends ChangeNotifier {
  AuthPageLogic logic;
  BuildContext context;

  GlobalModel globalModel;

  AuthPageModel() {
    logic = AuthPageLogic(this);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  final usernameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final period = Duration(seconds: 1);

  int countDown = GlobalParams.COUNT_DOWN_MAX;
  bool countDownFinished = true;

  String lastSendPhoneNumber = '';

  double padding;

  AuthState authState = AuthState.MAIN;

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
    debugPrint("Auth Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
