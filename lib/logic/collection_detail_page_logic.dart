import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/collection_detail_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/page/main/collection_creation_page.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/page/main/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CollectionDetailPageLogic {
  final CollectionDetailPageModel _model;

  CollectionDetailPageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return SearchPage();
    }));
  }

  Future getResources() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getCollectionResources(
        options: options,
        params: {'id': _model.collection.id},
        success: (List<ResourceBean> beans) {
          _model.resources.addAll(beans);

          _model.refresh();
        });
  }

  Future getDomain() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getDomain(
        options: options,
        params: {'id': _model.collection.domain_id},
        success: (DomainBean bean) {
          _model.domain = bean;
        });
  }

  editCollection() {
    final collectionModel =
        Provider.of<CollectionCreationPageModel>(_model.context);
    collectionModel.mode = CollectionMode.modify;
    collectionModel.setCollection(_model.collection);
    collectionModel.domains.clear();
    if (_model.domain != null) {
      collectionModel.domains.add(_model.domain);
    }
    collectionModel.resources.clear();
    collectionModel.resources.addAll(_model.resources);

    Navigator.of(_model.context).pop();
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return CollectionCreationPage();
    }));
  }
}
