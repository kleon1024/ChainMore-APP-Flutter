import 'package:chainmore/models/domain.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchDomainWidget extends StatelessWidget {

  final Domain domain;

  SearchDomainWidget({this.domain});

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
        ],
      ),
    );
  }

}
