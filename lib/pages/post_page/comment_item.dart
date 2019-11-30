import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentItem extends StatelessWidget {
  final Comment item;

  CommentItem({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VEmptyView(10),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    item.author.nickname,
                    style: TextUtil.style(14, 400),
                  ),
                ),
                HEmptyView(10),
                Text(
                  Utils.readableTimeStamp(item.timestamp),
                  style: TextUtil.style(14, 400),
                )
              ],
            ),
            VEmptyView(10),
            Text(
              item.body,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(42),
              ),
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.justify,
            ),
            VEmptyView(20),
          ],
        ),
      ),
    );
  }
}
