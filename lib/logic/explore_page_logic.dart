
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/explore_page_model.dart';
import 'package:flutter/cupertino.dart';

class ExplorePageLogic {
  final ExplorePageModel _model;

  ExplorePageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return ProviderConfig.getInstance().getSearchPage();
    }));
  }
}