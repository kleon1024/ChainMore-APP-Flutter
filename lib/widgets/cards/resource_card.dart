import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/pages/webview/web_view_page.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceCard extends StatelessWidget {
  final void Function() onTap;
  final void Function() onLongPress;
  final ResourceBean bean;
  final double elevation;
  final double verticalPadding;
  final double horizontalPadding;
  final Color color;

  ResourceCard({
    Key key,
    this.bean,
    this.onLongPress,
    this.onTap,
    this.elevation,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
    this.color,
  })  : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
              return WebViewPage(url: bean.url);
            }));
          },
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: color ?? Theme.of(context).cardColor,
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
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Utils.getShortUrl(bean.url),
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
