import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/action_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultCard extends StatelessWidget {
  final onTap;
  final onLongPress;

  DefaultCard({Key key, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(60)),
            child: ActionIndicator(
              icon: Icon(
                Icons.play_arrow,
                size: 32,
              ),
              text: "开始探索吧！",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
