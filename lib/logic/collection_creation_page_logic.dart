import 'dart:convert';

import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/page/main/resource_selection_page.dart';
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
      if (!_model.resources.contains(resource)) {
        _model.resources.add(resource);
      }
    } else {
      _model.resources.remove(resource);
    }

    _model.refresh();
  }

  List<ResourceBean> getResources() {
    return _model.globalModel.resourceDao.getAllResources();
  }

  onSubmitted(value) {}
}
