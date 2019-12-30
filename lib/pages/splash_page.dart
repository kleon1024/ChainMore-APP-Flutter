import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    NetUtils.init();
    goPage();
  }

  void goPage() async {
    await Application.initSp();
    UserModel userModel = Provider.of<UserModel>(context);
    EditModel editModel = Provider.of<EditModel>(context);
    DomainCreateModel domainCreateModel = Provider.of<DomainCreateModel>(context);
    CertifyModel certifyModel = Provider.of<CertifyModel>(context);
    userModel.initUser();
    editModel.initState();
    domainCreateModel.initState();
    certifyModel.initState();
    if (userModel.user != null) {
      userModel.refreshLogin(context : context).then((value) {
        if (value != null) {
          NavigatorUtil.goMainPage(context);
        }
      });
    }
    if (userModel.getRefreshToken() == "" || userModel.getAccessToken() == "") {
      userModel.reset();
      NavigatorUtil.goLoginPage(context, data: LoginConfig(initial: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
    final size = MediaQuery.of(context).size;
    Application.screenWidth = size.width;
    Application.screenHeight = size.height;
    Application.statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
