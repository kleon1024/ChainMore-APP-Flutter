import 'dart:convert';

import 'package:chainmore/models/domain.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class EditModel with ChangeNotifier {
  String _title;
  String _body;

  Domain _domain;

  Domain get domain => _domain;
  String get title => _title;
  String get body => _body;

  initState() {
    if (Application.sp.containsKey('edit_state')) {
      var state = json.decode(Application.sp.getString('edit_state'));
      _title = state['title'];
      _body = state['body'];
      _domain = state['domain'];
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

  reset() {
    _title = "";
    _body = "";
  }

  saveEditState() {
    var state = {
      "title" : _title,
      "body" : _body,
      "domain" : _domain,
    };

    Application.sp.setString('edit_state', json.encode(state));
  }

  deleteUserInfo() {
    Application.sp.remove('edit_state');
  }

}
