import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceCard extends StatelessWidget {
  final void Function() onTap;
  final ResourceBean bean;
  final double elevation;
  final double verticalPadding;
  final double horizontalPadding;

  ResourceCard({
    Key key,
    this.bean,
    this.onTap,
    this.elevation,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
  })  : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            /// TODO: Go Resource Detail Page
          },
      child: Container(
        height: ScreenUtil().setHeight(200),
        child: Card(
          elevation: elevation,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bean.title,
                  style: Theme.of(context).textTheme.bodyText1,
                  softWrap: false,
                ),
                Text(
                  Utils.getShortUrl(bean.url),
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
