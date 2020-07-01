import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/main_page_model.dart';
import 'file:///D:/project/ChainMore/ChainMore-APP-Flutter/lib/model/resource_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final resourceModel = Provider.of<ResourceModel>(context)
      ..setContext(context, globalModel: globalModel);
    final model = Provider.of<MainPageModel>(context)
      ..setContext(context, globalModel: globalModel);

    globalModel.setMainPageModel(model);
    globalModel.setResourceModel(resourceModel);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: IndexedStack(index: model.currentIndex, children: [
          model.homePage,
          model.explorePage,
        ]),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: model.logic.onBottomNavigationItemTapped,
          currentIndex: model.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_weak),
              activeIcon: Icon(Icons.center_focus_strong),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              activeIcon: Icon(Icons.adjust),
              title: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
