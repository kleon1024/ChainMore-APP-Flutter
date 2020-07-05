import 'dart:convert';

import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/provider/created_resource_view_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/utils/web_page_parser.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:chainmore/widgets/view/resource_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ResourceCreationPageLogic {
  final ResourceCreationPageModel _model;

  ResourceCreationPageLogic(this._model);

  onSubmit(String value) {
    if (!_model.isLoading &&
        value.trim().isNotEmpty &&
        value.trim().startsWith('http') &&
        value.trim() != _model.lastUrl) {

      _model.isLoading = true;
      _model.refresh();
      _model.lastUrl = value.trim();

      WebPageParser.getData(value.trim()).then((Map data) {
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
}
