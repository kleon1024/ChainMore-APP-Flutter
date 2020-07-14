import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/provider/created_resource_view_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/utils/web_page_parser.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/view/resource_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ResourceCreationPageLogic {
  final ResourceCreationPageModel _model;

  ResourceCreationPageLogic(this._model);

  onSubmit() {
    if (_model.uriFocusNode.hasFocus) return;

    String value = _model.uriEditingController.text.trim();

    if (value.isNotEmpty &&
        value.startsWith('http') &&
        value != _model.lastUrl) {
      if (!_model.isLoading) {
        _model.lastUrl = value;
        _model.isLoading = true;
        _model.refresh();

        WebPageParser.getData(value).then((Map data) {
          print(data);

          if (data != null) {
            if (data.containsKey('title')) {
              _model.titleEditingController.text = data['title'];
            }
          }
          _model.isLoading = false;
          _model.refresh();
        }).catchError((e) {
          debugPrint(e.toString());
          _model.isLoading = false;
          _model.refresh();
        });
      }

      if (!_model.isChecking) {
        _model.lastUrl = value;
        _model.isChecking = true;
        _model.topResource = HEmptyView(0);
        _model.refresh();

        ApiService().checkResourceUrlExists(success: onCheckResourceUrlSuccess);
      }
    }
  }

  onCheckResourceUrlSuccess(List<ResourceBean> beans) {
    if (beans.isNotEmpty) {
      _model.urlExists = tr("url_exists");
      _model.topResource = Row(children: [
        Expanded(
            child: ResourceCard(
                bean: beans[0],
                elevation: 0,
                color: Theme.of(_model.context).canvasColor)),
        IconButton(
          icon: Icon(Icons.star_border),
          onPressed: () {},
        ),
      ]);
    } else {
      _model.urlExists = "";
    }

    _model.isChecking = false;
    _model.refresh();
  }

  setInitUrl(String value) {
    _model.uriEditingController.text = value;
  }

  onPaidChecked(bool value) {
    _model.isPaid = value;
    _model.refresh();
  }

  onShowPicker() {
    print(_model.globalModel.resourceMediaList);

    Utils().showPickerIcons(
      _model.context,
      _model.globalModel.resourceMediaList,
      callback: (picker, values) {
        _model.selectedResourceTypeId = _model.globalModel.logic
            .getResourceTypeId(picker.getSelectedValues()[0]);
        _model.selectedMediaTypeId = _model.globalModel.logic
            .getMediaTypeId(picker.getSelectedValues()[1]);
        _model.refresh();
      },
    );
  }

  popOut() {
    Navigator.of(_model.context).pop();
  }
}
