import 'package:fluttertoast/fluttertoast.dart';

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
    print(timestamp);
    List res = timestamp.split(" ");
    assert(res.length == 6);
    var datetimeStr = res[3] + monthMap[res[2]] + res[1] + " " + res[4];
    var datetime = DateTime.parse(datetimeStr);
    var currentDatetime = DateTime.now();
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
}
