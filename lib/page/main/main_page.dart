import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/model/auth_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/main_page_model.dart';
import 'package:chainmore/model/models.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_resume/need_resume.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends ResumableState<MainPage> {
  @override
  void onResume() {
    final model = Provider.of<MainPageModel>(context);

    Future.wait([
      model.logic.initTextOrUrlIntent(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context)..setContext(context);
    final authPageModel = Provider.of<AuthPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final userDao = Provider.of<UserDao>(context)
      ..setContext(context, globalModel: globalModel);
    final resourceDao = Provider.of<ResourceDao>(context)
      ..setContext(context, globalModel: globalModel);
    final collectionDao = Provider.of<CollectionDao>(context)
      ..setContext(context, globalModel: globalModel);
    final domainDao = Provider.of<DomainDao>(context)
      ..setContext(context, globalModel: globalModel);
    final model = Provider.of<MainPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final searchPageModel = Provider.of<SearchPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final domainDetailPageModel = Provider.of<DomainDetailPageModel>(context)
      ..setContext(context, globalModel: globalModel);

    globalModel.setMainPageModel(model);
    globalModel.setResourceDao(resourceDao);
    globalModel.setCollectionDao(collectionDao);
    globalModel.setDomainDao(domainDao);
    globalModel.setUserDao(userDao);
    globalModel.setSearchPageModel(searchPageModel);
    globalModel.setAuthPageModel(authPageModel);

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
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          onTap: model.logic.onBottomNavigationItemTapped,
          currentIndex: model.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_weak),
              activeIcon: Icon(Icons.center_focus_strong,
                  color: Theme.of(context).textTheme.bodyText1.color),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              activeIcon: Icon(Icons.adjust,
                  color: Theme.of(context).textTheme.bodyText1.color),
              title: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
