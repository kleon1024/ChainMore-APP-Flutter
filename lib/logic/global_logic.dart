import 'dart:convert';

import 'package:chainmore/config/keys.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/shared_util.dart';
import 'package:easy_localization/easy_localization.dart';
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

  Future getMediaType() async {
    final mediaTypeStr = await SharedUtil.instance.getString(Keys.resourceTypeMap);
    if (mediaTypeStr == null) return;
    final allMap = json.decode(mediaTypeStr);
    _model.resourceTypeMap = allMap["resource_type"];
    _model.resourceTypeIdMap = allMap["resource_id"];
    _model.mediaTypeMap = allMap["media_type"];
    _model.mediaTypeIdMap = allMap["media_id"];
    _model.resourceMediaMap = allMap["resource_media"];
    _model.resourceTypeMap.forEach((key, value) {
      _model.resourceLanguageMap[tr(key)] = key;
    });
    _model.mediaLanguageMap.forEach((key, value) {
      _model.mediaLanguageMap[tr(key)] = key;
    });
    _model.resourceMediaMap.forEach((key, value) {
      _model.resourceMediaList.add({tr(key): value.map((e) => tr(e)).toList()});
    });
  }

  int getMediaTypeId(String type) {
    return _model.mediaTypeIdMap[_model.mediaLanguageMap[type]];
  }

  int getResourceTypeId(String type) {
    return _model.resourceTypeIdMap[_model.resourceLanguageMap[type]];
  }

  String getMediaTypeStr(int id) {
    return _model.mediaTypeIdMap[id];
  }

  String getResourceTypeStr(int id) {
    return _model.resourceTypeIdMap[id];
  }

}
