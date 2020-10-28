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

  onCheckUrl() {
    if (_model.checkStatus != ResourceCheckStatus.UNCHECK) return;
    String value = _model.uriEditingController.text.trim();
    if (value.isEmpty) return;
    if (value != _model.lastCheckedUrl) {
      _model.lastCheckedUrl = value;
      if (value.startsWith('http')) {
        checkUrl();
      } else {
        _model.checkStatus = ResourceCheckStatus.URL_ILLEGAL;
        _model.refresh();
      }
    }
  }

  detectTitle() async {
    String value = _model.uriEditingController.text.trim();
    if (value.isEmpty) return;
    if (!value.startsWith('http')) return;
    if (value == _model.lastDetectedUrl) return;

    if (!_model.isLoading) {
      _model.isLoading = true;
      _model.lastDetectedUrl = value;
      _model.refresh();
      WebPageParser.getData(_model.lastDetectedUrl).then((Map data) {
        if (data != null) {
          if (data.containsKey('title')) {
            _model.titleEditingController.text = data['title'];
          }
          if (data.containsKey('url')) {
            _model.uriEditingController.text = data['url'];
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
      _model.isChecking = true;
      _model.existedResource = null;
      _model.refresh();
      final options = await _model.globalModel.userDao.buildOptions();
      ApiService().checkResourceUrlExists(
        options: options,
        params: {'url': _model.lastCheckedUrl},
        success: onCheckResourceUrlSuccess,
        error: onCheckResourceUrlError,
        token: _model.cancelToken,
      );
    }
  }

  onCheckResourceUrlSuccess(List<ResourceBean> beans) async {
    final options = await _model.globalModel.userDao.buildOptions();

    if (beans.isNotEmpty) {
      final bean = beans[0];
      bean.collected = false;
      _model.existedResource = bean;
      _model.checkStatus = ResourceCheckStatus.EXISTED;
      _model.isChecking = false;

      ApiService.instance.checkCollectResource(
          options: options,
          params: {'id': _model.existedResource.id},
          success: (items) {
            if (items.isEmpty) {
              _model.existedResource.collected = false;
            } else {
              _model.existedResource.collected = true;
            }
            _model.refresh();
          });
    } else {
      _model.isChecking = false;
      _model.checkStatus = ResourceCheckStatus.NOT_EXIST;
    }

    _model.refresh();
  }

  onCheckResourceUrlError(err) {
    _model.checkStatus = ResourceCheckStatus.NET_ERR;
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

  onClickCreateButton() async {
    if (_model.checkStatus == ResourceCheckStatus.NOT_EXIST) {
      submitResource();
    }
  }

  Future submitResource() async {
    if (!_model.isSubmitting) {
      _model.isSubmitting = true;
      _model.refresh();
      if (_model.mode == ResourceMode.CREATE) {
        final resource = ResourceBean(
            title: _model.titleEditingController.text.trim(),
            url: _model.uriEditingController.text.trim(),
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
                    Utils.showToast(_model.context, tr("err_network"));
                  });
            },
            error: (err) {
              Utils.showToast(_model.context, tr("err_network"));
            });
      } else if (_model.mode == ResourceMode.MODIFY) {
        final resource = ResourceBean(
            id: _model.resource.id,
            title: _model.titleEditingController.text.trim(),
            url: _model.uriEditingController.text.trim(),
            external: true,
            free: !_model.isPaid,
            resource_type_id: _model.selectedResourceTypeId,
            media_type_id: _model.selectedMediaTypeId);

        final options = await _model.globalModel.userDao.buildOptions();

        ApiService.instance.updateResource(
            token: _model.cancelToken,
            options: options,
            params: resource.toJson(),
            success: (ResourceBean remote) {
              ApiService.instance.collectResource(
                  options: options,
                  params: resource.toJson(),
                  success: (ResourceBean bean) {
                    bean.collected = true;
                    DBProvider.db.updateResource(bean);
                    onPostProcess();
                    Utils.showToast(_model.context, tr("resource_modified"));
                  },
                  error: (err) {
                    Utils.showToast(_model.context, tr("err_network"));
                  });
            },
            error: (err) {
              Utils.showToast(_model.context, tr("err_network"));
            });
      }
    }
  }

  onPostProcess() {
    print('post process');
    _model.globalModel.resourceDao.initResources();
    _model.uriEditingController.clear();
    _model.titleEditingController.clear();
    _model.isPaid = false;

    _model.isLoading = false;
    _model.isChecking = false;
    _model.isSubmitting = false;
    _model.isCollecting = false;

    _model.checkStatus = ResourceCheckStatus.UNCHECK;

    _model.lastCheckedUrl = "";

    _model.selectedMediaTypeId = 1;
    _model.selectedResourceTypeId = 1;

    _model.mode = ResourceMode.CREATE;

    Navigator.of(_model.context).pop();
  }

  onPressCollectButton() async {
    if (!_model.isCollecting) {
      _model.isCollecting = true;
      _model.refresh();

      final options = await _model.globalModel.userDao.buildOptions();

      if (!_model.existedResource.collected) {
        ApiService.instance.collectResource(
            options: options,
            params: {'id': _model.existedResource.id},
            success: (remote) async {
              remote.collected = true;
              _model.existedResource = remote;
              final locals =
                  await DBProvider.db.getResources(_model.existedResource.id);
              if (locals.isEmpty) {
                await DBProvider.db.createResource(remote);
              } else {
                await DBProvider.db.updateResource(remote);
              }

              _model.isCollecting = false;
              _model.refresh();
            },
            error: (err) {
              Utils.showToast(_model.context, tr("err_network"));
              _model.isCollecting = false;
              _model.refresh();
            });
      } else {
        ApiService.instance.unCollectResource(
            options: options,
            params: {'id': _model.existedResource.id},
            success: (remote) async {
              remote.collected = false;
              _model.existedResource = remote;
              final locals = await DBProvider.db
                  .getCreatedResources(_model.existedResource.id);
              if (locals.isNotEmpty) {
                await DBProvider.db.updateResource(remote);
              }
              _model.isCollecting = false;
              _model.refresh();
            },
            error: (err) {
              Utils.showToast(_model.context, tr("err_network"));
              _model.isCollecting = false;
              _model.refresh();
            });
      }
    }
  }

  onClickRecheckButton() {
    print('click recheck button');
    _model.checkStatus = ResourceCheckStatus.UNCHECK;
    _model.lastCheckedUrl = '';
    onCheckUrl();
  }

  onUriValueChanged() {
    print('url changed');
    String value = _model.uriEditingController.text.trim();
    if (_model.checkStatus != ResourceCheckStatus.UNCHECK) {
      print(value);
      print(_model.lastCheckedUrl);
      if (value != _model.lastCheckedUrl) {
        _model.checkStatus = ResourceCheckStatus.UNCHECK;
        _model.refresh();
      }
    }
  }

  onUriFocusNodeChanged() {
    if (!_model.uriFocusNode.hasFocus) {
      onCheckUrl();
      detectTitle();
    }
  }

  urlCheckStatusStr() {
    return _model.checkStatusStrMap[_model.checkStatus];
  }
}
