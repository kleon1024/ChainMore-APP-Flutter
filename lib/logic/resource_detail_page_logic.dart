import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/collection_detail_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/model/resource_detail_page_model.dart';
import 'package:chainmore/page/main/collection_creation_page.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/page/main/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ResourceDetailPageLogic {
  final ResourceDetailPageModel _model;

  ResourceDetailPageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return SearchPage();
    }));
  }

  Future refreshCollections() async {
    final options = await _model.globalModel.userDao.buildOptions();

    _model.offset = 1;

    ApiService.instance.getResourceCollections(
        options: options,
        params: {
          'id': _model.resource.id,
          'offset': _model.offset,
          'limit': _model.limit,
          'order': _model.order
        },
        success: (List<CollectionBean> beans) {
          if (beans.length < _model.limit && beans.length > 0) {
            _model.noMoreLoad = true;
          }

          if (beans.length > 0) {
            _model.collections.clear();
            _model.collections.addAll(beans);
            _model.controller
                .finishLoad(success: true, noMore: _model.noMoreLoad);
          } else {
            _model.controller
                .finishLoad(success: false, noMore: _model.noMoreLoad);
          }

          _model.offset += 1;
          _model.refresh();
        });
  }

  Future loadCollections() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getResourceCollections(
        options: options,
        params: {'id': _model.resource.id},
        success: (List<CollectionBean> beans) {
          if (beans.length < _model.limit && beans.length > 0) {
            _model.noMoreLoad = true;
          }

          if (beans.length > 0) {
            _model.collections.addAll(beans);
            _model.controller
                .finishLoad(success: true, noMore: _model.noMoreLoad);
          } else {
            _model.controller
                .finishLoad(success: false, noMore: _model.noMoreLoad);
          }

          _model.offset += 1;
          _model.refresh();
        });
  }

  editResource() {
    final resourceModel =
        Provider.of<ResourceCreationPageModel>(_model.context);
    resourceModel.setResource(_model.resource);

    Navigator.of(_model.context).pop();
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return ResourceCreationPage();
    }));
  }
}
