import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTagSelectable extends StatefulWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double textSize;
  final double borderWidth;
  final int textWeight;
  final onTap;
  final bool selected;
  final Color selectedTextColor;
  final Color selectedBorderColor;
  final Color selectedColor;

  CategoryTagSelectable(
      {this.text,
      this.color = Colors.transparent,
      this.borderColor = CMColors.blueLonely,
      this.textColor = CMColors.blueLonely,
      this.selectedColor = CMColors.blueLonely,
      this.selectedBorderColor = CMColors.blueLonely,
      this.selectedTextColor = Colors.white,
      this.textSize = 14,
      this.textWeight = 400,
      this.borderWidth = 1.0,
      this.selected = false,
      this.onTap});

  @override
  State<StatefulWidget> createState() => _CategorySelectableState(selected);
}

class _CategorySelectableState extends State<CategoryTagSelectable> {
  bool selected;

  _CategorySelectableState(this.selected);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap();
        }
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(0),
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(0)),
        decoration: BoxDecoration(
            color: selected ? widget.selectedColor : widget.color,
            border: Border.all(
                color:
                    selected ? widget.selectedBorderColor : widget.borderColor,
                width: widget.borderWidth,
                style: BorderStyle.solid),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15)))),
        child: Text(
          widget.text,
          style: TextUtil.style(widget.textSize, widget.textWeight,
              color: selected ? widget.selectedTextColor : widget.textColor),
        ),
      ),
    );
  }
}
