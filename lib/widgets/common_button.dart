import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback callback;
  final String content;
  final double width;
  final double height;
  final double fontSize;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;
  final int fontWeight;
  final double borderRadius;

  CommonButton({
    @required this.callback,
    @required this.content,
    this.width = 250,
    this.height = 50,
    this.fontSize = 18,
    this.color = Colors.lightBlueAccent,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
    this.borderWidth = 1.0,
    this.fontWeight = 400,
    this.borderRadius = 25
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: borderColor, width: borderWidth, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: Center(
          child: Text(
            content,
            style: TextUtil.style(fontSize, fontWeight, color: textColor),
          ),
        ),
      ),
    );
  }
}
