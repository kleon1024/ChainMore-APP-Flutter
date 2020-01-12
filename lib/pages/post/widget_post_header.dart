import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostHeader extends StatelessWidget {
  final Post item;
  final bool domain;

  PostHeader(this.item, {this.domain = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          domain ? Hero(
            tag: "post_item_domain" + item.id.toString(),
            child: Material(
              child: GestureDetector(
                onTap: () {
                  NavigatorUtil.goDomainPage(context, data: item.domain);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              item.domain.title,
                              style: TextUtil.style(14, 500,
                                  color: CMColors.blueLonely),
                            ),
                            HEmptyView(10),
                            Text(
                              item.domain.watchers.toString() + item.domain.bio,
                              style: TextUtil.style(13, 500,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: Colors.black54, size: ScreenUtil().setSp(60)),
                    ],
                  ),
                ),
              ),
              color: Colors.transparent,
            ),
          ) : VEmptyView(0),
          Hero(
            tag: "post_item_title" + item.id.toString(),
            child: Material(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: List<Widget>.from(item.categories.map((item) {
                      return Container(
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: CategoryTag(
                          text: item.category,
                        ),
                      );
                    }))),
                    VEmptyView(5),
                    Text(item.title, style: TextUtil.style(16, 700)),
                    VEmptyView(5),
                    item.url != ""
                        ? CategoryTag(
                      text: item.url.split("/")[2],
                      color: Colors.transparent,
                      textColor: CMColors.blueLonely,
                      onTap: () {
                        NavigatorUtil.goWebViewPage(context,
                            web: Web(url: item.url, post: item));
                      },
                    )
                        : VEmptyView(0),
                  ],
                ),
              ),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
