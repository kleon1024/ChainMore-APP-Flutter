import 'package:chainmore/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThinBorderButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;

  ThinBorderButton({
    @required this.text,
    this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      content: text,
      callback: onTap,
      fontSize: 14,
      fontWeight: 300,
      color: Colors.transparent,
      borderColor: color,
      textColor: color,
      borderWidth: 0.5,
      borderRadius: ScreenUtil().setWidth(20),
      width: double.infinity,
      height: ScreenUtil().setHeight(90),
    );
  }
}
