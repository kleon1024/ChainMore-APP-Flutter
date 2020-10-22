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
                            height: ScreenUtil().setHeight(1920),
                            padding:
                                EdgeInsets.symmetric(horizontal: model.padding),
                            child: Form(
                              key: model.formKey,
                              child: Stack(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VEmptyView(180),
                                    model.authState == AuthState.MAIN
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(30)),
                                            child: Text(
                                              tr('sign_in_title'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(TextStyle(
                                                      fontSize: 34,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          )
                                        : VEmptyView(0),
                                    model.authState == AuthState.VALIDATE_PHONE
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(30)),
                                            child: Text(
                                              tr('hint_fill_validation_code'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                          )
                                        : VEmptyView(0),
                                    model.authState == AuthState.VALIDATE_PHONE
                                        ? VEmptyView(180)
                                        : VEmptyView(0),
                                    model.authState == AuthState.VALIDATE_PHONE
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(120)),
                                            child: PinCodeTextField(
                                              appContext: context,
                                              length: 4,
                                              showCursor: false,
                                              animationType: AnimationType.none,
                                              pinTheme: PinTheme(
                                                shape:
                                                    PinCodeFieldShape.underline,
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                selectedColor: Theme.of(context)
                                                    .accentColor,
                                                inactiveColor: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                              animationDuration:
                                                  Duration(milliseconds: 0),
                                              backgroundColor:
                                                  Colors.transparent,
                                              keyboardType:
                                                  TextInputType.number,
                                              beforeTextPaste: (text) {
                                                print(
                                                    "Allowing to paste $text");
                                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                return true;
                                              },
                                            ),
                                          )
                                        : VEmptyView(0),
                                    VEmptyView(30),
                                    model.authState == AuthState.VALIDATE_PHONE
                                        ? Container(
                                            width: ScreenUtil().setWidth(
                                                1080 - model.padding / 2),
                                            child: FlatButton(
                                              onPressed: model.logic.onClickResendCode,
                                              child: Text(
                                                model.countDownFinished
                                                    ? tr(
                                                        "resend_validation_code")
                                                    : tr("hint_resend_validation_code") +
                                                        model.countDown
                                                            .toString() +
                                                        tr("hint_resend_validation_code_1"),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(),
                                              ),
                                            ),
                                          )
                                        : VEmptyView(0),
                                    model.authState == AuthState.MAIN
                                        ? TextFormField(
                                            validator:
                                                model.logic.validatePhoneNumber,
                                            keyboardType: TextInputType.phone,
                                            controller:
                                                model.phoneController,
                                            decoration: InputDecoration(
                                                hintText: tr('phone_number'),
                                                prefixIcon: Icon(
                                                  Icons.phone_iphone,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                )),
                                          )
                                        : VEmptyView(0),
                                  ],
                                ),
                                model.authState == AuthState.MAIN
                                    ? Positioned(
                                        bottom: ScreenUtil().setHeight(180),
                                        child: Container(
                                          width: ScreenUtil().setWidth(
                                              1080 - model.padding / 2),
                                          child: FlatButton(
                                            splashColor: Colors.transparent,
                                            color:
                                                Theme.of(context).accentColor,
                                            textColor:
                                                Theme.of(context).primaryColor,
                                            onPressed:
                                                model.logic.onClickSignInButton,
                                            child: Text(
                                              tr("sign_in_button_text"),
                                            ),
                                          ),
                                        ),
                                      )
                                    : VEmptyView(0),
                                model.authState != AuthState.MAIN
                                    ? Positioned(
                                        bottom: ScreenUtil().setHeight(80),
                                        child: Container(
                                          width: ScreenUtil().setWidth(
                                              1080 - model.padding / 2),
                                          child: FlatButton(
                                            onPressed: model.logic.onClickReturn,
                                            child: Text(
                                              tr("auth_return"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                    : VEmptyView(0),
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
