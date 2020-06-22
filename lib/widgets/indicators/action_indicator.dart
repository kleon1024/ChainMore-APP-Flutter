import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionIndicator extends StatelessWidget {
  final icon;
  final text;
  final border;
  final style;
  final onTap;

  ActionIndicator({
    @required this.icon,
    this.text = "",
    this.border = BorderSide.none,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(150),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setHeight(90)),
                  side: border,
                ),
                child: icon,
              ),
            ),
            VEmptyView(5),
            text != ""
                ? Text(
                    text,
                    style: style != null ? style : Theme.of(context).textTheme.bodyText1,
                  )
                : VEmptyView(0),
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
