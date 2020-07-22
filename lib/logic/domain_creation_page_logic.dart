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
            Utils.showToast(_model.context, tr("resource_created"));
          }
        );
      }
    );
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
      return DomainSelectionPage(model: _model, depend: true);
    }));
  }

  onSelectAggDomains() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return DomainSelectionPage(model: _model, aggregate: true);
    }));
  }

  onSelect(resource, value, index, dep, agg) {
    List<DomainBean> domains;
    if (dep) {
      domains = _model.depDomains;
    } else {
      domains = _model.aggDomains;
    }

    if (value) {
      if (!containDomain(domains, resource)) {
        domains.add(resource);
      }
    } else {
      removeDomain(domains, resource);
    }

    _model.refresh();
  }

  containDomain(List<DomainBean> domains, DomainBean domain) {
    for (final element in domains) {
      if (element.id == domain.id) {
        return true;
      }
    }
    return false;
  }

  removeDomain(List<DomainBean> domains, DomainBean res) {
    for (int i = 0; i < domains.length; i++) {
      if (domains[i].id == res.id) {
        domains.removeAt(i);
        break;
      }
    }
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
        _model.depDomains.length > 0 &&
        _model.titleEditingController.text.trim() != "" &&
        _model.introEditingController.text.trim() != "";
  }
}
