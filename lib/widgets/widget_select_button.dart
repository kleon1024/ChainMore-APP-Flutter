import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/choice.dart';
import 'package:chainmore/models/choiceproblem.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_button.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectButton extends StatefulWidget {
  final String text;
  final Function func;
  final bool initState;

  SelectButton(this.text, {this.func, this.initState = false});

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.initState;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });

        if (widget.func != null) {
          widget.func(selected);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(15),
            horizontal: ScreenUtil().setHeight(25)),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: selected ? CMColors.blueLonely : Colors.transparent,
              width: 1.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil().setHeight(25)),
          ),
        ),
        child: Text(widget.text,
            textAlign: TextAlign.start, style: TextUtil.style(16, 400)),
      ),
    );
  }
}
