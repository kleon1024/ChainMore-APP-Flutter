import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/category_group.dart';
import 'package:chainmore/models/tab_icon_data.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/explore_page.dart';
import 'package:chainmore/pages/login_page.dart';
import 'package:chainmore/pages/user/mine_page.dart';
import 'package:chainmore/pages/workbench_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/providers/update_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/bottom_bar.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OldMainPage extends StatefulWidget {
  @override
  _OldMainPageState createState() => _OldMainPageState();
}

class _OldMainPageState extends State<OldMainPage> with TickerProviderStateMixin {
  final pageController = PageController(
    initialPage: 0,
  );

  final List<Widget> pages = [
    WorkbenchPage(),
    ExplorePage(),
  ];

  int _currentIndex = 0;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    NetUtils.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // OnResumed
    if (state == AppLifecycleState.resumed) {
      Utils.checkClipBoard(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build Main Page");

    if (!_initialized) {
      ScreenUtil.instance = ScreenUtil()..init(context);
    }

    final pageView = PageView(
      controller: pageController,
      children: pages,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
//        resizeToAvoidBottomInset: true,
        body: pageView,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: (index) {
            pageController.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_weak),
              activeIcon: Icon(Icons.center_focus_strong),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              activeIcon: Icon(Icons.open_with),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              activeIcon: Icon(Icons.exit_to_app),
              title: Container(),
            ),
          ],
//          selectedItemColor: Colors.black87,
        ),
      ),
    );
  }
}
