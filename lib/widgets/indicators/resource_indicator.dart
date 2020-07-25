import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceIndicator extends StatelessWidget {
  final icon;

  ResourceIndicator(
    this.icon,
  );

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: Theme.of(context).textTheme.subtitle1.fontSize,
      color: Theme.of(context).textTheme.bodyText1.color,
    );
  }
}
