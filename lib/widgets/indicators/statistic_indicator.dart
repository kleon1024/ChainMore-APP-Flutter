import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticIndicator extends StatelessWidget {
  final icon;
  final text;
  final border;
  final TextStyle style;
  final Function onTap;
  final int number;

  StatisticIndicator({
    this.icon,
    this.text = "",
    this.border = BorderSide.none,
    this.style,
    this.onTap,
    this.number = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(children: [
              icon != null ? icon : HEmptyView(0),
              Text(Utils.readableNumber(number), style: TextUtil.style(20, 900)),
            ]),
            VEmptyView(5),
            Text(
              text,
              style: TextUtil.style(16, 900),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setHeight(10),
          vertical: ScreenUtil().setWidth(10),
        ),
      ),
    );
  }
}
