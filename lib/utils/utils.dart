import 'dart:async';
import 'dart:io';

import 'package:chainmore/application.dart';
import 'package:chainmore/models/update.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flushbar/flushbar_route.dart' as route;

class Utils {
  static void showToast(BuildContext context, String msg) {
//    Fluttertoast.showToast(context,
//        msg: msg,
//        gravity: ToastGravity.CENTER,
//        toastLength: Toast.LENGTH_SHORT);

    final flushbar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Text(
        msg,
        style: TextUtil.style(14, 700, color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      backgroundColor: CMColors.blueLonely,
      flushbarStyle: FlushbarStyle.FLOATING,
    );

    final _route = route.showFlushbar(
      context: context,
      flushbar: flushbar,
    );

    Navigator.of(context, rootNavigator: true).push(_route);
  }

  static Map<String, String> monthMap = {
    "Jan": "01",
    "Feb": "02",
    "Mar": "03",
    "Apr": "04",
    "May": "05",
    "Jun": "06",
    "Jul": "07",
    "Aug": "08",
    "Sep": "09",
    "Oct": "10",
    "Nov": "11",
    "Dec": "12"
  };

  static String readableTimeStamp(String timestamp) {
    List res = timestamp.split(" ");
    assert(res.length == 6);
    var datetimeStr = res[3] + monthMap[res[2]] + res[1] + " " + res[4] + "Z";
    var datetime = DateTime.parse(datetimeStr);
    var currentDatetime = DateTime.now().toUtc();
    var ms = currentDatetime.millisecondsSinceEpoch -
        datetime.millisecondsSinceEpoch;
    var second = ms / 1000;
    var minute = second / 60;
    var hour = minute / 60;
    var day = hour / 24;
    var month = day / 30.4375;
    var year = month / 12;

    String prefix = "前";
    if (ms < 0) {
      prefix = "后";
      ms = -ms;
    }

    if (year >= 1) {
      return year.floor().toString() + "年" + prefix;
    }
    if (month >= 1) {
      return month.floor().toString() + "个月" + prefix;
    }
    if (day >= 1) {
      return day.floor().toString() + "天" + prefix;
    }
    if (hour >= 1) {
      return hour.floor().toString() + "小时" + prefix;
    }
    if (minute >= 1) {
      return minute.floor().toString() + "分钟" + prefix;
    }
    return "1分钟内";
  }

  static checkClipBoard({BuildContext context}) async {
    ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text.trim() != '') {
      String _name = clipboardData.text.trim();
      String lastUrl = "";
      if (Application.sp.containsKey('last_url')) {
        lastUrl = Application.sp.getString('last_url');
      }

      String url = RegExp(
              r'(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]')
          .stringMatch(_name);

      if (url != null && url != "" && lastUrl != url) {
        Application.sp.setString('last_url', url);

        showDoubleChoiceDialog(
          context,
          title: '检测到链接',
          body: url,
          leftText: '取消',
          rightText: '分享',
          leftFunc: () {
            Navigator.of(context).pop();
          },
          rightFunc: () {
            EditModel editModel = Provider.of<EditModel>(context);
            if (url != _name) {
              editModel.setBody(_name);
            }
            editModel.setUrl(url);
            Navigator.of(context).pop();
            NavigatorUtil.goEditPage(context);
          },
        );
      }
    }
  }

  static bool isEmail(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(r"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$")
        .hasMatch(input);
  }

  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    return mobile.hasMatch(input);
  }

  static bool isUserName(String input) {
    RegExp mobile = new RegExp(r"[0-9A-Za-z_]{6,16}$");
    return mobile.hasMatch(input);
  }

  static showDoubleChoiceDialog(
    BuildContext context, {
    String title = "",
    String body = "",
    String leftText = "取消",
    Function leftFunc,
    Color leftColor = CMColors.blueLonely,
    String rightText = "确认",
    Function rightFunc,
    Color rightColor = CMColors.blueLonely,
  }) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: body != ""
              ? Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(body,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          wordSpacing: 1.2)),
                )
              : Container(),
          actions: <Widget>[
            CupertinoButton(
              child: Text(leftText,
                  style: TextUtil.style(16, 600, color: leftColor)),
              onPressed: () {
                if (leftFunc != null) {
                  leftFunc();
                }
              },
            ),
            CupertinoButton(
              child: Text(rightText,
                  style: TextUtil.style(16, 600, color: rightColor)),
              onPressed: () {
                if (rightFunc != null) {
                  rightFunc();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
