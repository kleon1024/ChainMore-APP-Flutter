import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/page/main/domain_path_page.dart';
import 'package:chainmore/page/main/search_page.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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
          } else if (beans.length == _model.limit) {
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

          _model.offset += 1;
          _model.elements.clear();
          _model.elements.addAll(beans);
          _model.controller
              .finishLoad(noMore: _model.noMoreLoad, success: true);
          _model.refresh();
        },
        error: (String errCode) {
          _model.controller
              .finishLoad(noMore: _model.noMoreLoad, success: false);
          _model.refresh();
        });
  }

  Future getDomainRelations() async {
    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.getDomainAggregators(
        options: options,
        params: {'id': _model.domain.id},
        success: (List<DomainBean> beans) {
          Utils.removeDomain(beans, _model.domain);
          _model.aggDomains.clear();
          _model.aggDomains.addAll(beans);
        });

    ApiService.instance.getDomainDependeds(
        options: options,
        params: {'id': _model.domain.id, 'distance': 1},
        success: (List<DomainBean> beans) {
          Utils.removeDomain(beans, _model.domain);
          _model.depDomains.clear();
          _model.depDomains.addAll(beans);
        });
  }

  onExit() {
    _model.offset = 1;
    _model.domain = null;
    _model.noMoreLoad = false;
    _model.elements.clear();
  }

  editDomain() {
    final domainModel = Provider.of<DomainCreationPageModel>(_model.context);
    domainModel.mode = DomainState.modify;
    domainModel.setDomain(_model.domain);
    domainModel.depDomains.clear();
    domainModel.depDomains.addAll(_model.depDomains);
    domainModel.aggDomains.clear();
    domainModel.aggDomains.addAll(_model.aggDomains);

    Navigator.of(_model.context).pop();
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return DomainCreationPage();
    }));
  }

  Future onLearnDomain() async {
    final options = await _model.globalModel.userDao.buildOptions();

    if (!_model.loadLearnDomains && _model.learnDomains.isEmpty) {
      _model.loadLearnDomains = true;
      ApiService.instance.getDomainDependeds(
          options: options,
          params: {'id': _model.domain.id, 'distance': 999},
          success: (List<DomainBean> beans) {
            Utils.removeDomain(beans, _model.domain);
            _model.learnDomains.clear();
            debugPrint(beans.toString());
            _model.learnDomains.addAll(beans);
            _model.loadLearnDomains = false;
            _model.refresh();
          },
        failed: () {
            _model.loadLearnDomains = false;
            _model.refresh();
        },
        error: (String errCode) {
            _model.loadLearnDomains = false;
            _model.refresh();
        }
      );
    }

    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return DomainPathPage();
    }));
  }

  Future onMarkDomain() async {

  }
}
