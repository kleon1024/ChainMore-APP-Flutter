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
  Map<int, String> _categoryMap = {};
  Set<int> _disabledCategories = Set<int>();

  List<CategoryGroup> get categoryGroups => _categoryGroups;

  Set<int> get disabledCategories => _disabledCategories;

  initState() async {
    API.getCategoryGroup().then((res) {
      _categoryGroups = res;
      _categoryGroups.forEach((categoryGroup) => categoryGroup.categories
          .forEach(
              (category) => _categoryMap[category.id] = category.category));
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

  String getCategoryString(int id) {
    return _categoryMap[id];
  }

  addDisabledCategory(int value) {
    _disabledCategories.add(value);
  }

  removeDisabledCategory(int value) {
    _disabledCategories.remove(value);
    print(_disabledCategories);
  }
}
