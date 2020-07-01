import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/resource_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:flutter/cupertino.dart';

class HomePageLogic {
  final HomePageModel _model;

  HomePageLogic(this._model);

  void onSearchTap() {
    /// TODO: navigate to search page
//    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
//      return ProviderConfig.getInstance().getSearchPage();
//    }));
  }

  void updateResource(ResourceModel model) {
    if (model.resources.isNotEmpty) {
      final capsule = InfoCapsule(
          type: InfoType.ResourceType,
          updateTime: Utils.toDateTime(model.resources.first.modify_time),
          info: model.resources.first);

      insertElement(capsule);
    }
  }

  insertElement(element) {
    _model.elements.insert(0, element);
  }

  removeElement(index) {
    _model.elements.removeAt(index);
  }
}
