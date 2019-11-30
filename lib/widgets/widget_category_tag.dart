import 'package:chainmore/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTag extends StatelessWidget {

  final String text;
  final Color color;

  CategoryTag({this.text, this.color = CMColors.blueLonely});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(5),
          ScreenUtil().setWidth(0),
          ScreenUtil().setWidth(5),
          ScreenUtil().setWidth(0)),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: color,
              width: 1.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil().setWidth(15)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}