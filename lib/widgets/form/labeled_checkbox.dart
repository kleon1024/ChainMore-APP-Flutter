import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key key,
    this.child,
    this.value,
    this.onChanged,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: child,
          ),
          Checkbox(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
