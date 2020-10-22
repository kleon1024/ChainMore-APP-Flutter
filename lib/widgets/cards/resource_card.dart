import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/resource_detail_page_model.dart';
import 'package:chainmore/page/main/resource_detail_page.dart';
import 'package:chainmore/pages/webview/web_view_page.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
    this.verticalPadding = 5.0,
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
              return ProviderConfig.getInstance().getResourceDetailPage(bean);
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bean.title,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(fontWeight: FontWeight.w600)
                        ),
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
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.all_inclusive),
                  onPressed: () {
                    Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
                      return WebViewPage(url: bean.url);
                    }));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
