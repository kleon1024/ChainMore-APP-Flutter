import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Utils {
  static void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
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

  static String lastUrl = "";

  static checkClipBoard({BuildContext context}) async {
    ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text.trim() != '') {
      String _name = clipboardData.text.trim();

      String url = RegExp(
              r'(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]')
          .stringMatch(_name);

      if (url != "" && lastUrl != url) {
        lastUrl = url;

        showDialog<Null>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
                title: Text('分享链接'),
                content: Column(
                  children: <Widget>[
                    VEmptyView(20),
                    Text(url),
                    VEmptyView(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(0),
                            child: Text('取消分享', style: TextUtil.style(16, 600, color: Colors.grey)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            EditModel editModel =
                                Provider.of<EditModel>(context);
                            editModel.setUrl(url);
                            Navigator.of(context).pop();
                            NavigatorUtil.goEditPage(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(0),
                            child: Text('前往分享', style: TextUtil.style(16, 600, color: CMColors.blueLonely)),
                          ),
                        )
                      ],
                    )
                  ],
                ));
          },
        );
      }
    }
  }

  static bool isEmail(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(r"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$").hasMatch(input);
  }

  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9$%^&*]+$)(?![a-zA-Z]+$)[0-9A-Za-z$%^&*]{6,16}$");
    return mobile.hasMatch(input);
  }

  static bool isUserName(String input) {
    RegExp mobile = new RegExp(r"[0-9A-Za-z_]{6,16}$");
    return mobile.hasMatch(input);
  }

}
