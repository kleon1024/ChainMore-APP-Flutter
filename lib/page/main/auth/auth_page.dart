import 'dart:async';
import 'dart:convert';

import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/model/auth_page_model.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthPageModel>(context);
    final userDao = Provider.of<UserDao>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          body: Container(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              onVerticalDragDown: (drag) {
                FocusScope.of(context).unfocus();
              },
              child: CupertinoScrollbar(
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            height: ScreenUtil.screenHeightDp,
                            padding:
                                EdgeInsets.symmetric(horizontal: model.padding),
                            child: Form(
                              key: model.formKey,
                              child: Stack(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VEmptyView(180),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(30)),
                                      child: Text(
                                        tr('sign_in_title'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                fontSize: 34,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    VEmptyView(60),
                                    TextFormField(
                                      autofocus: true,
                                      focusNode: model.usernameFocusNode,
                                      validator: model.logic.validateUserName,
                                      keyboardType: TextInputType.text,
                                      controller: model.usernameController,
                                      decoration: InputDecoration(
                                        hintText: tr('username'),
                                        prefixIcon: Icon(
                                          Icons.group,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      onEditingComplete: model.logic.onUsernameComplete,
                                    ),
                                    VEmptyView(30),
                                    TextFormField(
                                      validator: model.logic.validatePassword,
                                      obscureText: model.showPassword,
                                      keyboardType: TextInputType.text,
                                      controller: model.passwordController,
                                      decoration: InputDecoration(
                                        hintText: tr('password'),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      onEditingComplete: model.logic.onPasswordComplete,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: ScreenUtil().setHeight(180),
                                  child: Container(
                                    width: ScreenUtil()
                                            .setWidth(ScreenUtil().width) -
                                        model.padding * 2,
                                    child: FlatButton(
                                      splashColor: Colors.transparent,
                                      color: Theme.of(context).accentColor,
                                      textColor: Theme.of(context).primaryColor,
                                      onPressed:
                                          model.logic.onClickSignInButton,
                                      child: model.isSigningIn
                                          ? CupertinoActivityIndicator()
                                          : Text(
                                              tr("sign_in_button_text"),
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
