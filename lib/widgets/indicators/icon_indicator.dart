import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconIndicator extends StatelessWidget {
  final icon;
  final text;

  IconIndicator({
    @required this.icon,
    this.text = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          icon,
          HEmptyView(ScreenUtil().setWidth(5)),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
      padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
    );
  }
}
