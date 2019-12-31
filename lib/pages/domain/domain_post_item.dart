import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DomainPostItem extends StatelessWidget {
  final Post item;
  final Domain domain;

  DomainPostItem({
    @required this.item,
    @required this.domain,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goPostPage(context, data: item);
      },
      child: Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Row(children: <Widget>[CategoryTag(text: item.category)]),
              VEmptyView(10),
              Text(item.title, style: w600_16TextStyle),
              VEmptyView(5),
              item.url != ""
                  ? CategoryTag(
                      text: item.url.split("/")[2],
                      color: Colors.white,
                      textColor: CMColors.blueLonely,
                      onTap: () {
                        NavigatorUtil.goWebViewPage(context,
                            web: Web(url: item.url, post: item));
                      },
                    )
                  : VEmptyView(5),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      NavigatorUtil.goUserPage(context, data: item.author);
                    },
                    child: Text(
                      item.author.nickname,
                      style: w400_13TextStyle,
                    ),
                  ),
                  domain.id != item.domain.id
                      ? Text("  @", style: w400_13TextStyle)
                      : VEmptyView(0),
                  domain.id != item.domain.id
                      ? GestureDetector(
                          onTap: () {
                            NavigatorUtil.goDomainPage(context,
                                data: item.domain);
                          },
                          child: Text(
                            item.domain.title,
                            style: w400_13TextStyle,
                          ),
                        )
                      : VEmptyView(0),
                ],
              ),
              VEmptyView(10),
              item.description != ""
                  ? Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(42),
                      ),
                      softWrap: true,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    )
                  : VEmptyView(0),
              VEmptyView(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
//                  Text(
//                    "看过 " + item.comments.toString(),
//                    style: TextStyle(
//                        fontSize: ScreenUtil().setSp(38),
//                        fontWeight: FontWeight.w500,
//                        color: Colors.black54),
//                  ),
//                  Text(
//                    "力荐 " + item.votes.toString(),
//                    style: TextStyle(
//                        fontSize: ScreenUtil().setSp(38),
//                        fontWeight: FontWeight.w500,
//                        color: Colors.black54),
//                  ),
                  Text(
                    Utils.readableTimeStamp(item.timestamp),
                    style: TextUtil.style(14, 400, color: Colors.black54),
                  ),
                  Text(
                    "评论 " + item.comments.toString(),
                    style: TextUtil.style(14, 400, color: Colors.black54),
                  ),
//                  Text(
//                    "收藏 " + item.collects.toString(),
//                    style: TextStyle(
//                        fontSize: ScreenUtil().setSp(38),
//                        fontWeight: FontWeight.w500,
//                        color: Colors.black54),
//                  ),
                  Icon(Icons.more_horiz,
                      color: Colors.black54, size: ScreenUtil().setSp(60))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
