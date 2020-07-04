import 'package:flutter/material.dart';

class Separator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor,
      height: 1,
    );
  }
}