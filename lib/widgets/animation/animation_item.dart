import 'package:flutter/material.dart';

class AnimationItem extends StatelessWidget {
  const AnimationItem({
    Key key,
    @required this.animation,
    @required this.child,
  })  : assert(animation != null),
        assert(child != null),
        super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: child,
    );
  }
}
