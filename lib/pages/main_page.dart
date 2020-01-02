import 'package:chainmore/models/tab_icon_data.dart';
import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/user/mine_page.dart';
import 'package:chainmore/providers/update_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
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
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
