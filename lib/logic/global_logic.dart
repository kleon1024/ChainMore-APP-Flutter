import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/config/keys.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource_media_bean.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/shared_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalLogic {
  final GlobalModel _model;

  GlobalLogic(this._model);

  Future getCurrentLanguageCode() async {
    final languageCode =
        await SharedUtil.instance.getString(Keys.currentLanguageCode);
    if (languageCode == null) return;
    if (languageCode == _model.currentLanguageCode) return;
    _model.currentLanguageCode = languageCode;
  }

  Future getCurrentCountryCode() async {
    final countryCode =
        await SharedUtil.instance.getString(Keys.currentCountryCode);
    if (countryCode == null) return;
    if (countryCode == _model.currentLanguageCode) return;
    _model.currentLanguageCode = countryCode;
  }

  Future getAppName() async {
    final appName = await SharedUtil.instance.getString(Keys.appName);
    if (appName == null) return;
    if (appName == _model.appName) return;
    _model.appName = appName;
  }

  Future getResourceMediaType() async {
    final beans = await DBProvider.db.getAllTypes();
    generateTypeMap(beans);
  }

  Future getResourceMediaTypeRemote() async {
    ApiService.instance.getResourceMediaType(
        success: (List<ResourceMediaBean> beans) async {
          generateTypeMap(beans);

          DBProvider.db.createTypes(beans);
        },
        error: (String errCode) {});
  }

  void generateTypeMap(List<ResourceMediaBean> beans) {
    print(beans);
    _model.resourceTypeMap.clear();
    _model.resourceTypeIdMap.clear();
    _model.mediaTypeMap.clear();
    _model.mediaTypeIdMap.clear();
    _model.resourceMediaMap.clear();

    beans.forEach((e) {
      _model.resourceTypeMap[e.resource_name] = e.resource_id;
      _model.resourceTypeIdMap[e.resource_id] = e.resource_name;
      _model.mediaTypeMap[e.media_name] = e.media_id;
      _model.mediaTypeIdMap[e.media_id] = e.media_name;
      if (_model.resourceMediaMap.containsKey(e.resource_name)) {
        _model.resourceMediaMap[e.resource_name].add(e.media_name);
      } else {
        _model.resourceMediaMap[e.resource_name] = [e.media_name];
      }
    });

    generateLanguageMap();
  }

  generateLanguageMap() {
    _model.resourceTypeMap.forEach((key, value) {
      _model.resourceLanguageMap[tr(key)] = key;
    });

    _model.mediaTypeMap.forEach((key, value) {
      _model.mediaLanguageMap[tr(key)] = key;
    });

    _model.resourceMediaMap.forEach((key, value) {
      _model.resourceMediaList.add({tr(key): value.map((e) => tr(e)).toList()});
    });
  }

  int getMediaTypeId(String type) {
    return _model.mediaTypeMap[_model.mediaLanguageMap[type]];
  }

  int getResourceTypeId(String type) {
    return _model.resourceTypeMap[_model.resourceLanguageMap[type]];
  }

  String getMediaTypeStr(int id) {
    return _model.mediaTypeIdMap[id];
  }

  String getResourceTypeStr(int id) {
    return _model.resourceTypeIdMap[id];
  }
}
