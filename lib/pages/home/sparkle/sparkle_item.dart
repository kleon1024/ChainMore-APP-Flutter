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

  SparkleItem({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

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
                    onTap: () {},
                    child: Text(item.author.nickname,
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
              VEmptyView(20),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
