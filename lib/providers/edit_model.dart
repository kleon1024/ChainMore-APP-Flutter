import 'dart:convert';

import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/domain.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class EditModel with ChangeNotifier {
  String _title;
  String _body;
  String _url;
  int _id = 0;

  bool _questMarked = false;

  Domain _domain;

  Set<int> _categories;

  Domain get domain => _domain;
  String get title => _title;
  String get body => _body;
  String get url => _url;
  Set<int> get categories => _categories;
  bool get questionMarked => _questMarked;
  int get id => _id;

  initState() {
    if (Application.sp.containsKey('edit_state')) {
      var state = json.decode(Application.sp.getString('edit_state'));
      _title = state['title'];
      _body = state['body'];
      _domain = Domain.fromJson(state['domain']);
      _url = state['url'];
      _categories = state['categories'].toSet();
      _questMarked = state['question_marked'];
      _id = state['id'];
    } else {
      _url = "";
      _categories = Set<int>();
    }
  }

  setId(int id) {
    assert(id > 0);
    _id = id;
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

  addCategory(int id) {
    _categories.add(id);
  }

  removeCategory(int id) {
    _categories.remove(id);
  }

  setCategories(List<int> categories) {
    _categories = categories.toSet();
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
    _id = 0;
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
      "id" : _id,
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
