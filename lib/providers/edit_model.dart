import 'dart:convert';

import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/domain.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class EditModel with ChangeNotifier {
  String _title;
  String _body;
  String _url;

  bool _questMarked = false;

  Domain _domain;

  Set<Category> _categories;

  Domain get domain => _domain;
  String get title => _title;
  String get body => _body;
  String get url => _url;
  Set<Category> get categories => _categories;
  bool get questionMarked => _questMarked;

  initState() {
    if (Application.sp.containsKey('edit_state')) {
      var state = json.decode(Application.sp.getString('edit_state'));
      _title = state['title'];
      _body = state['body'];
      _domain = Domain.fromJson(state['domain']);
      _url = state['url'];
      _categories = state['categories'].toSet();
      _questMarked = state['question_marked'];
    } else {
      _url = "";
      _categories = Set<Category>();
    }
  }

  setDomain(Domain domain) {
    _domain = domain;
  }

  clearDomain() {
    _domain = null;
  }

  setTitle(String title) {
    _title = title;
  }

  setQuestionMarked() {
    _questMarked = true;
  }

  setBody(String body) {
    _body = body;
  }

  setUrl(String url) {
    _url = url;
  }

  addCategory(Category category) {
    _categories.add(category);
  }

  removeCategory(Category category) {
    _categories.remove(category);
  }

  clearCategory() {
    _categories.clear();
  }

  reset() {
    _title = "";
    _body = "";
    _url = "";
    _domain = null;
    _categories.clear();
    _questMarked = false;
    deleteEditState();
  }

  saveEditState() {
    var state = {
      "title" : _title,
      "body" : _body,
      "domain" : _domain,
      "url" : _url,
      "categories" : _categories.toList(),
      "question_marked" : _questMarked,
    };

    Application.sp.setString('edit_state', json.encode(state));
  }

  deleteEditState() {
    Application.sp.remove('edit_state');
  }

  hasHistory() {
    return Application.sp.containsKey('edit_state');
  }

}
