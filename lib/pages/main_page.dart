import 'package:chainmore/models/tab_icon_data.dart';
import 'package:chainmore/pages/home/home_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              PageView(
                children: [
                  HomePage(),
                  LoginPage(),
                  HomePage(),
                  LoginPage(),
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
