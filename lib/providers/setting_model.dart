import 'dart:convert';

import 'package:chainmore/models/category_group.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/update.dart';
import 'package:chainmore/network/apis.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class SettingModel with ChangeNotifier {
  List<CategoryGroup> _categoryGroups;

  List<CategoryGroup> get categoryGroups => _categoryGroups;

  initState() async {
    API.getCategoryGroup().then((res) {
      _categoryGroups = res;
    });
  }

  getCategory(String category) {
    for (int i = 0; i < _categoryGroups.length; ++i) {
      for (int j = 0; j < _categoryGroups[i].categories.length; ++j) {
        if (_categoryGroups[i].categories[j].category == category) {
          return _categoryGroups[i].categories[j];
        }
      }
    }
  }
}
