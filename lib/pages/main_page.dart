import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/category_group.dart';
import 'package:chainmore/models/tab_icon_data.dart';
import 'package:chainmore/pages/explore_page.dart';
import 'package:chainmore/pages/home/home_page.dart';
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  final pageController = PageController(
    initialPage: 1,
  );

  int _currentIndex = 0;

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
    // OnResumed
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
    print("Rebuild Main Page");
    final pageView = PageView(
      controller: pageController,
      children: <Widget>[
        HomePage(),
        WorkbenchPage(),
        ExplorePage(),
      ],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
//        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: pageView,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: (index) {
            pageController.jumpToPage(index);
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_weak),
              activeIcon: Icon(Icons.center_focus_strong),
              title: VEmptyView(0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              title: VEmptyView(0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: VEmptyView(0),
            ),
          ],
          selectedItemColor: Colors.black87,
        ),
      ),
    );
  }
}
