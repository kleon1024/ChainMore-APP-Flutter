import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/sparkle.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SparkleItem extends StatelessWidget {
  final Sparkle item;
  final bool showReplied;

  SparkleItem({
    @required this.item,
    this.showReplied = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goSparkleDetailPage(context, data: item);
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
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      NavigatorUtil.goUserPage(context, data: item.author);
                    },
                    child: Text(
                      item.author.nickname,
                      style: TextUtil.style(14, 700),
                    ),
                  ),
                ],
              ),
              VEmptyView(10),
              item.body != null && item.body != ""
                  ? Text(
                      item.body,
                      style: TextUtil.style(14, 400, color: Colors.black87),
                      softWrap: true,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    )
                  : VEmptyView(0),
              VEmptyView(10),
//              Container(
//                child: ,
//              ),
              (showReplied && item.replied != null)
                  ? CategoryTag(
                      text: item.replied.body,
                      color: Colors.white,
                      textColor: CMColors.blueLonely,
                      onTap: () {
                        NavigatorUtil.goSparkleDetailPage(context,
                            data: item.replied);
                      },
                    )
                  : VEmptyView(0),
              (showReplied && item.replied != null)
                  ? VEmptyView(0)
                  : VEmptyView(0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Utils.readableTimeStamp(item.timestamp),
                    style: TextUtil.style(14, 400, color: Colors.black54),
                  ),
                  Text(
                    "共鸣 " + item.votes.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  Icon(Icons.more_horiz,
                      color: Colors.black54, size: ScreenUtil().setSp(60))
                ],
              ),
              (item.replies.length > 0) ? VEmptyView(0) : VEmptyView(0),
              (item.replies.length > 0)
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0x10000000),
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(20)),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "热门共鸣:",
                            style: TextUtil.style(14, 700),
                          ),
                          VEmptyView(10),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.replies[index].author.nickname +
                                            ": ",
                                        style: TextUtil.style(14, 600),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.replies[index].body,
                                          style: TextUtil.style(14, 400),
                                          softWrap: true,
                                          maxLines: 10,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: item.replies.length),
                        ],
                      ),
                    )
                  : VEmptyView(0),
            ],
          ),
        ),
      ),
    );
  }
}
