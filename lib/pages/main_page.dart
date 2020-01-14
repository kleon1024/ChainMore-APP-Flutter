import 'package:chainmore/models/category_group.dart';
import 'package:chainmore/models/tab_icon_data.dart';
import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/user/mine_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/providers/update_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  final pageController = PageController();

  Widget tabBody = Container(
    color: Colors.white,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      if (mounted) {
        EditModel editModel = Provider.of<EditModel>(context);
        editModel.initState();
        CertifyModel certifyModel = Provider.of<CertifyModel>(context);
        certifyModel.initState();
        DomainCreateModel domainCreateModel =
            Provider.of<DomainCreateModel>(context);
        domainCreateModel.initState();
        SettingModel settingModel = Provider.of<SettingModel>(context);
        settingModel.initState();
        await Utils.checkClipBoard(context: context);
        UpdateModel updateModel = Provider.of<UpdateModel>(context);
        updateModel.checkUpdate(context);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当App生命周期状态为恢复时。
    if (state == AppLifecycleState.resumed) {
      Utils.checkClipBoard(context: context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            PageView(
              children: [
                HomePage(),
                Container(),
                Container(),
                MinePage(),
              ],
              controller: pageController,
              onPageChanged: (index) => {},
            ),
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            NavigatorUtil.goEditPage(context);
          },
          changeIndex: (index) {
            pageController.jumpToPage(index);
          },
        ),
      ],
    );
  }
}
