import 'dart:convert';

import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class DomainCreateModel with ChangeNotifier {
  String _title;
  String _bio;
  String _description;

  Domain _aggregateDomain;
  Domain _dependentDomain;

  int _domain = 0;

  Domain get aggregateDomain => _aggregateDomain;
  Domain get dependentDomain => _dependentDomain;
  String get title => _title;
  String get bio => _bio;
  String get description => _description;
  int get domain => _domain;

  initState() {
    if (Application.sp.containsKey('domain_create_state')) {
      var state = json.decode(Application.sp.getString('domain_create_state'));
      _title = state['title'];
      _bio = state['bio'];
      _description = state['description'];
      _aggregateDomain = Domain.fromJson(state['aggregate_domain']);
      _dependentDomain = Domain.fromJson(state['depenedent_domain']);
    }
  }

  createDomain(BuildContext context) async {

    if (_aggregateDomain == null) {
      Utils.showToast(context, "请选择聚合领域");
      return false;
    }
    if (_domain > 0 && _aggregateDomain.id == _domain) {
      Utils.showToast(context, "不能聚合自身");
      return false;
    }
    if (_dependentDomain == null) {
      Utils.showToast(context, "请选择前置领域");
      return false;
    }
    if (_domain > 0 && _dependentDomain.id == _domain) {
      Utils.showToast(context, "不能依赖自身");
      return false;
    }

    var data = {
      "title": _title,
      "depended": _dependentDomain.id,
      "aggregator": _aggregateDomain.id,
    };

    if (_bio != null && _bio != "") {
      data["bio"] = _bio;
    }
    if (_description != null && _description != "") {
      data["description"] = _description;
    }

    if (_domain <= 0) {
      var response = await API.createDomain(context, data: data);
      if (response != null) {
        if (response.data["code"] == 20000) {
          Utils.showToast(context, "创建成功");
          return true;
        } else if (response.data["code"] == 20200) {
          Utils.showToast(context, "领域已存在");
          return false;
        }
      } else {
        Utils.showToast(context, "创建失败");
      }
    } else {
      data["domain"] = _domain;
      var response = await API.updateDomain(context, data: data);
      if (response != null) {
        if (response.data["code"] == 20000) {
          Utils.showToast(context, "更新成功");
          return true;
        } else if (response.data["code"] == 30001) {
          Utils.showToast(context, "不能聚合子领域");
          return false;
        } else if (response.data["code"] == 30002) {
          Utils.showToast(context, "前置依赖不能成环");
        }
      } else {
        Utils.showToast(context, "更新失败");
      }
    }

    return false;
  }

  setAggregateDomain(Domain domain) {
    _aggregateDomain = domain;
  }

  setDependentDomain(Domain domain) {
    _dependentDomain = domain;
  }

  setTitle(String title) {
    _title = title;
  }

  setBio(String bio) {
    _bio = bio;
  }

  setId(int domain) {
    _domain = domain;
  }

  setDescription(String description) {
    _description = description;
  }

  reset() {
    _title = "";
    _bio = "";
    _description = "";
    _aggregateDomain = null;
    _dependentDomain = null;
    deleteState();
  }

  saveState() {
    var state = {
      "title" : _title,
      "bio" : _bio,
      "description" : _description,
      "aggregate_domain" : _aggregateDomain,
      "dependent_domain" : _dependentDomain,
    };

    Application.sp.setString('domain_create_state', json.encode(state));
  }

  deleteState() {
    Application.sp.remove('domain_create_state');
  }

  hasHistory() {
    return Application.sp.containsKey('domain_create_state');
  }

}
