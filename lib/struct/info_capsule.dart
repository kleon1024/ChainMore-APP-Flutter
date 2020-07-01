import 'package:flutter/cupertino.dart';

class InfoCapsule extends Comparable<InfoCapsule> {
  InfoType type;
  DateTime updateTime;
  dynamic info;

  InfoCapsule({
    @required this.type,
    @required this.updateTime,
    @required this.info,
  });

  @override
  int compareTo(other) {
    return updateTime.millisecondsSinceEpoch -
        other.updateTime.millisecondsSinceEpoch;
  }
}

enum InfoType { ResourceType }
