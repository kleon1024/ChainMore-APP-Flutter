import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/page/main/domain_selection_page.dart';
import 'package:chainmore/page/main/resource_selection_page.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionCreationPageLogic {
  final CollectionCreationPageModel _model;

  CollectionCreationPageLogic(this._model);

  validateForm() {
    return _model.titleEditingController.text.trim() != "" &&
        _model.domains.length > 0 &&
        _model.domains.length <= _model.domainLimit &&
        (_model.descEditingController.text.trim() != "" ||
            _model.resources.length > 0);
  }

  onSubmit() async {
    if (_model.mode == CollectionMode.create) {
      final options = await _model.globalModel.userDao.buildOptions();
      final params = {
        "title": _model.titleEditingController.text.trim(),
        "description": _model.descEditingController.text.trim(),
        "domain_id": _model.domains.map((e) => e.id).toList()[0],
        "resources": _model.resources.map((e) => e.id).toList(),
      };

      ApiService.instance.createCollection(
          options: options,
          params: params,
          success: (CollectionBean bean) {
            ApiService.instance.collectCollection(
                options: options,
                params: {'id': bean.id},
                success: (CollectionBean remote) {
                  remote.collected = true;
                  remote.dirty_collect = false;
                  remote.dirty_modify = false;
                  DBProvider.db.createCollection(remote);
                  _model.refresh();
                  onPostProcess();
                  Utils.showToast(_model.context, tr("collection_created"));
                });
          });
    } else if (_model.mode == CollectionMode.modify) {
      final options = await _model.globalModel.userDao.buildOptions();
      final params = {
        "id": _model.collection.id,
        "title": _model.titleEditingController.text.trim(),
        "description": _model.descEditingController.text.trim(),
        "domain_id": _model.domains.map((e) => e.id).toList()[0],
        "resources": _model.resources.map((e) => e.id).toList(),
      };

      ApiService.instance.updateCollection(
          options: options,
          params: params,
          success: (CollectionBean bean) {
            ApiService.instance.collectCollection(
                options: options,
                params: {'id': bean.id},
                success: (CollectionBean remote) {
                  remote.collected = true;
                  remote.dirty_collect = false;
                  remote.dirty_modify = false;
                  DBProvider.db.updateCollection(remote);
                  _model.refresh();
                  onPostProcess();
                  Utils.showToast(_model.context, tr("collection_modified"));
                });
          });

    }
  }

  onPostProcess() {
    _model.globalModel.collectionDao.initCollections();
    _model.descEditingController.clear();
    _model.titleEditingController.clear();
    _model.domains.clear();
    _model.resources.clear();
    _model.mode = CollectionMode.create;

    Navigator.of(_model.context).pop();
  }

  onSelectDomains() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return DomainSelectionPage(
          domains: _model.domains,
          allDomains: getDomains(),
          onSelect: onSelectDomain);
    }));
  }

  onSelectResources() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return ResourceSelectionPage(model: _model);
    }));
  }

  List<DomainBean> getDomains() {
    return _model.globalModel.domainDao.getMarkedDomains();
  }

  onSelectDomain(resource, value, index) {
    if (value) {
      if (!Utils.containDomain(_model.domains, resource)) {
        if (_model.domains.length >= _model.domainLimit) {
          _model.domains.removeAt(0);
        }
        _model.domains.add(resource);
      }
    } else {
      Utils.removeDomain(_model.domains, resource);
    }
    _model.refresh();
  }

  removeDomainAt(int index) {
    _model.domains.removeAt(index);
    _model.refresh();
  }

  onSelectResource(resource, value, index) {
    if (value) {
      if (!containResource(resource)) {
        if (_model.resources.length >= _model.resourceLimit) {
          _model.resources.removeAt(0);
        }
        _model.resources.add(resource);
      }
    } else {
      removeResource(resource);
    }

    _model.refresh();
  }

  containResource(ResourceBean res) {
    for (final element in _model.resources) {
      if (element.id == res.id) {
        return true;
      }
    }
    return false;
  }

  removeResource(ResourceBean res) {
    for (int i = 0; i < _model.resources.length; i++) {
      if (_model.resources[i].id == res.id) {
        _model.resources.removeAt(i);
        break;
      }
    }
  }

  List<ResourceBean> getResources() {
    return _model.globalModel.resourceDao.getCollectedResources();
  }

  removeRefResourceAt(index) {
    _model.resources.removeAt(index);
    _model.refresh();
  }
}
