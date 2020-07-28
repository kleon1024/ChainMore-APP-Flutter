import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/explore_page_model.dart';
import 'package:chainmore/page/main/search_page.dart';
import 'package:flutter/cupertino.dart';

class ExplorePageLogic {
  final ExplorePageModel _model;

  ExplorePageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return SearchPage();
    }));
  }

  Future getRecommendations() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getAllDomains(
      options: options,
      success: (List<DomainBean> beans) {
        if (beans.length > 0) {
          _model.cards.clear();
          _model.cards.addAll(beans);
        }

        _model.refresh();
      }
    );
  }
}
