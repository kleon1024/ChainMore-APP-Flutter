import 'package:chainmore/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTag extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;

  CategoryTag(
      {this.text,
      this.color = CMColors.blueLonely,
      this.borderColor = CMColors.blueLonely,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(10),
          ScreenUtil().setWidth(0),
          ScreenUtil().setWidth(10),
          ScreenUtil().setWidth(0)),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: borderColor, width: 1.0, style: BorderStyle.solid),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }
}
