import 'package:chainmore/models/post.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
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
        print("A");
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                topRight: Radius.circular(ScreenUtil().setWidth(50))),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0x0b000000),
                  offset: Offset(0, -5),
                  blurRadius: 3),
            ],
          ),
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(40),
              bottom: ScreenUtil().setHeight(20),
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(item.domain.title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(40),
                          )),
                      HEmptyView(5),
                      Text(item.domain.watchers.toString() + item.domain.bio,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(40)))
                    ],
                  ),
                ),
              ),
              VEmptyView(10),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(5),
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setWidth(5),
                        ScreenUtil().setWidth(0)),
                    decoration: BoxDecoration(
                        color: CMColors.blueLonely,
                        border: Border.all(
                            color: CMColors.blueLonely,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(15)))),
                    child: Text(
                      item.category,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              VEmptyView(10),
              Text(
                item.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(48),
                ),
              ),
              VEmptyView(5),
              Text(
                item.author.nickname,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(38),
                ),
              ),
              VEmptyView(5),
              item.description != "" ? Text(
                item.description,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(42),
                ),
                softWrap: true,
                maxLines: 3,
                textAlign: TextAlign.justify,
              ) : VEmptyView(0),
              VEmptyView(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "看过 " + item.comments.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  Text(
                    "力荐 " + item.votes.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  Text(
                    "评论 " + item.comments.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  Text(
                    "收藏 " + item.collects.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
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
