import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTag extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double textSize;
  final double borderWidth;
  final int textWeight;
  final onTap;

  CategoryTag(
      {this.text,
      this.color = CMColors.blueLonely,
      this.borderColor = CMColors.blueLonely,
      this.textColor = Colors.white,
      this.textSize = 11,
      this.textWeight = 400,
      this.borderWidth = 1.0,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(0),
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(0)),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
                color: borderColor,
                width: borderWidth,
                style: BorderStyle.solid),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15)))),
        child: Text(
          text,
          style: TextUtil.style(textSize, textWeight, color: textColor),
        ),
      ),
    );
  }
}
