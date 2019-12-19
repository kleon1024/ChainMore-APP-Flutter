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

  CommonButton({
    @required this.callback,
    @required this.content,
    this.width = 250,
    this.height = 50,
    this.fontSize = 18,
    this.color = Colors.lightBlueAccent,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: borderColor, width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(height / 2),
          ),
        ),
        child: Center(
          child: Text(
            content,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
