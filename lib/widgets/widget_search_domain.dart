import 'package:chainmore/models/domain.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchDomainWidget extends StatelessWidget {
  final Domain domain;
  final bool login;

  SearchDomainWidget({this.domain, this.login = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            domain.title,
            style: TextUtil.style(15, 400),
          ),
          login
              ? domain.depended
                  ? HEmptyView(0)
                  : CategoryTag(
                      text: "前置未认证",
                      color: Colors.transparent,
                      textColor: CMColors.blueLonely,
                    )
              : CategoryTag(
                  text: "未登录",
                  color: Colors.transparent,
                  textColor: CMColors.blueLonely)
        ],
      ),
    );
  }
}
