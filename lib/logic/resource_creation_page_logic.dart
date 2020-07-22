import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/provider/created_resource_view_model.dart';
import 'package:chainmore/struct/info_capsule.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/utils/web_page_parser.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResourceCreationPageLogic {
  final ResourceCreationPageModel _model;

  ResourceCreationPageLogic(this._model);

  onSubmit() {
    if (_model.uriFocusNode.hasFocus) return;

    String value = _model.uriEditingController.text.trim();

    if (value.isNotEmpty && value.startsWith('http')) {
      if (value != _model.lastUrl) {
        if (!_model.isLoading && !_model.isChecking) {
          _model.lastUrl = value;
          detectTitle();
          checkUrl();
        }
      } else if (_model.urlExists == tr("error_network")) {
        _model.lastUrl = value;
        detectTitle();
        checkUrl();
      }
    } else {
      _model.isUrlChecked = false;
      if (value.isNotEmpty) {
        _model.urlExists = tr("url_illegal");
      }
      _model.refresh();
    }
  }

  detectTitle() async {
    if (!_model.isLoading) {
      _model.isLoading = true;
      _model.refresh();
      WebPageParser.getData(_model.lastUrl).then((Map data) {
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

  checkUrl() async {
    if (!_model.isChecking) {
      _model.isUrlChecked = false;
      _model.isChecking = true;
      _model.bean = null;
      _model.refresh();
      ApiService().checkResourceUrlExists(
        params: {'url': _model.lastUrl},
        success: onCheckResourceUrlSuccess,
        error: onCheckResourceUrlError,
        token: _model.cancelToken,
      );
    }
  }

  onCheckResourceUrlSuccess(List<ResourceBean> beans) async {
    if (_model.uriEditingController.text.trim() != _model.lastUrl) {
      _model.isUrlChecked = false;
      _model.isChecking = false;
      _model.urlExists = tr("url_not_checked");
      _model.refresh();
      return;
    }

    final options = await _model.globalModel.userDao.buildOptions();

    if (beans.isNotEmpty) {
      final bean = beans[0];
      bean.collected = false;
      _model.bean = bean;
      _model.urlExists = tr("url_exists");
      _model.isUrlChecked = true;

      ApiService.instance.checkCollectResource(
        options: options,
        params: {'id':_model.bean.id},
        success: (items) {
          if (items.isEmpty) {
            _model.bean.collected = false;
          } else {
            _model.bean.collected = true;
          }

          _model.refresh();
        }
      );
    } else {
      _model.isUrlChecked = true;
      _model.urlExists = "";
    }

    _model.isChecking = false;
    _model.refresh();
  }

  onCheckResourceUrlError(err) {
    print("Cheking Resource Url Error");
    _model.urlExists = tr("error_network");
    _model.isChecking = false;
    _model.isUrlChecked = false;
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

  createResource() async {
    /// TODO: Make it more clear
    if (!_model.isUrlChecked) {
      if (_model.urlExists == tr("url_not_checked")) {
        onSubmit();
      }
    }

    await submitResource();
  }

  Future submitResource() async {
    final userId = _model.globalModel.userDao.id;

    final resource = ResourceBean(
        title: _model.titleEditingController.text.trim(),
        url: _model.uriEditingController.text.trim(),
        author_id: userId,
        external: true,
        free: !_model.isPaid,
        resource_type_id: _model.selectedResourceTypeId,
        media_type_id: _model.selectedMediaTypeId);

    final options = await _model.globalModel.userDao.buildOptions();

    ApiService.instance.createResource(
        token: _model.cancelToken,
        options: options,
        params: resource.toJson(),
        success: (ResourceBean remote) {
          ApiService.instance.collectResource(
              options: options,
              params: {'id': remote.id},
              success: (ResourceBean bean) {
                bean.collected = true;
                DBProvider.db.createResource(bean);
                onPostProcess();
                Utils.showToast(_model.context, tr("resource_created"));
              },
              error: (err) {
                remote.collected = true;
                remote.dirty_collect = true;
                DBProvider.db.createResource(remote);
                onPostProcess();
                Utils.showToast(
                    _model.context, tr("resource_created_but_not_collected"));
              });
        },
        error: (err) {
          resource.dirty_modify = true;
          resource.dirty_collect = true;
          resource.collected = true;
          DBProvider.db.createResource(resource);
          onPostProcess();
          Utils.showToast(_model.context, tr("resource_not_created"));
        });
  }

  onPostProcess() {
    _model.globalModel.resourceDao.initResources();
    _model.uriEditingController.clear();
    _model.titleEditingController.clear();
    _model.isPaid = false;
    _model.isLoading = false;
    _model.isChecking = false;
    _model.isUrlChecked = false;

    _model.urlExists = "";
    _model.lastUrl = "";

    _model.selectedMediaTypeId = 1;
    _model.selectedResourceTypeId = 1;

    Navigator.of(_model.context).pop();
  }

  onPressCollectButton() async {
    final options = await _model.globalModel.userDao.buildOptions();

    if (!_model.bean.collected) {
      ApiService.instance.collectResource(
          options: options,
          params: {'id': _model.bean.id},
          success: (remote) async {
            remote.collected = true;
            _model.bean = remote;
            final locals = await DBProvider.db.getResources(
                _model.bean.id);
            if (locals.isEmpty) {
              await DBProvider.db.createResource(remote);
            } else {
              await DBProvider.db.updateResource(remote);
            }

            _model.refresh();
          }
      );
    } else {
      ApiService.instance.unCollectResource(
          options: options,
          params: {'id': _model.bean.id},
          success: (remote) async {
            remote.collected = false;
            _model.bean = remote;
            final locals = await DBProvider.db.getCreatedResources(
                _model.bean.id);
            if (locals.isNotEmpty) {
              await DBProvider.db.updateResource(remote);
            }

            _model.refresh();
          }
      );
    }
  }
}
