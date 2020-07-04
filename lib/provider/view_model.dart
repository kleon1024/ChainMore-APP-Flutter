import 'package:flutter/cupertino.dart';

class ViewModel extends Comparable {

  DateTime timestamp = DateTime.now();

  Widget build() {
    return Container();
  }

  @override
  int compareTo(other) {
    return timestamp.millisecondsSinceEpoch -
        other.timestamp.millisecondsSinceEpoch;
  }
}
