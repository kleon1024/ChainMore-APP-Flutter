import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/provider/created_resource_view_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:chainmore/widgets/view/collection_view.dart';
import 'package:chainmore/widgets/view/domain_view.dart';
import 'package:chainmore/widgets/view/resource_view.dart';
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

  insertElement(element) {
    _model.elements.insert(0, element);
  }

  removeElement(element) {
    _model.elements.remove(element);
  }

  Future addResourceView() async {
    /// Set to global setting
    insertElement(ResourceView(onRemove: removeElement));
  }

  Future addCollectionView() async {
    insertElement(CollectionView(onRemove: removeElement));
  }

  Future addDomainView() async {
    insertElement(DomainView(onRemove: removeElement));
  }
}
