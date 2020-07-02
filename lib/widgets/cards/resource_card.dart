import 'package:chainmore/json/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceCard extends StatelessWidget {
  final void Function() onTap;
  final ResourceBean bean;

  ResourceCard({Key key, this.bean, this.onTap})
      : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setHeight(200),
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
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
                  bean.url,
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
