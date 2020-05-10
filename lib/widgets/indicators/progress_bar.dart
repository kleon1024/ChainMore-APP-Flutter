import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatelessWidget {

  final double percent;
  final Color color;

  ProgressBar({this.percent, this.color});

  @override
  Widget build(BuildContext context) {

    return LinearProgressIndicator(
      value: percent,
      valueColor: AlwaysStoppedAnimation<Color>(color != null ? color : Colors.blue),
      backgroundColor: Colors.grey[400],
    );
  }
}