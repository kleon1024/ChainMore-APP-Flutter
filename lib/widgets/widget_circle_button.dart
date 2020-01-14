import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiCircleButton extends StatelessWidget {
  final Function onTap;
  final Emoji emoji;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double emojiSize;

  EmojiCircleButton({
    this.onTap,
    this.emoji,
    this.color = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.emojiSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
//        padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
        child: Container(
//          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
                color: borderColor,
                width: borderWidth,
                style: BorderStyle.solid),
          ),
          child: Text(emoji.emoji + " " + emoji.count.toString(), style: TextUtil.style(emojiSize, 300, color: Colors.grey)),
        ),
      ),
    );
  }
}
