import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleCachedImageCard extends StatelessWidget {
  final Function onTap;

  CircleCachedImageCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: ClipOval(
              child: CachedNetworkImage(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setHeight(120),
                fit: BoxFit.cover,
                imageUrl:
                "http://i.serengeseba.com/uploads/i_2_2608823560x2626403468_26.jpg",
                placeholder: (context, url) => AvatarPlaceholder(),
              ),
            ),
            onTap: onTap,
          )
        ],
      ),
    );
  }
}

class AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(120),
      height: ScreenUtil().setHeight(120),
      color: Colors.blue,
      child: Center(
        child: Text(
          'CM',
          style: TextUtil.style(18, 300, color: Colors.white),
        ),
      ),
    );
  }
}
