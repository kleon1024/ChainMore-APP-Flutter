import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/pages/post/widget_post_header.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostItem extends StatelessWidget {
  final Post item;

  PostItem({
    @required this.item,
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
              Hero(
                tag: "post_item_" + item.id.toString(),
                child: Material(
                  child: PostHeader(item),
                  color: Colors.transparent,
                ),
              ),
              VEmptyView(5),
              item.description != ""
                  ? Text(
                      item.description,
                      style: TextUtil.style(14, 400),
                      softWrap: true,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    )
                  : VEmptyView(0),
              VEmptyView(10),
              GestureDetector(
                onTap: () {
                  NavigatorUtil.goUserPage(context, data: item.author);
                },
                child: Text(
                  item.author.nickname,
                  style: TextUtil.style(13, 500, color: Colors.black45),
                ),
              ),
              VEmptyView(10),
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
