import 'package:chainmore/config/keys.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/main_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/utils/shared_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MainPageLogic {
  final MainPageModel _model;

  MainPageLogic(this._model);

  void onBottomNavigationItemTapped(int index) {
    _model.currentIndex = index;
    _model.refresh();
  }

  Future initTextOrUrlIntent() async {
    final model = Provider.of<ResourceCreationPageModel>(_model.context);

    _model.intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen((String value) async {
      ReceiveSharingIntent.reset();
      debugPrint("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      debugPrint(value);
      if (value != null && value != "" && value.startsWith('http')) {
        await SharedUtil.instance.saveString(Keys.lastClipBoardUrl, value);
        model.logic.setInitUrl(value);
        model.logic.onSubmit();
        Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
          return ResourceCreationPage();
        }));
      } else {
        Utils.checkClipBoard(_model.context);
      }
    }, onError: (err) {
      debugPrint(err.toString());
    });

    await ReceiveSharingIntent.getInitialText().then((String value) async {
      ReceiveSharingIntent.reset();
      debugPrint("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
      debugPrint(value);
      if (value != null && value != "" && value.startsWith('http')) {
        await SharedUtil.instance.saveString(Keys.lastClipBoardUrl, value);
        model.logic.setInitUrl(value);
        model.logic.onSubmit();
        Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
          return ResourceCreationPage();
        }));
      } else {
        Utils.checkClipBoard(_model.context);
      }
    });

  }
}
