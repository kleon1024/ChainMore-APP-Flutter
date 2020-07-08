import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/main_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context)..setContext(context);
    final resourceDao = Provider.of<ResourceDao>(context)
      ..setContext(context, globalModel: globalModel);
    final collectionDao = Provider.of<CollectionDao>(context)
      ..setContext(context, globalModel: globalModel);
    final domainDao = Provider.of<DomainDao>(context)
      ..setContext(context, globalModel: globalModel);
    final model = Provider.of<MainPageModel>(context)
      ..setContext(context, globalModel: globalModel);

    globalModel.setMainPageModel(model);
    globalModel.setResourceDao(resourceDao);
    globalModel.setCollectionDao(collectionDao);
    globalModel.setDomainDao(domainDao);

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
