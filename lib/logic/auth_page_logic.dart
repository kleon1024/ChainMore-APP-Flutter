import 'dart:async';
import 'dart:convert';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/auth_page_model.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/page/main/domain_selection_page.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class AuthPageLogic {
  final AuthPageModel _model;

  AuthPageLogic(this._model);

  onClickSignInButton() async {
    if (_model.formKey.currentState.validate()) {
      if (!_model.isSigningIn) {
        _model.isSigningIn = true;
        _model.refresh();
        await _model.globalModel.userDao.signIn(
            _model.usernameController.text.trim(),
            _model.passwordController.text.trim());
        _model.isSigningIn = false;
        _model.refresh();
        if (_model.globalModel.userDao.isLoggedIn) {
          Navigator.of(_model.context).pop();
        }
      }
    }
  }

  String validatePhoneNumber(String value) {
    if (value.isEmpty) return tr('warning_phone_number_empty');
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) return tr('warning_phone_number_illegal');
    return null;
  }

  String validateUserName(String value) {
    if (value.isEmpty) return tr('warning_user_name_empty');
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return tr('warning_password_empty');
    return null;
  }

  validationTimerCountDown() {
    Timer.periodic(_model.period, (timer) {
      _model.countDown--;
      _model.refresh();
      if (_model.countDown <= 0) {
        _model.countDownFinished = true;
        _model.countDown = GlobalParams.COUNT_DOWN_MAX;
        timer.cancel();
        timer = null;
        _model.refresh();
      }
    });
  }

  onClickResendCode() {
    if (_model.countDownFinished) {
      _model.countDownFinished = false;
      validationTimerCountDown();
      _model.refresh();
    }
  }

  onUsernameComplete() {
    _model.passwordFocusNode.requestFocus();
  }

  onPasswordComplete() {
    onClickSignInButton();
  }
}
