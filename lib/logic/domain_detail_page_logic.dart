import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/page/main/search_page.dart';
import 'package:flutter/cupertino.dart';

class DomainDetailPageLogic {
  final DomainDetailPageModel _model;

  DomainDetailPageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return SearchPage();
    }));
  }

  Future loadCollections() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getDomainCollections(
        options: options,
        params: {
          'id': _model.domain.id,
          'offset': _model.offset,
          'limit': _model.limit,
          'order': _model.order,
        },
        success: (List<CollectionBean> beans) {
          if (beans.length < _model.limit) {
            _model.noMoreLoad = true;
          } else if (beans.length == _model.limit){
            _model.offset += 1;
          }
          _model.elements.addAll(beans);
          _model.controller
              .finishLoad(noMore: _model.noMoreLoad, success: true);
          _model.refresh();
        });
  }

  Future refreshCollections() async {
    final options = await _model.globalModel.userDao.buildOptions();

    _model.offset = 1;

    ApiService.instance.getDomainCollections(
        options: options,
        params: {
          'id': _model.domain.id,
          'offset': _model.offset,
          'limit': _model.limit,
          'order': _model.order,
        },
        success: (List<CollectionBean> beans) {
          if (beans.length < _model.limit) {
            _model.noMoreLoad = true;
          }
          _model.elements.clear();
          _model.elements.addAll(beans);
          _model.controller
              .finishLoad(noMore: _model.noMoreLoad, success: true);
          _model.refresh();
        },
        error: (String errCode) {
          _model.controller.finishLoad(noMore: _model.noMoreLoad, success: false);
          _model.refresh();
        });
  }

  onExit() {
    _model.offset = 1;
    _model.domain = null;
    _model.noMoreLoad = false;
    _model.elements.clear();
  }

}
