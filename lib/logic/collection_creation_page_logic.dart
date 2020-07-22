import 'dart:convert';

import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/page/main/resource_selection_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionCreationPageLogic {
  final CollectionCreationPageModel _model;

  CollectionCreationPageLogic(this._model);

  onSelectResources() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
      return ResourceSelectionPage(model: _model);
    }));
  }

  onSelect(resource, value, index) {
    if (value) {
      if (!containResource(resource)) {
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
    for(int i  = 0; i < _model.resources.length; i++) {
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
