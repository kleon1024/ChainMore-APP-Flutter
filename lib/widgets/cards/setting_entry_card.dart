import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingEntryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goExploreRoadmapPage(context);
      },
      onLongPress: () {
        print("Long pressed");
      },
      child: Container(
        color: Colors.white,
        height: ScreenUtil().setHeight(120),
        width: double.infinity,
        child: Center(
          child: Text(
            "退出登录",
            style: commonSubtitleTextStyle,
          ),
        ),
      ),
    );
  }
}
