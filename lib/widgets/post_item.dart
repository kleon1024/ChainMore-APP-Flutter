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
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(item.domain.title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                      HEmptyView(5),
                      Text(item.domain.watchers.toString() + item.domain.bio,
                          style: TextStyle(color: Colors.grey, fontSize: 14))
                    ],
                  ),
                ),
              ),
              VEmptyView(10),
              Row(
                children: <Widget>[
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
//              VEmptyView(10),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Icon(Icons.thumb_up),
//                  Icon(Icons.comment),
//                  Icon(Icons.bookmark_border),
//                  Icon(
//                    Icons.share,
//                  ),
//                  Icon(Icons.more_horiz)
//                ],
//              )
            ],
          )),
    );
  }
}
