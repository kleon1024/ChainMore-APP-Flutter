import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/page/main/domain_selection_page.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class DomainCreationPageLogic {
  final DomainCreationPageModel _model;

  DomainCreationPageLogic(this._model);

  onSubmit() async {
    final params = {
      "title": _model.titleEditingController.text.trim(),
      "intro": _model.introEditingController.text.trim(),
      "dependeds": _model.depDomains.map((e) => e.id).toList(),
      "aggregators": _model.aggDomains.map((e) => e.id).toList(),
    };

    final options = await _model.globalModel.userDao.buildOptions();
    ApiService.instance.createDomain(
        options: options,
        params: params,
        success: (DomainBean domain) {
          ApiService.instance.markDomain(
              options: options,
              params: {'id': domain.id},
              success: (DomainBean remote) {
                remote.marked = true;
                remote.dirty_mark = false;
                DBProvider.db.createDomain(remote);
                onPostProcess();
                Utils.showToast(_model.context, tr("domain_created"));
              });
        });
  }

  onPostProcess() {
    _model.globalModel.domainDao.initDomains();
    _model.introEditingController.clear();
    _model.titleEditingController.clear();
    _model.aggDomains.clear();
    _model.depDomains.clear();

    Navigator.of(_model.context).pop();
  }

  onSelectDepDomains() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return DomainSelectionPage(
          domains: _model.depDomains,
          allDomains: getDomains(),
          onSelect: onSelectDep);
    }));
  }

  onSelectAggDomains() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return DomainSelectionPage(
          domains: _model.aggDomains,
          allDomains: getDomains(),
          onSelect: onSelectAgg);
    }));
  }

  onSelectDep(resource, value, index) {
    if (value) {
      if (!Utils.containDomain(_model.depDomains, resource)) {
        if (_model.depDomains.length >= _model.depDomainLimit) {
          _model.depDomains.removeAt(0);
        }
        _model.depDomains.add(resource);
      }
    } else {
      Utils.removeDomain(_model.depDomains, resource);
    }
    _model.refresh();
  }

  onSelectAgg(resource, value, index) {
    if (value) {
      if (!Utils.containDomain(_model.aggDomains, resource)) {
        if (_model.aggDomains.length >= _model.aggDomainLimit) {
          _model.aggDomains.removeAt(0);
        }
        _model.aggDomains.add(resource);
      }
    } else {
      Utils.removeDomain(_model.aggDomains, resource);
    }

    _model.refresh();
  }

  List<DomainBean> getDomains() {
    return _model.globalModel.domainDao.getMarkedDomains();
  }

  removeDepDomainAt(int index) {
    _model.depDomains.removeAt(index);
    _model.refresh();
  }

  removeAggDomainAt(int index) {
    _model.aggDomains.removeAt(index);
    _model.refresh();
  }

  validateForm() {
    return _model.aggDomains.length > 0 &&
        _model.aggDomains.length <= _model.aggDomainLimit &&
        _model.depDomains.length > 0 &&
        _model.depDomains.length <= _model.depDomainLimit &&
        _model.titleEditingController.text.trim() != "" &&
        _model.introEditingController.text.trim() != "";
  }
}
