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

    _model.intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      _model.currentStreamCount += 1;
      if (_model.currentStreamCount <= _model.maxStreamCount) return;
      _model.maxStreamCount = _model.currentStreamCount;
      _model.currentStreamCount = 0;
      if (value != null && value != "" && value.startsWith('http')) {
        model.logic.setInitUrl(value);
        model.logic.checkUrl();
        model.logic.detectTitle();
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
      if (value != null && value != "" && value.startsWith('http')) {
        model.logic.setInitUrl(value);
        model.logic.checkUrl();
        model.logic.detectTitle();
        Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
          return ResourceCreationPage();
        }));
      } else {
        Utils.checkClipBoard(_model.context);
      }
    });
  }
}
