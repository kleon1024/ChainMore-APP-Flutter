import 'dart:convert';

import 'package:chainmore/models/domain.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class EditModel with ChangeNotifier {
  String _title;
  String _body;
  String _url;

  Domain _domain;

  Domain get domain => _domain;
  String get title => _title;
  String get body => _body;
  String get url => _url;

  initState() {
    if (Application.sp.containsKey('edit_state')) {
      var state = json.decode(Application.sp.getString('edit_state'));
      _title = state['title'];
      _body = state['body'];
      _domain = Domain.fromJson(state['domain']);
      _url = state['url'];
    }
  }

  setDomain(Domain domain) {
    _domain = domain;
  }

  setTitle(String title) {
    _title = title;
  }

  setBody(String body) {
    _body = body;
  }

  setUrl(String url) {
    _url = url;
  }

  reset() {
    _title = "";
    _body = "";
    _url = "";
    _domain = null;
    deleteEditState();
  }

  saveEditState() {
    var state = {
      "title" : _title,
      "body" : _body,
      "domain" : _domain,
      "url" : _url,
    };

    Application.sp.setString('edit_state', json.encode(state));
  }

  deleteEditState() {
    Application.sp.remove('edit_state');
  }

}
